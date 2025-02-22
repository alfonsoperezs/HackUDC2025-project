from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class TaskDb(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(200), nullable = False)
    start_date = db.Column(db.DateTime, default = datetime.now())
    end_date = db.Column(db.DateTime, default = datetime.now())
    checked = db.Column(db.Boolean, default=False)

