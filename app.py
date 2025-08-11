import os
import sys
import click
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash

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

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))
    username = db.Column(db.String(20))  # 用户名
    password_hash = db.Column(db.String(128))  # 密码散列值

    def set_password(self, password):  # 用来设置密码的方法，接受密码作为参数
        self.password_hash = generate_password_hash(password)  # 将生成的密码保持到对应字段

    def validate_password(self, password):  # 用于验证密码的方法，接受密码作为参数
        return check_password_hash(self.password_hash, password)  # 返回布尔值

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

#创建管理员账户
@app.cli.command()
@click.option('--username', prompt = True, help = 'admin name')
@click.option('--password', prompt = True, hide_input = True, confirmation_prompt = True, help = 'admin password')
def create_admin(username, password):
    click.echo("create admin...")
    user = User(name = "Admin")
    user.username = username
    user.set_password(password)
    db.session.add(user)
    db.session.commit()
    click.echo("done.")

#添加user到模板上下文，所有模板都可以使用user变量
@app.context_processor
def inject_user():
    user = User.query.first()
    return dict(user=user)

@app.route('/')
def index():
    posts = ["aaaa"]
    return render_template('index.html', posts=posts)

@app.route('/tag')
def tag():
    return render_template('tag.html', current_page='tag')

@app.route('/friend')
def friend():
    return render_template('friend.html', current_page='friend')

@app.route('/about')
def about():
    return render_template('about.html', current_page='about')

@app.route('/note')
def note():
    return render_template('note.html', current_page='note')

@app.errorhandler(404)
def not_found(e):
    return render_template('404.html'), 404
