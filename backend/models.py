import json
from datetime import datetime

class Task:
    def __init__(self, id, name, start_date, end_date):
        self.id = id
        self.name = name
        self.start_date = start_date
        self.end_date = end_date

    def to_json(self):
        return json.dumps({
            "id": self.id,
            "name": self.name,
            "start_date": self.start_date.strftime("%Y-%m-%d") if self.start_date else None,
            "end_date": self.end_date.strftime("%Y-%m-%d") if self.end_date else None
        })

    @classmethod
    def from_json(cls, json_str):
        data = json.loads(json_str)
        return cls(**data)

        