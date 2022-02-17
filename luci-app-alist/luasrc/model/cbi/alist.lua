local m, s

m = Map("alist", translate("Alist"), translate("Alist is an file list program that supports multiple storage. Default password: alist"))

m:section(SimpleSection).template  = "alist_status"

s=m:section(TypedSection, "alist", translate("Global settings"))
s.addremove=false
s.anonymous=true

s:option(Flag, "enabled", translate("Enable")).rmempty=false
s:option(Value, "port", translate("Port")).rmempty=false

s=m:section(TypedSection, "alist", translate("Cache settings"))
s.addremove=false
s.anonymous=true

s:option(Value, "expiration", translate("Cache invalidation time (unit: minutes)")).rmempty=false
s:option(Value, "cleanup_interval", translate("Clear the invalidation cache interval")).rmempty=false
s:option(Value, "temp_dir", translate("Temp directory")).rmempty=false

return m
