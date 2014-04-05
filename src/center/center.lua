local skynet = require "skynet"
local db = {}

local command = {}

function command.GET(key)
	return db[key]
end

function command.SET(key, value)
	local last = db[key]
	db[key] = value
	return last
end

function command.P(key, value)
	local protobuf = require "protobuf"

	addr = io.open("../res/addressbook.pb","rb")
	buffer = addr:read "*a"
	addr:close()
	protobuf.register(buffer)

	local person = {
		name = "Alice",
		id = 123,
		phone = {
			{ number = "123456789" , type = "MOBILE" },
			{ number = "87654321" , type = "HOME" },
		}
	}

	local buffer = protobuf.encode("tutorial.Person", person)

	local t = protobuf.decode("tutorial.Person", buffer)

	for k,v in pairs(t) do
		if type(k) == "string" then
			print(k,v)
		end
	end

	print(t.phone[2].type)

	for k,v in pairs(t.phone[1]) do
		print(k,v)
	end
	
	return "ok"
end

skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = command[string.upper(cmd)]
		skynet.ret(skynet.pack(f(...)))
	end)
	skynet.register "CENTER"
end)
