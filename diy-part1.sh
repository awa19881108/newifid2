#!/bin/bash
# diy-part1.sh - 配置 feeds 源（适配 v23.05.3）
# 注意：执行此脚本时已在 openwrt 目录下，无需再 cd

# 备份默认 feeds
cp feeds.conf.default feeds.conf.default.bak

# 配置基础 feeds（适配 v23.05 分支）
echo "src-git core https://github.com/openwrt/openwrt.git;v23.05.3" > feeds.conf.default
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-23.05" >> feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-23.05" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-23.05" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-23.05" >> feeds.conf.default

# 添加第三方 feeds（包含 SSR Plus+ 和 PassWall2，兼容 v23.05）
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages.git" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small.git" >> feeds.conf.default
echo "src-git small8 https://github.com/kenzok8/small-package.git" >> feeds.conf.default

# 安装必要的系统依赖
sudo apt update
sudo apt install -y golang rustc cargo nodejs npm ruby ruby-dev
