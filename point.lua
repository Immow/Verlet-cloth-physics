local Vec2 = require("vec2")
local Point = {size = 10}
Point.__index = Point
local active = {}

--Static functions
function Point.new(x, y, locked)
	return setmetatable({
		pos = Vec2(x,y),
		vX = 0,
		vY = 0,
		prevPos = Vec2(x,y),
		locked = locked or false,
		marked = false
	}, Point)
end

function Point.add(x, y, locked)
	table.insert(active, Point.new(x, y, locked))
end

function Point.getPoints()
	return active
end

function Point.getPointAtPos(x,y)
	for i,point in ipairs(active) do
		if (point.pos - Vec2(x,y)):length() < point.size then
			return point
		end
	end
end

function Point.togglePointAtPos(x, y)
	local point = Point.getPointAtPos(x,y)
	if point then
		point:toggle()
	end
end

function Point.unMarkAll()
	for i,point in ipairs(active) do
		point:mark(false)
	end
end

function Point.grabAtCursor()
	if love.keyboard.isDown("e") then
		local x,y = love.mouse.getPosition()
		local p = Point.getPointAtPos(x,y)
		if p then
			p.pos.x = x
			p.pos.y = y
		end
	end
end

function Point.drawAll()
	for _,v in ipairs(active) do
		v:draw()
	end
end

function Point.updateAll(dt)
	for _,v in ipairs(active) do
		v:update(dt)
	end
end

--Methods
local gravity = 1000
local down = Vec2(0, 1)
local friction = 0.9997 -- Conservation of Energy
function Point:update(dt)
	if not self.locked then
		local storePoint = Vec2.copy(self.pos)
		self.pos = self.pos + (self.pos - self.prevPos) * friction
		self.pos = self.pos + down * gravity * dt * dt
		self.prevPos = storePoint
	end
end

function Point:mark(bool)
	self.marked = bool
end

function Point:toggle()
	self.locked = not self.locked
end

function Point:draw()
	if self.marked then
		love.graphics.setColor(0.5,0.5,1,1)
	elseif self.locked then
		love.graphics.setColor(1,0.5,0.5,1)
	else
		love.graphics.setColor(1,1,1,0.4)
	end
	love.graphics.print("X: "..math.floor(self.pos.x).. " -  Y: "..math.floor(self.pos.y),self.pos.x, self.pos.y - 50)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.size)
	love.graphics.circle("line", self.pos.x, self.pos.y, self.size)
	love.graphics.setColor(1,1,1,1)
end

return Point
