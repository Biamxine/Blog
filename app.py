from flask import Flask

app = Flask(__name__)

from markupsafe import escape

@app.route('/user/<name>')
def user_page(name):
    return f'User: {escape(name)}'
