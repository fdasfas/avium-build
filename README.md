# AviumUI equuleus 自动编译

> 🤖 使用 GitHub Actions 自动编译 AviumUI (Android 16) for 一加13
## 📱 适用设备

| 项目 | 信息 |
|------|------|
| 设备 | 一加13 (dodge) |
| SoC | Qualcomm Snapdragon 8 Elite |
| Android | 16 (QPR2) |
| ROM | AviumUI |

## 🚀 使用方法

### 方法一：Self-hosted Runner（推荐）

在你自己的编译机器上运行 Runner，空间和性能都有保障：

```bash
# 1. 克隆仓库
git clone https://github.com/huanghao680/avium-build.git
cd avium-build

# 2. 运行安装脚本
chmod +x setup-runner.sh
./setup-runner.sh

# 3. 在 GitHub 仓库设置中添加 Runner
# Settings → Actions → New self-hosted runner
```

### 方法二：Fork 后手动触发

1. Fork 本仓库
2. 在 Actions 页面点击 "Build AviumUI"
3. 点击 "Run workflow" 开始编译
4. 等待编译完成，下载产物

## ⚙️ 编译配置

- **编译目标**: `dodge userdebug`
- **源码分支**: AviumUI avium-16.2
- **设备树**: LineageOS lineage-23.2
- **内核**: LineageOS lineage-22.2 (SDM845)
- **自动编译**: 每周日凌晨 2:00
- **手动触发**: 支持完全清理重编

## 📦 编译产物

编译完成后，在 Actions 的 Artifacts 中可以下载：
- `AviumUI-equuleus-YYYYMMDD.zip` — 刷机包
- `recovery.img` — Recovery 镜像
- `boot.img` — 内核镜像
- `build-info.txt` — 构建信息

## 📋 刷入步骤

1. 解锁 Bootloader（小米官网申请）
2. 刷入 TWRP Recovery
3. 在 TWRP 中格式化 Data 分区
4. 刷入编译好的 ROM 包
5. 可选：刷入 Magisk 获取 Root

## 🔧 环境要求（Self-hosted Runner）

| 项目 | 最低要求 | 推荐配置 |
|------|---------|---------|
| 系统 | Ubuntu 22.04 LTS | Ubuntu 22.04 LTS |
| 内存 | 16 GB | 32 GB+ |
| 磁盘 | 200 GB SSD | 400 GB+ SSD |
| CPU | 4 核 | 8 核+ |
| 网络 | 稳定连接 | 高速网络（源码同步） |

## ⚠️ 注意事项

- 首次源码同步需要 **几小时**，请确保网络稳定
- 编译过程需要 **4-8 小时**（取决于 CPU 性能）
- 确保 `/tmp` 有足够空间（编译过程中需要）
- GitHub Actions 标准 Runner **空间不足**，必须使用 Self-hosted Runner

## 📝 常见问题

### Q: 编译失败怎么办？
查看 Actions 日志，常见原因：
- 磁盘空间不足
- 内存不够（添加 swap）
- 网络问题导致源码不完整

### Q: 如何清理编译缓存？
在 Actions 页面选择 "clean_build" 选项重新运行

### Q: 如何添加 GApps？
取消注释工作流中的 `avium get_gms` 步骤

## 🙏 致谢

- [AviumUI](https://github.com/AviumUI) — ROM 开发团队
- [LineageOS](https://lineageos.org) — 设备树和内核源码
- [TheMuppets](https://github.com/TheMuppets) — dodge vendor 维护
---

*本项目仅供学习交流使用，刷机有风险，操作需谨慎。*
