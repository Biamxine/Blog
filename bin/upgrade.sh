#!/bin/bash

# 定义 screen 会话名称 和 工作目录
SCREEN_NAME="Blog"
WORK_DIR="/srv/blog"
FLASK_CMD="flask run --host=0.0.0.0 --port=5000"
ACTIVATE_CMD="source $WORK_DIR/env/bin/activate"
KEY_DIR="~/.ssh/user-git_password-is-git"
CORRECT_VIRTUAL_ENV="$WORK_DIR/env"
ASH_BIN="$WORK_DIR/log/ash-bin"


# 第一步：查找并优雅停止当前运行的 flask 进程
echo "正在查找并停止当前运行的 Flask 进程..."
pkill -f "flask run --host=0.0.0.0 --port=5000" || echo "未找到正在运行的 Flask 进程，可能尚未启动或命令不匹配。"

# 第二步：拉取最新代码
echo "正在拉取最新代码..."
cd "$WORK_DIR" || { echo "无法进入目录 $WORK_DIR"; exit 1; }
git pull > "$ASH_BIN" 2>&1


# 检查 git pull 是否成功
if [ $? -ne 0 ]; then
    echo "git pull 失败，请检查代码仓库状态。"
    exit 1
fi
echo "代码拉取成功。"

# 第三步：确保 screen 会话存在，如果不存在则创建一个空的后台会话
echo "正在检查 screen 会话..."
# 如果 screen 会话不存在，则创建一个空的持久化会话
if ! screen -ls | grep -qw "$SCREEN_NAME"; then
    echo "Screen 会话 \"$SCREEN_NAME\" 不存在，正在创建空的后台会话..."
    screen -dmS "$SCREEN_NAME" bash
    echo "已经执行创建 screen 后台会话命令，再次检查 screen 会话 \"$SCREEN_NAME\" 是否存在..."
    if ! screen -ls | grep -qw "$SCREEN_NAME"; then
        echo "创建 Screen 会话 \"$SCREEN_NAME\" 失败。"
        exit 1
    else
        echo "Screen 会话 \"$SCREEN_NAME\" 创建成功。"
    fi
else
    echo "Screen 会话 \"$SCREEN_NAME\" 存在"
fi
#screen会话blog切换到工作目录
echo "正在切换到工作目录..."
screen -S "$SCREEN_NAME" -X stuff "cd $WORK_DIR $(printf \\r)"

#第四步：确保虚拟环境激活
echo "正在检查虚拟环境激活状态..."
screen -S "$SCREEN_NAME" -X stuff 'echo \$VIRTUAL_ENV > /srv/blog/log/activate.status'
screen -S "$SCREEN_NAME" -X stuff "$(printf \\r)"
if [ "$(</srv/blog/log/activate.status)" = "$CORRECT_VIRTUAL_ENV" ]; then
    echo "虚拟环境已激活"
else
    echo "虚拟环境未激活，正在激活..."
    screen -S "$SCREEN_NAME" -X stuff "$ACTIVATE_CMD$(printf \\r)"
    # 等待环境激活
    sleep 1
    # 检查环境是否激活
    screen -S "$SCREEN_NAME" -X stuff 'echo \$VIRTUAL_ENV > /srv/blog/log/activate.status'
    screen -S "$SCREEN_NAME" -X stuff "$(printf \\r)"
    if [ "$(</srv/blog/log/activate.status)" = "$CORRECT_VIRTUAL_ENV" ]; then
        echo "虚拟环境已激活"
    else
        echo "虚拟环境激活失败"
        exit 1
    fi
fi

# 第五步：在 screen 会话中运行新的 flask 命令
echo "正在 screen 会话 \"$SCREEN_NAME\" 中重新启动 Flask 应用..."

screen -S "$SCREEN_NAME" -X stuff "$FLASK_CMD$(printf \\r)"

# 检查是否执行成功
if ps aux |grep "[f]lask run --host=0.0.0.0 --port=5000" > "$ASH_BIN"; then
    echo "Flask 应用已在 screen 会话 \"$SCREEN_NAME\" 中成功启动！"
    echo "Flask 应用已在 screen 会话 \"$SCREEN_NAME\" 中成功启动！"
    echo "Flask 应用已在 screen 会话 \"$SCREEN_NAME\" 中成功启动！"
else
    echo "启动 Flask 应用到 screen 会话失败。"
    exit 1
fi