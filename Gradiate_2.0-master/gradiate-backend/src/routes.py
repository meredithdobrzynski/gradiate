import json
from db import db, Gradient
from flask import Flask, request, jsonify
import colors as vis

db_filename = "images.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()
    
@app.route('/')
@app.route('/images/')
def get_images():
    images = Gradient.query.all()
    res = {'success': True, 'data': [image.serialize() for image in images]} 
    return json.dumps(res), 200

@app.route('/image/', methods=['POST'])
def upload_image():
  post_body = json.loads(request.data)

  gradient = Gradient(
    base64=post_body.get('base64')
  )
  db.session.add(gradient)
  db.session.commit()
  return json.dumps({'success': True, 'data': gradient.serialize()}), 201

# @app.route('/image/<int:image_id>/', methods=['DELETE'])
# def delete_image(image_id):
#   gradient = Gradient.query.filter_by(id=image_id).first()
#   if gradient is not None:
#     db.session.delete(gradient)
#     db.session.commit()
#     return json.dumps({'success': True, 'data': gradient.serialize()}), 200 
#   return json.dumps({'success': False, 'error': 'Gradient not found!'}), 404

@app.route('/delete/', methods=['POST'])
def delete_image():
  post_body = json.loads(request.data)
  image_ids = post_body.get('array')
  for image_id in image_ids: 
    gradient = Gradient.query.filter_by(id=image_id).first()
    if gradient is not None:
      db.session.delete(gradient)
      db.session.commit()
  return json.dumps({'success': True}), 200 


@app.route('/colors/', methods=['POST'])
def get_colors():
  post_body = json.loads(request.data)
  image=post_body.get('image')
  colors = vis.generate_colors(image)
  return json.dumps({'success': True, 'data': colors}), 200 

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=5000, debug=True)
