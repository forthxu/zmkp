local skynet = require "skynet"
local jsonpack = require "jsonpack"
local netpack = require "netpack"
local socket = require "socket"

local CMD = {}

local client_fd

local function xfs_send(v)
	socket.write(client_fd, netpack.pack(v))
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return skynet.tostring(msg,sz)
	end,
	dispatch = function (session, address, text)
		print("ok",text)
		xfs_send("data:"..text."\n")
	end
}

skynet.register_protocol {
	name = "xfs",
	id = 12,
	pack = skynet.pack,
	unpack = skynet.unpack,
	dispatch = function (session, address, text)
		print("[LOG]", skynet.address(address),text)
		xfs_send("Welcome to skynet\n")
		skynet.retpack(text)
	end
}

function CMD.start(gate , fd)
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
