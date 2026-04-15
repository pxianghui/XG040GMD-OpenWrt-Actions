module("luci.controller.vhusbd", package.seeall)

function index()
    entry({"admin", "services", "vhusbd"}, template("vhusbd/vhusbd"), _("VirtualHere"), 46)
    entry({"admin", "services", "vhusbd", "status"}, call("vhusbd_status"))
    entry({"admin", "services", "vhusbd", "control"}, call("service_control"))
end

function vhusbd_status()
    local status = {}
    status.running = luci.sys.call("killall -0 vhusbd 2>/dev/null") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(status)
end

function service_control()
    local action = luci.http.formvalue("action")
    
    if action == "start" then
        luci.sys.call("/etc/init.d/vhusbd start >/dev/null 2>&1")
    elseif action == "stop" then
        luci.sys.call("/etc/init.d/vhusbd stop >/dev/null 2>&1")
    end
    
    luci.http.redirect(luci.dispatcher.build_url("admin/services/vhusbd"))
end
