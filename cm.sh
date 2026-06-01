#!/bin/sh

# 切换到临时目录进行操作
cd /root

# 1. 下载哪吒探针
wget https://ghfast.top/https://github.com/nezhahq/agent/releases/download/v0.20.5/nezha-agent_linux_arm64.zip

# 2. 解压、移动并赋予执行权限
unzip -o nezha-agent_linux_arm64.zip
mv nezha-agent /usr/bin/nezha-agent
chmod +x /usr/bin/nezha-agent

# 3. 写入 OpenWrt 配置文件
cat >/etc/config/nezha-agent <<'EOF'
config nezha 'main'
    option server 'ip.kongzirong.com'
    option port   '5555'
    option key    'iLZMPr5Vmi2O48Ne3y'
    # 可选：额外参数（留空即可，或填 '-d' 等）
    option extra  ''
EOF

# 4. 写入 procd 守护进程服务脚本
cat >/etc/init.d/nezha-agent <<'EOF'
#!/bin/sh /etc/rc.common

START=95
STOP=10
USE_PROCD=1

PROG="/usr/bin/nezha-agent"

start_service() {
    config_load nezha-agent
    config_get server main server
    config_get port   main port
    config_get key    main key
    config_get extra  main extra

    [ -x "$PROG" ] || return 1

    procd_open_instance
    procd_set_param command "$PROG" -s "${server}:${port}" -p "${key}" ${extra}
    # 自动重启（相当于 Restart=always + RestartSec）
    procd_set_param respawn 300 5 0
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}

reload_service() {
    stop
    start
}

service_triggers() {
    procd_add_reload_trigger 'nezha-agent'
}
EOF

# 赋予服务脚本执行权限
chmod +x /etc/init.d/nezha-agent

# 5. 设置开机自启并启动服务
/etc/init.d/nezha-agent enable
/etc/init.d/nezha-agent start

# 6. 清理临时文件并输出运行状态
rm -f nezha-agent_linux_arm64.zip
echo "====================================="
echo "哪吒探针安装并启动完毕！进程信息如下："
pgrep -fa nezha-agent
echo "====================================="
