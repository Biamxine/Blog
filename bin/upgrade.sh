#!/bin/bash

# 定义 screen 会话名称 和 工作目录
SCREEN_NAME="blog"
WORK_DIR="/srv/blog/"
FLASK_CMD="flask run --host=0.0.0.0 --port=5000"
KEY_DIR="~/.ssh/user-git_password-is-git"


# 第一步：查找并优雅停止当前运行的 flask 进程（模拟 Ctrl+C，发送 SIGINT）
echo "正在查找并停止当前运行的 Flask 进程..."
pkill -f "flask run --host=0.0.0.0 --port=5000" || echo "未找到正在运行的 Flask 进程，可能尚未启动或命令不匹配。"

# 第二步：拉取最新代码
echo "正在拉取最新代码..."
cd "$WORK_DIR" || { echo "无法进入目录 $WORK_DIR"; exit 1; }
git pull --key-dir "$KEY_DIR"


# 检查 git pull 是否成功
if [ $? -ne 0 ]; then
    echo "git pull 失败，请检查代码仓库状态。"
    exit 1
fi
echo "代码拉取成功。"

# 第三步：确保 screen 会话存在，如果不存在则创建一个空的后台会话
# 如果 screen 会话不存在，则创建一个空的持久化会话
if ! screen -list | grep -q "\b$SCREEN_NAME\b"; then
    echo "Screen 会话 \"$SCREEN_NAME\" 不存在，正在创建空的后台会话..."
    screen -dmS "$SCREEN_NAME" bash
fi

# 第四步：在 screen 会话中运行新的 flask 命令
echo "正在重新启动 Flask 应用在 screen 会话 \"$SCREEN_NAME\" 中..."
screen -S "$SCREEN_NAME" -X stuff "$FLASK_CMD$(printf \\r)"

# 检查是否执行成功
if [ $? -eq 0 ]; then
    echo "Flask 应用已在 screen 会话 \"$SCREEN_NAME\" 中重新启动："
    echo "    host: 0.0.0.0"
    echo "    port: 5000"
    echo "你可以使用以下命令查看 screen 会话状态："
    echo "    screen -ls"
    echo "或者连接进会话查看输出："
    echo "    screen -r $SCREEN_NAME"
else
    echo "启动 Flask 应用到 screen 会话失败。"
    exit 1
fi