#!/bin/bash
# 主机：提交 submodule 代码，并将外层仓库所有变更（指针 + 配置等）一并 push
set -e

COMMIT_MSG="${1:-update}"

# ── Step 1: submodule 内部提交 ──
echo "[1/2] Committing submodule (m4-firmware / ros2)..."
cd ~/m4_ws/whiteM4_ROS2/m4-firmware-ros2/m4_home/m4_ws/src/m4-firmware
git add .
if git diff --cached --quiet; then
    echo "  Submodule: nothing to commit, skipping."
else
    git commit -m "$COMMIT_MSG"
    git push origin ros2
fi

# ── Step 2: 外层仓库一次性提交所有变更 ──
# git add . 同时包含：
#   - submodule 指针更新 (m4_home/m4_ws/src/m4-firmware)
#   - 其他修改文件 (config/*.yaml, scripts/*.sh 等)
echo "[2/2] Committing outer repo (all changes)..."
cd ~/m4_ws/whiteM4_ROS2/m4-firmware-ros2
git add .
if git diff --cached --quiet; then
    echo "  Outer repo: nothing to commit, skipping."
else
    git commit -m "$COMMIT_MSG"
    git push origin master
fi

echo ""
echo "Done."
