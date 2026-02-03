#!/bin/bash
# diy-part1.sh - 配置 feeds 源（移除有错误的 small8 源）

# 备份默认 feeds
cp feeds.conf.default feeds.conf.default.bak

# 配置基础 feeds（严格匹配 v23.05 分支）
echo "src-git core https://github.com/openwrt/openwrt.git;v23.05.3" > feeds.conf.default
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-23.05" >> feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-23.05" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-23.05" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-23.05" >> feeds.conf.default

# 仅保留兼容的第三方 feeds（移除 small8，避免 webd 包错误）
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages.git;openwrt-23.05" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small.git;openwrt-23.05" >> feeds.conf.default

# 安装必要的系统依赖（仅保留有效项）
sudo apt update
sudo apt install -y golang rustc cargo nodejs npm ruby ruby-dev libjson-c-dev
