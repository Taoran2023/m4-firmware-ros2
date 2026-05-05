#!/bin/bash
# 主机：同步外层仓库并切换 submodule 到 ros2 分支
set -e

cd ~/m4_ws/whiteM4_ROS2/m4-firmware-ros2

echo "[1/4] Pulling outer repo..."
git pull --rebase origin master

echo "[2/4] Initialising submodules..."
git submodule update --init --recursive

echo "[3/4] Entering submodule m4-firmware..."
cd m4_home/m4_ws/src/m4-firmware
git fetch origin

echo "[4/4] Switching to ros2 branch..."
git switch ros2 2>/dev/null || git switch -c ros2 --track origin/ros2
git pull --rebase origin ros2

echo ""
echo "Done. Submodule is on branch: $(git branch --show-current)"
