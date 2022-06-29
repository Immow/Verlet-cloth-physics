local point = require("point")
local stick = require("stick")
local legend = require("legend")
local grid = require("grid")

local active = false

local function removeSticks()
	if love.mouse.isDown(2) then
		local found = stick.getCursorOnLine()
		if found then
			local sticks = stick.getSticks()
			for i = 1, #sticks do
				if sticks[i] == found then
					table.remove(sticks, i)
				end
			end
		end
	end
end

local function getAmountOfEntities()
	if #point.getPoints() then
		legend.points = #point.getPoints()
	end

	if #stick.getSticks() then
		legend.sticks = #stick.getSticks()
	end
end

function love.update(dt)
	grid:update(dt)
	getAmountOfEntities()
	removeSticks()
	point.grabAtCursor()
	if not active then return end
	point.updateAll(dt)
	stick.updateAll(dt)
end

function love.draw()
	grid:draw()
	legend.drawLegend()
	point.drawAll()
	stick.drawAll()
end

local target_a
local target_b
function love.mousepressed(x, y, button)
	if button == 1 then
		grid:getPos(x,y)
		target_a = point.getPointAtPos(x,y)
		if target_a then
			target_a:mark(true)
		end
	end
end

function love.mousereleased(x, y, button)
	if button == 1 then
		target_b = point.getPointAtPos(x,y)
		if target_a and target_b then
			stick.add(target_a, target_b)
		end
		point.unMarkAll()
		grid:createMatrix()
	end
end

function love.keypressed( key, scancode, isrepeat )
	local x,y = love.mouse.getPosition()
	if key == "1" then
		point.add(x, y)
	elseif key == "2" then
		point.togglePointAtPos(x, y)
	end

	if key == "space" then
		active = not active
	end

	if key == "escape" then
		love.event.quit()
	end

	if key == "h" then
		legend.draw = not legend.draw
	end

	if key == "r" then
		love.event.quit("restart")
	end
end
