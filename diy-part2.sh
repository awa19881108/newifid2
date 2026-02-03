#!/bin/bash
# diy-part2.sh - 配置编译参数（禁用错误包，精简配置）

# 1. 基础配置（适配 newifi-d2，禁用 webd 包）
cat > .config <<EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_newifi-d2=y

# 内核配置（禁用交互，适配 mt7621）
CONFIG_DEVEL=y
CONFIG_CCACHE=y
CONFIG_KERNEL_BUILD_USER="builder"
CONFIG_KERNEL_BUILD_DOMAIN="github.com"
CONFIG_KERNEL_MTD_SPLIT_OPENWRT_PROLOG=n
CONFIG_KERNEL_PRINTK=y
CONFIG_KERNEL_PRINTK_TIME=y
CONFIG_KERNEL_SWAP=y
CONFIG_KERNEL_SYSFS=y

# 系统核心配置（仅保留必需组件）
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_LUCI_LANG_zh_Hans_CN=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-mod-admin-full=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_opkg=y
CONFIG_PACKAGE_luci-app-opkg=y

# 显式禁用错误包（双重保险）
CONFIG_PACKAGE_webd=n
CONFIG_PACKAGE_webdav2=n

# 网络基础组件
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_firewall=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_iptables=y
CONFIG_PACKAGE_wireless-tools=y
CONFIG_PACKAGE_wpad-basic-wolfssl=y

# SSR Plus+ 和 PassWall2 核心组件（仅保留基础功能）
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Base=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Base=y

# 核心依赖（仅保留必需项）
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_unzip=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_libev=y
CONFIG_PACKAGE_libsodium=y
CONFIG_PACKAGE_golang=y
EOF

# 2. 适配 mt7621 编译参数
sed -i '/CONFIG_CPU_TYPE/d' .config
echo 'CONFIG_TARGET_OPTIMIZATION="-O2 -march=mt7621 -mtune=mt7621"' >> .config

# 3. 预处理配置（清理错误包缓存）
make defconfig
make package/luci-app-opkg/clean
make package/opkg/clean
# 清理 webd 包缓存（若存在）
make package/feeds/small8/webd/clean 2>/dev/null || true
