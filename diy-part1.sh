#!/bin/bash
# diy-part1.sh - 配置 feeds 源

# 进入 openwrt 目录
cd openwrt || exit

# 备份默认 feeds
cp feeds.conf.default feeds.conf.default.bak

# 配置基础 feeds
echo "src-git core $REPO_URL;$REPO_BRANCH" > feeds.conf.default
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-24.10" >> feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-24.10" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-24.10" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-24.10" >> feeds.conf.default

# 添加第三方 feeds（包含 SSR Plus+ 和 PassWall2）
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages.git" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small.git" >> feeds.conf.default
echo "src-git small8 https://github.com/kenzok8/small-package.git" >> feeds.conf.default

# 安装必要的系统依赖
sudo apt update
sudo apt install -y golang rustc cargo nodejs npm ruby ruby-dev
