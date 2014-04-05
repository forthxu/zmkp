package.cpath = "./skynet/luaclib/?.so"

local netpack = require "netpack"
local socketdriver = require "socketdriver"

local fd = socketdriver.connect("127.0.0.1", 10101)

local last
local result = {}

local function dispatch()
	while true do
		local status
		status, last = socketdriver.readline(fd, result)
		if status == nil then
			error "Server closed"
		end
		if not status then
			break
		end
		for _, v in ipairs(result) do
			local session,t,str = string.match(v, "(%d+)(.)(.*)")
			assert(t == '-' or t == '+')
			session = tonumber(session)
			print("Response:",session, str)
		end
	end
end

local session = 0

local function send_request(v)
	session = session + 1
	local str = string.format("%d+%s",session, v)
	print(str)
	socket.send(fd, str)
	print("Request:", session)
end

while true do
	dispatch()
	local cmd = socket.readline()
	if cmd then
		send_request(cmd)
	else
		socket.usleep(100)
	end
end
