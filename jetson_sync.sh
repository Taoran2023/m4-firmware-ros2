#!/bin/bash
# Jetson：同步最新代码（在 Jetson 上运行）
set -e

cd ~/whiteM4_ros2/m4-firmware-ros2

echo "[1/2] Pulling outer repo..."
git pull --rebase origin master

echo "[2/2] Updating submodules..."
git submodule update --init --recursive

echo ""
echo "Done. Submodule HEAD: $(cd m4_home/m4_ws/src/m4-firmware && git log --oneline -1)"
