from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Gradient(db.Model):
    __tablename__ = 'gradients'
    id = db.Column(db.Integer, primary_key=True)
    base64 = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.base64 = kwargs.get('base64', '')

    def serialize(self):
        return {
            'id': self.id,
            'base64': self.base64
        }