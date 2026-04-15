--[[
--vhusbd configuration page. Made by 13333332211
--
]] --
local fs = require "nixio.fs"
local SYS  = require "luci.sys"

m = Map("vhusbd", translate("VirtualHere USB Server V4.7.8 Made by 13333332211（微信同号）"), translatef(
            "『使用』将设备插入服务端的USB接口，多设备场景可用拓展坞增加USB接口，打开客户端远程连接服务端的USB设备。<br />『注册』打开客户端→右击USB共享器→设备信息，将序列号发送作者，获取许可代码并输入至设备信息框。"))

m:section(SimpleSection).template = "vhusbd/status"

s = m:section(TypedSection, "vhusbd", translate("详细设置"))
s.anonymous = true

switch = s:option(Flag, "enabled", translate("启用服务"))
switch.rmempty = false

v4_access = s:option(Flag, "ExtAccess", translate("启用IPv4外网访问"))
v4_access.rmempty = false

v6_access = s:option(Flag, "ExtAccess6", translate("启用IPv6外网访问"))
v6_access.rmempty = false

o = s:option(Button, "", translate("重启服务"))
o.inputstyle = "reset"
o.write = function()
	SYS.call("/etc/init.d/vhusbd stop >/dev/null 2>&1 &")
	SYS.call("/etc/init.d/vhusbd start >/dev/null 2>&1 &")
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
    SYS.call("/etc/init.d/vhusbd start >/dev/null 2>&1 &")
end

return m
