local m, s

m = Map("alist", translate("Alist"), translate("Alist is an file list program that supports multiple storage. Default password: alist"))

m:section(SimpleSection).template  = "alist_status"

s = m:section(TypedSection, "alist", translate("Global settings"))
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable"))
o.rmempty = false

o = s:option(Value, "port", translate("Port"))
o.datatype = "and(port,min(1))"
o.rmempty = false

o = s:option(Flag, "ssl", translate("Enable SSL"))
o.rmempty=false

o = s:option(Value,"ssl_cert", translate("SSL cert"), translate("SSL certificate file path"))
o:depends("ssl", "1")
o.datatype = "string"
o.rmempty = true

o = s:option(Value,"ssl_key", translate("SSL key"), translate("SSL key file path"))
o:depends("ssl", "1")
o.datatype = "string"
o.rmempty = true

s = m:section(TypedSection, "alist", translate("Cache settings"))
s.addremove = false
s.anonymous = true

o = s:option(Value, "expiration", translate("Cache invalidation time (unit: minutes)"))
o.datatype = "and(uinteger,min(1))"
o.rmempty = false

o = s:option(Value, "cleanup_interval", translate("Clear the invalidation cache interval (unit: minutes)"))
o.datatype = "and(uinteger,min(1))"
o.rmempty = false

o = s:option(Value, "temp_dir", translate("Temp directory"))
o.datatype = "string"
o.rmempty = false

return m
