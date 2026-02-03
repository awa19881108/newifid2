#!/bin/bash
# diy-part2.sh - 配置编译参数和软件包（修复内核编译错误）

# 1. 基础配置（适配 newifi-d2，mt7621 架构，修复内核配置）
cat > .config <<EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_newifi-d2=y

# 禁用内核配置交互提问（关键修复）
CONFIG_DEVEL=y
CONFIG_CCACHE=y
CONFIG_KERNEL_BUILD_USER="builder"
CONFIG_KERNEL_BUILD_DOMAIN="github.com"
CONFIG_KERNEL_MTD_SPLIT_OPENWRT_PROLOG=n  # 关闭交互式提问的选项
CONFIG_KERNEL_PRINTK=y
CONFIG_KERNEL_PRINTK_TIME=y
CONFIG_KERNEL_SWAP=y
CONFIG_KERNEL_SYSFS=y

# 系统基础配置
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_LUCI_LANG_zh_Hans_CN=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-opkg=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-mod-admin-full=y
CONFIG_PACKAGE_csstidy=n  # 禁用csstidy避免哈希错误

# 网络基础组件
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_firewall=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_iptables=y
CONFIG_PACKAGE_wireless-tools=y
CONFIG_PACKAGE_wpad-basic-wolfssl=y  # 修复无线驱动依赖

# SSR Plus+ 完整组件
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_SingBox=y

# PassWall2 完整组件
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y

# 依赖组件（精简且兼容mt7621）
CONFIG_PACKAGE_golang=y
CONFIG_PACKAGE_rust=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_unzip=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_libev=y
CONFIG_PACKAGE_libsodium=y
CONFIG_PACKAGE_libudns=y
CONFIG_PACKAGE_boost=y
EOF

# 2. 移除不兼容的编译参数（关键修复：原octeon不兼容mt7621）
sed -i '/CONFIG_CPU_TYPE/d' .config
sed -i '/CONFIG_TARGET_OPTIMIZATION/d' .config
# 添加mt7621兼容的优化参数
echo 'CONFIG_TARGET_OPTIMIZATION="-O2 -march=mt7621 -mtune=mt7621"' >> .config

# 3. 清理无效配置并生成内核配置（避免syncconfig错误）
make defconfig
make kernel_oldconfig  # 自动回答内核配置问题，无交互
