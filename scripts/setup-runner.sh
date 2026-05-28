#!/bin/bash
# ============================================
# Self-hosted Runner 安装脚本
# 在你的编译机器上运行此脚本
# ============================================

set -e

REPO_URL="https://github.com/huanghao680/avium-build"
RUNNER_NAME="${1:-avium-builder}"
RUNNER_LABELS="${2:-avium,equuleus,linux}"

echo "=========================================="
echo "  AviumUI 编译 Runner 安装脚本"
echo "=========================================="

# 1. 检查系统要求
echo ""
echo "[1/6] 检查系统要求..."

# 检查内存
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
echo "  内存: ${TOTAL_MEM}GB"
if [ "$TOTAL_MEM" -lt 16 ]; then
    echo "  ⚠️  警告: 建议至少 16GB 内存"
fi

# 检查磁盘
FREE_DISK=$(df / --output=avail -BG | tail -1 | tr -d ' G')
echo "  可用磁盘: ${FREE_DISK}GB"
if [ "$FREE_DISK" -lt 200 ]; then
    echo "  ⚠️  警告: 建议至少 200GB 可用空间"
fi

# 检查 CPU
CPU_CORES=$(nproc)
echo "  CPU 核心: ${CPU_CORES}"

# 2. 安装必要依赖
echo ""
echo "[2/6] 安装依赖..."
sudo apt-get update
sudo apt-get install -y \
    curl wget git build-essential libssl-dev libbz2-dev \
    libreadline-dev libsqlite3-dev zlib1g-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libffi-dev liblzma-dev \
    ccache python3 python3-pip tmux

# 3. 配置 ccache
echo ""
echo "[3/6] 配置 ccache..."
ccache -M 50G
echo 'export PATH="/usr/lib/ccache:$PATH"' >> ~/.bashrc
echo "  ccache 已配置为 50GB"

# 4. 创建 runner 目录
echo ""
echo "[4/6] 下载 GitHub Actions Runner..."
RUNNER_DIR=~/actions-runner
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# 获取最新版本
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "  Runner 版本: ${RUNNER_VERSION}"

curl -sL "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" -o runner.tar.gz
tar xzf runner.tar.gz
rm runner.tar.gz

echo "  Runner 下载完成"

# 5. 安装 Runner 服务
echo ""
echo "[5/6] 安装为系统服务..."
sudo ./svc.sh install
sudo ./svc.sh start

echo ""
echo "=========================================="
echo "  ✅ Runner 安装完成！"
echo "=========================================="
echo ""
echo "接下来需要在 GitHub 上配置："
echo ""
echo "1. 打开 https://github.com/huanghao680/avium-build/settings/actions"
echo "2. 点击 'New self-hosted runner'"
echo "3. 复制 token 和运行命令"
echo "4. 在本机运行："
echo "   cd $RUNNER_DIR"
echo "   ./config.sh --url https://github.com/huanghao680/avium-build --token <YOUR_TOKEN>"
echo ""
echo "或者你可以手动运行 Runner（不用服务）："
echo "   cd $RUNNER_DIR"
echo "   ./run.sh"
echo ""
