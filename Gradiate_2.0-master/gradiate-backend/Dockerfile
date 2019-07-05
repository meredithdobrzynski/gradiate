FROM python:3.6

COPY . . 
RUN python3 -m pip install -r src/requirements.txt 
RUN python3 -m pip install google-cloud
RUN python3 -m pip install google-cloud-vision
EXPOSE 5000 

WORKDIR src
CMD python3 routes.py
