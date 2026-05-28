#!/bin/bash
# Avium 编译清理脚本
set -e

BUILD_DIR="${BUILD_DIR:-$HOME/avium}"

echo "========================================="
echo " Avium 编译清理"
echo "========================================="

# 清理编译产物
if [ -d "$BUILD_DIR" ]; then
    echo "清理编译目录: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

# 清理 apt 缓存
echo "清理 apt 缓存..."
sudo apt-get clean 2>/dev/null || true
sudo apt-get autoremove -y 2>/dev/null || true

# 清理 pip 缓存
echo "清理 pip 缓存..."
pip3 cache purge 2>/dev/null || true

# 清理 git 缓存
echo "清理 git 缓存..."
git gc --prune=now 2>/dev/null || true

# 显示清理后磁盘使用
echo ""
echo "磁盘使用情况:"
df -h / | tail -1

echo ""
echo "✅ 清理完成!"
