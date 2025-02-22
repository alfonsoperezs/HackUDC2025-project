import json
from datetime import datetime

class Task:
    def __init__(self, id, name, start_date, end_date, checked):
        self.id = id
        self.name = name
        year, month, day = [int(i) for i in start_date.split('-')]
        self.start_date = datetime(year, month, day)
        year, month, day = [int(i) for i in end_date.split('-')]
        self.end_date = datetime(year, month, day)
        self.checked = checked

    def to_json(self):
        return json.dumps({
            "id": self.id,
            "name": self.name,
            "start_date": self.start_date.strftime("%Y-%m-%d") if self.start_date else None,
            "end_date": self.end_date.strftime("%Y-%m-%d") if self.end_date else None,
            "checked": self.checked
        })

    @classmethod
    def from_json(cls, data):
        if isinstance(data, dict):  # Asegúrate de que sea un diccionario
            return cls(**data)  # Usamos el diccionario directamente para crear la instancia
        else:
            raise ValueError("Expected a dictionary, got something else")

        