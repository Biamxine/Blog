import os
import sys
import click
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

#判断当前系统是否是Windows，是则使用sqlite:///，否则使用sqlite:////
is_windows = sys.platform.startswith('win')
if is_windows:
    prefix = 'sqlite:///'
else:
    prefix = 'sqlite:////'

app.config['SQLALCHEMY_DATABASE_URI'] = prefix + os.path.join(app.root_path, "data.sqlite")
# 关闭对模型修改的监控，不建议开启，因为会影响性能
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class User(db.Model):  # 表名将会是 user（自动生成，小写处理）
    id = db.Column(db.Integer, primary_key=True)  # 主键
    name = db.Column(db.String(20))  # 名字

class Movie(db.Model):  # 表名将会是 movie（自动生成，小写处理）
    id = db.Column(db.Integer, primary_key=True)  # 主键
    title = db.Column(db.String(60))  # 电影标题
    year = db.Column(db.String(4))  # 电影年份


#创建一条flask命令，名为initdb，可选选项“--drop”，用于删除数据库
@app.cli.command("initdb")
@click.option('--drop', is_flag=True, help='Create after drop.')
def initdb(drop):
    if drop:
        db.drop_all()
    db.create_all()
    print('Initialized database.')


@app.route('/')
def index():
    user = User.query.first()
    movies = Movie.query.all()
    return render_template('index.html', user=user, movies=movies)


@app.errorhandler(404)
def not_found(e):
    user = User.query.first()
    return render_template('404.html', user=user), 404
