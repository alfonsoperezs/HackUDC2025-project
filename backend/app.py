from flask import Flask, request
from flask_cors import CORS
from taskdao import *
from models import Task

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///task.db'
db.init_app(app)

@app.route('/tasks/<date>', methods=['GET'])
def tasks_by_date(date):
   pass

@app.route('/upload', methods=['POST'])
def upload():
   data = request.get_json()
   print(data)
   task = Task.from_json(data)
   instance = TaskDb(id = task.id, name = task.name, start_date = task.start_date,
                     end_date = task.end_date, checked = task.checked)
   db.session.add(instance)
   db.session.commit()
   return 201

@app.route('/update/<id>', methods=['PUT'])
def update_task(id):
   pass

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=8000, debug=True)