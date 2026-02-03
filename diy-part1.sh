#!/bin/bash
# diy-part1.sh - 配置 feeds 源（适配第三方源的 main 分支）

# 备份默认 feeds
cp feeds.conf.default feeds.conf.default.bak

# 配置基础 feeds（官方源仍用 openwrt-23.05 分支）
echo "src-git core https://github.com/openwrt/openwrt.git;v23.05.3" > feeds.conf.default
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-23.05" >> feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-23.05" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-23.05" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-23.05" >> feeds.conf.default

# 第三方源改用 main 分支（修复不存在的 openwrt-23.05 分支问题）
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages.git;main" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small.git;main" >> feeds.conf.default

# 安装必要的系统依赖
sudo apt update
sudo apt install -y golang rustc cargo nodejs npm ruby ruby-dev libjson-c-dev
