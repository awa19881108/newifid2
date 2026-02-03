#!/bin/bash
# diy-part2.sh - 配置编译参数和软件包

cd openwrt || exit

# 1. 基础配置（适配 newifid2，mt7621 架构）
cat > .config <<EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_newifi-d2=y

# 系统基础配置
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_LUCI_LANG_zh_Hans_CN=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-opkg=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-mod-admin-full=y

# 网络基础组件
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_firewall=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_iptables=y
CONFIG_PACKAGE_wireless-tools=y

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

# 依赖组件
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

# 2. 调整编译参数（优化性能）
sed -i 's/^CONFIG_CPU_TYPE.*/CONFIG_CPU_TYPE="octeon"/' .config
sed -i 's/^CONFIG_TARGET_OPTIMIZATION.*/CONFIG_TARGET_OPTIMIZATION="-O2 -mtune=mt7621"/' .config

# 3. 清理无效配置
make defconfig
