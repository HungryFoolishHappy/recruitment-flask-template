from flask import Flask, request, jsonify
from database import db_session
from models import Snack, Drink

app = Flask(__name__)

@app.route('/', methods=["POST"])
def handle_request():
    return "hello world"

@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()
