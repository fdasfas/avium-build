#!/bin/bash
# Avium 固件编译脚本
set -e

BUILD_DIR="${BUILD_DIR:-$HOME/avium}"
REPO_URL="https://github.com/AvaotaSBC/avium.git"

echo "========================================="
echo " Avium 固件编译"
echo "========================================="
echo "编译目录: $BUILD_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# 克隆或更新仓库
if [ -d "avium" ]; then
    echo "更新 avium 仓库..."
    cd avium
    git pull --depth=1 origin main 2>&1 || echo "使用现有仓库"
else
    echo "克隆 avium 仓库..."
    git clone --depth=1 "$REPO_URL" avium
    cd avium
fi

echo "仓库大小: $(du -sh . | cut -f1)"
echo ""

# 查找编译脚本
echo "查找编译脚本..."
find . -maxdepth 3 -name "*.sh" -type f 2>/dev/null | head -20 || true

if [ -f "build.sh" ]; then
    echo "找到 build.sh，开始编译..."
    chmod +x build.sh
    ./build.sh
elif [ -f "Makefile" ]; then
    echo "找到 Makefile，执行 make..."
    make -j$(nproc)
elif [ -f "CMakeLists.txt" ]; then
    echo "找到 CMakeLists.txt，使用 CMake..."
    mkdir -p build && cd build
    cmake .. -G Ninja
    ninja
else
    echo "⚠️ 未找到标准编译脚本"
    echo "仓库结构:"
    ls -la
    echo ""
    echo "可能需要自定义编译命令"
    exit 1
fi

echo ""
echo "✅ 编译完成!"
echo "产物位置: $BUILD_DIR/avium"
