from flask import Flask, request, send_from_directory
from flask import Response
from flask_restful import reqparse, abort, Api, Resource
from flask_swagger_ui import get_swaggerui_blueprint
from flask_cors import CORS
import os
from cassandra.cluster import Cluster
import json
import datetime

@app.route("/")
def hello():
    print(request.headers)
    tmp = "a"
    a=tmp
    return "Hello World!"


if __name__ == "__main__":
    app.run()
