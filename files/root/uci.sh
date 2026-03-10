#!/bin/sh
# ===================================================================
# 小白专用一键部署 USB 网络模式切换 UI
# 说明文字作为副标题，第 2 行两个按钮上下排列
# USB Host 模式说明已改为：设备插入扩展坞作为主机，可连接 U 盘、USB 网卡、手机 USB 网络共享
# ===================================================================

echo "=========================================="
echo " 小白一键部署 USB 网络模式切换 UI"
echo " 说明文字作为副标题，按钮布局优化"
echo " USB Host 模式说明已更新"
echo "=========================================="

# 检查 root 权限
if [ "$(id -u)" != "0" ]; then
    echo "[!] 请用 root 用户或在命令前加 sudo 运行本脚本"
    exit 1
fi

# 1. 确保 ncm.sh 和 usb.sh 可执行
for SCRIPT in ncm.sh usb.sh; do
    if [ -f "/root/$SCRIPT" ]; then
        chmod +x /root/$SCRIPT
        echo "[√] 已设置 /root/$SCRIPT 为可执行"
    else
        echo "[!] 警告：未找到 /root/$SCRIPT，请确保该文件存在，否则相关按钮无效"
    fi
done

# 2. 创建 Controller
mkdir -p /usr/lib/lua/luci/controller
cat > /usr/lib/lua/luci/controller/ncm_root.lua <<'CONTROLLER_EOF'
module("luci.controller.ncm_root", package.seeall)

function index()
    entry({"admin", "services", "ncm_root"}, cbi("ncm_root/ncm_root"), "USB 网络模式切换", 61).dependent = true
end
CONTROLLER_EOF
echo "[√] 已写入 Controller（Services -> USB 网络模式切换）"

# 3. 创建 Model 目录
mkdir -p /usr/lib/lua/luci/model/cbi/ncm_root

# 4. 写入 Model（说明作为副标题 Section，按钮布局按要求，Host 模式说明已更新）
cat > /usr/lib/lua/luci/model/cbi/ncm_root/ncm_root.lua <<'MODEL_EOF'
require "luci.sys"

m = Map("ncm_root", "USB 网络模式切换")

-- 第 1 行按钮：NCM、ECM、RNDIS（横向）
s1 = m:section(TypedSection, "settings", "")
s1.anonymous = true
s1.addremove = false
s1.template = "cbi/tblsection"

btn_ncm = s1:option(Button, "btn_ncm", "NCM 模式")
btn_ncm.inputtitle = "点击立即执行生效"
btn_ncm.write = function(self, section)
    luci.sys.call("cd /root && ./ncm.sh ncm >/dev/null 2>&1")
end

btn_ecm = s1:option(Button, "btn_ecm", "ECM 模式")
btn_ecm.inputtitle = "点击立即执行生效"
btn_ecm.write = function(self, section)
    luci.sys.call("cd /root && ./ncm.sh ecm >/dev/null 2>&1")
end

btn_rndis = s1:option(Button, "btn_rndis", "RNDIS 模式")
btn_rndis.inputtitle = "点击立即执行生效"
btn_rndis.write = function(self, section)
    luci.sys.call("cd /root && ./ncm.sh rndis >/dev/null 2>&1")
end

-- 副标题 Section（紧跟在主标题下面）
s_desc = m:section(SimpleSection)
s_desc.title = ""
s_desc.description = [[
<b>功能说明：</b><br>
• <b>NCM / ECM / RNDIS 模式</b>：用于设备作为 USB 网卡共享网络给电脑或其他主机。<br>
• <b>USB Gadget 模式</b>：设备模拟 USB 外设（如网卡、串口），供外部主机连接使用。<br>
• <b>USB Host 模式</b>：设备插入扩展坞作为主机，可连接 U 盘、USB 网卡、手机 USB 网络共享等 USB 外设。<br><br>
请在对应模式下点击按钮立即切换，切换后可能需要重新插拔 USB 线才能生效。
]]

-- 第 2 行按钮改为上下排列
s_gadget = m:section(TypedSection, "settings", "")
s_gadget.anonymous = true
s_gadget.addremove = false
s_gadget.template = "cbi/tblsection"

btn_gadget = s_gadget:option(Button, "btn_gadget", "USB Gadget 模式")
btn_gadget.inputtitle = "点击立即执行生效"
btn_gadget.write = function(self, section)
    luci.sys.call("cd /root && ./usb.sh >/dev/null 2>&1")
end

s_host = m:section(TypedSection, "settings", "")
s_host.anonymous = true
s_host.addremove = false
s_host.template = "cbi/tblsection"

btn_host = s_host:option(Button, "btn_host", "USB Host 模式")
btn_host.inputtitle = "点击立即执行生效"
btn_host.write = function(self, section)
    luci.sys.call("cd /root && ./usb.sh 1 >/dev/null 2>&1")
end

return m
MODEL_EOF
echo "[√] 已写入 Model（含副标题说明 + 第 2 行按钮上下排列，Host 模式说明已更新）"

# 5. 创建配置文件
mkdir -p /etc/config
cat > /etc/config/ncm_root <<'CONFIG_EOF'
config settings 'settings'
CONFIG_EOF
echo "[√] 已写入配置文件 /etc/config/ncm_root"

# 6. 重启 uhttpd
/etc/init.d/uhttpd restart
echo "[√] 已重启 uhttpd，页面立即生效"

# 7. 提示访问地址
echo ""
echo "=========================================="
echo " 部署完成！"
echo " 访问地址："
echo "   http://$(uci get network.lan.ipaddr)/cgi-bin/luci/admin/services/ncm_root"
echo " 页面布局："
echo "   主标题：USB 网络模式切换"
echo "   副标题：功能说明（带项目符号列表）"
echo "   第 1 行（横向）：NCM 模式 | ECM 模式 | RNDIS 模式"
echo "   第 2 行起（上下排列）："
echo "     - USB Gadget 模式"
echo "     - USB Host 模式"
echo " 所有按钮提示文字上下对齐，不会错位"
echo "=========================================="
