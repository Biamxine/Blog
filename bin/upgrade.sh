#!/bin/bash

# 定义screen会话名称和目录
SCREEN_NAME="blog"
WORK_DIR="/srv/blog/"
FLASK_CMD="flask run --host=0.0.0.0 --port=5000"

# 第一步：尝试停止名为 blog 的 screen 会话
echo "正在尝试停止 screen 会话 \"$SCREEN_NAME\"..."
screen -S "$SCREEN_NAME" -X quit

# 检查上条命令是否成功，但不强制要求必须存在该会话
if [ $? -eq 0 ]; then
    echo "Screen 会话 \"$SCREEN_NAME\" 已停止。"
else
    echo "未找到正在运行的 screen 会话 \"$SCREEN_NAME\" 或停止失败，继续执行后续操作..."
fi

# 第二步：进入工作目录并拉取最新代码
echo "正在拉取最新代码..."
cd "$WORK_DIR" || { echo "无法进入目录 $WORK_DIR"; exit 1; }
git pull

# 检查git pull是否成功
if [ $? -ne 0 ]; then
    echo "git pull 失败，请检查代码仓库状态。"
    exit 1
fi

echo "代码拉取成功。"

# 第三步：重新启动 screen 会话并运行 flask
echo "正在启动 screen 会话 \"$SCREEN_NAME\" 并运行 Flask 应用..."
screen -dmS "$SCREEN_NAME" bash -c "cd \"$WORK_DIR\" && $FLASK_CMD"

# 检查是否启动成功
if [ $? -eq 0 ]; then
    echo "Screen 会话 \"$SCREEN_NAME\" 已启动，Flask 应用正在运行："
    echo "    host: 0.0.0.0"
    echo "    port: 5000"
    echo "你可以使用命令 \"screen -r $SCREEN_NAME\" 查看运行状态。"
else
    echo "启动 screen 会话失败。"
    exit 1
fi