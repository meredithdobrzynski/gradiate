import io
import os
import base64

from google.cloud import vision
from google.cloud.vision import types
from flask import Flask, request, jsonify

def generate_colors(input_img): 
  os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "gradiate-f1564b9ee4c5.json"

  client = vision.ImageAnnotatorClient()

  file_name = os.path.join(
    os.path.dirname(__file__), 
    'car.jpg')

  content = input_img 

  image = types.Image(content=base64.b64decode(content))

  response = client.image_properties(image=image)

  props = response.image_properties_annotation

  info = {}
  content = []

  for color in props.dominant_colors.colors:
    content.append({'fraction': color.pixel_fraction, 'red':color.color.red, 
    'green': color.color.green, 'blue': color.color.blue})

  while len(content)>3:
    minentry = min(content, key=lambda x:x['fraction'])
    minindex = content.index(minentry)
    content.pop(minindex)

  return content
