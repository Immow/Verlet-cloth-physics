local Legend = {}

Legend.draw        = false
Legend.x           = 20
Legend.y           = 10
Legend.color       = {1,1,1,0.5}
Legend.help        = "[H] - Toggle help"
Legend.drawPoint   = "[1] - Spawn node"
Legend.lockPoint   = "[2] - Toggle node (static/dynamic)"
Legend.movePoint   = "[R] - Move node"
Legend.addStick    = "[LMB] - Connect nodes, clik node then drag and release on another node"
Legend.removeStick = "[RMB] - Remove sticks, drag across a stick to delete it"
Legend.pause       = "[SPACE] - Pause simulation"
Legend.quit        = "[ESCAPE] - Quit program"
Legend.restart     = "[R] - Restart program"
Legend.drawGrid    = "[LMB] + [CTRL] - Create a grid of connected nodes, draw a square"
Legend.points      = 0
Legend.sticks      = 0

function Legend.drawLegend()
	love.graphics.setColor(Legend.color)
	if Legend.draw then
		love.graphics.print(
			Legend.help.."\n\n"..
			Legend.drawPoint.."\n"..
			Legend.lockPoint.."\n"..
			Legend.movePoint.."\n"..
			Legend.addStick.."\n"..
			Legend.removeStick.."\n"..
			Legend.pause.."\n"..
			Legend.quit.."\n"..
			Legend.restart.."\n"..
			Legend.drawGrid.."\n"..
			"\nDebug information\n"..
			"Nodes: "..Legend.points.."\n"..
			"Edges: "..Legend.sticks.."\n"
			, Legend.x, Legend.y)
	else
		love.graphics.print(Legend.help,Legend.x,Legend.y)
	end
end

return Legend
