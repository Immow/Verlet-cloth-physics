local Stick = {}
Stick.__index = Stick
local Vec2 = require("vec2")
local active = {}

function Stick.new(a, b)
	return setmetatable({
	pointA = a,
	pointB = b,
	length = (a.pos - b.pos):length()
}, Stick)
end

function Stick.add(a, b)
	table.insert(active, Stick.new(a, b))
end

function Stick.getSticks()
	return active
end

function Stick.getCursorOnLine()
	local x,y = love.mouse.getPosition()
	local pVec = Vec2(x,y)

	for i,line in ipairs(active) do
		local d1 = (pVec - line.pointA.pos):length()
		local d2 = (pVec - line.pointB.pos):length()
		local ll = (line.pointA.pos - line.pointB.pos):length()

		local buffer = 0.1

		if (d1+d2 >= ll-buffer and d1+d2 <= ll+buffer) then
			return line;
		end
	end
	return false
end

function Stick.updateAll(dt)
	for i=1,10 do
		for i = 1, #active do
			active[i]:update(dt)
		end
	end
end

function Stick.drawAll()
	for i = 1, #active do
		active[i]:draw()
	end
end

function Stick:update(dt)
	local center = (self.pointA.pos + self.pointB.pos) / 2
	local dir = (self.pointA.pos - self.pointB.pos):normalise()
	if not self.pointA.locked then
		self.pointA.pos = center + dir * (self.length / 2)
	end

	if not self.pointB.locked then
		self.pointB.pos = center - dir * (self.length / 2)
	end
end

function Stick:draw()
	love.graphics.line(self.pointA.pos.x, self.pointA.pos.y, self.pointB.pos.x, self.pointB.pos.y)
end

return Stick
