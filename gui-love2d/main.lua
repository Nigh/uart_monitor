

local rs232 = require("luars232")
local e, p = rs232.open("COM5")
local err = ""
if e ~= 0 then                      --如果打开失败则打印错误信息并退出
	err = rs232.error_tostring(e)
end
local font26,font12,font120
function love.load()
	if p then
		p:set_baud_rate(rs232.RS232_BAUD_115200)
		p:set_data_bits(rs232.RS232_DATA_8)
		p:set_parity(rs232.RS232_PARITY_NONE)
		p:set_stop_bits(rs232.RS232_STOP_1)
		p:set_flow_control(rs232.RS232_FLOW_OFF)
	end
	font26 = love.graphics.newFont( 26 )
	font12 = love.graphics.newFont( 12 )
	font120 = love.graphics.newFont( 120 )
end

function round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

local tab={}
function printTab( tab )
	local x,y=10,180
	local dy=26
	for k,v in ipairs(tab) do
		love.graphics.print(v, x, y+k*dy, 0)
	end
end


local start,ends
local dr=""
local buffer=""
local cacheSize=0
local t=0
function love.draw( dt )
	love.graphics.setColor( 255, 255, 255, 150 )
	love.graphics.setFont(font26)
	love.graphics.print("delta t:"..t, 10, 10, 0)
	love.graphics.print(buffer,10,100,0)
	printTab(tab)
end

function love.update( dt )
	t=t+dt
	if p then
		e, dataread, size = p:read(32,1)
	end
	if size and size>0 then
		buffer=buffer .. dataread
	end
	if cacheSize==0 then
		start,ends=buffer:find("U%d%[.%]:")
		if start then
			cacheSize = string.byte(buffer,start+3)
			table.insert(tab, 1, buffer:sub(start,start+2) .. buffer:sub(start+3,start+4):byte() .. buffer:sub(start+4,ends))
			buffer=buffer:sub(start+6)
		end
	elseif buffer:len()>cacheSize then
		for i=1,cacheSize do
			tab[1] = tab[1] .. string.format("%02X",buffer:sub(i,i+1):byte()) .. " "
		end
		buffer=buffer:sub(cacheSize)
		cacheSize = 0
	end
	while #tab>17 do
		table.remove(tab)
	end
end
