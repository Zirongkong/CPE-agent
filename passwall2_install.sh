://github.com/Openwrt-Passwall/openwrt-passwall2

# 0. 更新源
opkg update

# 1. 卸载老版本 luci-app-passwall，防止文件冲突
opkg remove --force-depends luci-app-passwall

# 2. 下载最新版 Passwall2 主程序和语言包（根据 GitHub 最新版本替换 URL）
cd /tmp

wget https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.6.3-1/luci-app-passwall2_26.6.3-r1_all.ipk
wget https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.6.3-1/luci-i18n-passwall2-zh-cn_26.6.3_all.ipk

# 3. 下载并解压 aarch64 依赖包合集（包括 xray-core、geoip、sing-box 等）
wget https://github.com/Openwrt-Passwall/openwrt-passwall2/releases/download/26.6.3-1/passwall_packages_ipk_aarch64_generic.zip
unzip passwall_packages_ipk_aarch64_generic.zip -d /tmp/passwall2_pkgs

# 4. 安装所有依赖核心
opkg install /tmp/passwall2_pkgs/*.ipk

# 5. 安装主界面 & 中文语言包
opkg install /tmp/luci-app-passwall2_26.6.3-r1_all.ipk
opkg install /tmp/luci-i18n-passwall2-zh-cn_26.6.3_all.ipk

# 6. 启用并启动服务
/etc/init.d/passwall2 enable
/etc/init.d/passwall2 start

