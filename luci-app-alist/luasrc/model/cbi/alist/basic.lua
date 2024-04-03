local m, s

m = Map("alist", translate("Alist"), translate("A file list program that supports multiple storage.") .. "<br/>" .. [[<a href="https://alist.nn.ci/zh/guide/drivers/local.html" target="_blank">]] .. translate("User Manual") .. [[</a>]])

m:section(SimpleSection).template  = "alist/alist_status"

s = m:section(TypedSection, "alist")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "port", translate("Port"))
o.datatype = "and(port,min(1))"
o.rmempty = false
o.default = "5244"

o = s:option(Flag, "log", translate("Enable Logs"))
o.default = 1
o.rmempty = false

o = s:option(Flag, "ssl", translate("Enable SSL"))
o.rmempty=false

o = s:option(Value,"ssl_cert", translate("SSL cert"), translate("SSL certificate file path"))
o.datatype = "file"
o:depends("ssl", "1")

o = s:option(Value,"ssl_key", translate("SSL key"), translate("SSL key file path"))
o.datatype = "file"
o:depends("ssl", "1")

o = s:option(Flag, "mysql", translate("Enable Database"))
o.rmempty=false

o = s:option(ListValue, "mysql_type", translate("Database Type"))
o.datatype = "string"
o:value("mysql", translate("MySQL"))
o:value("postgres", translate("PostgreSQL"))
o.default = "mysql"
o:depends("mysql", "1")

o = s:option(Value,"mysql_host", translate("Database Host"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_port", translate("Database Port"))
o.datatype = "and(port,min(1))"
o.default = "3306"
o:depends("mysql", "1")

o = s:option(Value,"mysql_username", translate("Database Username"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_password", translate("Database Password"))
o.datatype = "string"
o.password = true
o:depends("mysql", "1")

o = s:option(Value,"mysql_database", translate("Database Name"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_table_prefix", translate("Database Table Prefix"))
o.datatype = "string"
o.default = "x_"
o:depends("mysql", "1")

o = s:option(Value,"mysql_ssl_mode", translate("Database SSL Mode"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Value,"mysql_dsn", translate("Database DSN"))
o.datatype = "string"
o:depends("mysql", "1")

o = s:option(Flag, "allow_wan", translate("Allow Access From Internet"))
o.rmempty = false

o = s:option(Value, "site_url", translate("Site URL"), translate("When the web is reverse proxied to a subdirectory, this option must be filled out to ensure proper functioning of the web. Do not include '/' at the end of the URL"))
o.datatype = "string"

o = s:option(Value, "max_connections", translate("Max Connections"), translate("0 is unlimited, It is recommend to set a low number of concurrency (10-20) for poor performance device"))
o.datatype = "and(uinteger,min(0))"
o.default = "0"
o.rmempty = false

o = s:option(Value, "token_expires_in", translate("Login Validity Period (hours)"))
o.datatype = "and(uinteger,min(1))"
o.default = "48"
o.rmempty = false

o = s:option(Value, "delayed_start", translate("Delayed Start (seconds)"))
o.datatype = "and(uinteger,min(0))"
o.default = "0"
o.rmempty = false

o = s:option(Value, "data_dir", translate("Data directory"))
o.datatype = "string"
o.default = "/etc/alist"

o = s:option(Value, "temp_dir", translate("Cache directory"))
o.datatype = "string"
o.default = "/tmp/alist"
o.rmempty = false

o = s:option(Button, "admin_info", translate("Reset Password"))
o.rawhtml = true
o.template = "alist/admin_info"

return m
