local point = require("point")
local stick = require("stick")

local Grid = {}
Grid.innit = false
Grid.posX = 0
Grid.posY = 0
Grid.w = 0
Grid.h = 0
Grid.collumns = 0
Grid.rows = 0
Grid.collumnsSpacing = 100
Grid.boundingBox = function() love.graphics.rectangle("line", Grid.posX, Grid.posY, Grid.w, Grid.h) end

function Grid:getPos(x,y)
	if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then
		self.posX = x
		self.posY = y
		self.innit = true
	end
end

local points = {}
function Grid:createRows()
	local itterations = self.rows

	for _ = 1, itterations do
		local prevPointX = nil
		local currentPointX = nil

		for _ = 1, self.collumns do
			point.add(self.posX,self.posY)
			table.insert(points, {self.posX,self.posY})
			if prevPointX then -- Add a connection only when two points are present
				currentPointX = point.getPointAtPos(self.posX,self.posY)
				stick.add(prevPointX, currentPointX)
			end
			prevPointX = point.getPointAtPos(self.posX,self.posY)

			self.posX = self.posX + self.collumnsSpacing
		end

		self.posX = points[1][1] -- Reset x position for the next row

		self.posY = self.posY + self.collumnsSpacing
		itterations = itterations - 1
	end
end

function Grid:createCollums()
	if self.rows < 2 then return end
	local c = self.collumns
	local cr = self.collumns * (self.rows - 1)

	for i = 1, cr do
		local p1 = point.getPointAtPos(points[i][1],points[i][2]) -- Get top point
		local p2 = point.getPointAtPos(points[i+c][1],points[i+c][2]) -- Get bottom point
		stick.add(p1, p2)
	end
end

function Grid:createMatrix()
	self.collumns = math.floor(self.w / self.collumnsSpacing)
	self.rows = math.floor(self.h / self.collumnsSpacing)
	if self.rows == 0 then self.rows = 1 end
	if self.collumns == 0 then self.collumns = 1 end
	if self.innit then
		self:createRows()
		self:createCollums()
	end
	-- Reset all stored values
	self.innit = false
	self.collumns = 0
	self.rows = 0
	points = {}
end

function Grid:draw()
	if self.innit then
		self.boundingBox()
	end
end

function Grid:update(dt)
	if self.innit then
		self.w = math.abs(self.posX - love.mouse.getX())
		self.h = math.abs(self.posY - love.mouse.getY())
	end
end

return Grid