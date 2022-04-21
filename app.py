import json
import sqlite3
import flask

app = flask.Flask(__name__)
# создание функции запроса к БД для вывода строки по ID
def get_by_id(id):
    with sqlite3.connect("animal.db") as connection:
        connection.row_factory = sqlite3.Row
        result = connection.execute(f'''
    SELECT *
    FROM animals
    WHERE "index" = {id}
''').fetchone()
        return dict(result)

@app.get('/<item_id>')
def response(item_id):
    return app.response_class(response=json.dumps(get_by_id(item_id)))

if __name__ == '__main__':
    app.run()