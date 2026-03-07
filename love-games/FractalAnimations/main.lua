-- Made by: Dmitry Shabat

-- Resource Lua files from fractals/ return lists of drawing functions (that take no arguments in) related to the shape

-- Defined global variables:
--[[
	time - Time in seconds passed after Love loaded
	width, height - Window resolution
	Vector - arithmetic 2D vector class
]]
-- Defined global functions:
--[[
	vecPoint - Takes in a vector, draws a point at the coordinates
	vecLine - Takes two vectors, draws a line conecting the coordinates
]]

Vector = require 'vector'

function love.load()
	time = 0
	width, height = love.graphics.getWidth(), love.graphics.getHeight()
end

function vecPoint(a)
	love.graphics.points(a.x, a.y)
end

function vecLine(a, b)
	love.graphics.line(a.x, a.y, b.x, b.y)
end

function clamp(x, a, b)
	return math.min(math.max(x, a), b)
end


-- Menu of the fractal animations
local fractals = {
	require 'fractals.triangle',
	require 'fractals.tree',
	require 'fractals.ang',
	require 'fractals.dragon',
	require 'fractals.curve',
	require 'fractals.rectangular'
}

-- Current choice in menu
local fractalIndex, fractalSubIndex = 1, 1

function love.keypressed(key)
	if key == 'down' then
		fractalIndex = fractalIndex % #fractals + 1
		fractalSubIndex = 1
		time = 0
	end
	if key == 'up' then
		fractalIndex = (fractalIndex - 2) % #fractals + 1
		fractalSubIndex = 1
		time = 0
	end
	if key == 'left' then
		fractalSubIndex = (fractalSubIndex - 2) % #fractals[fractalIndex] + 1
		time = 0
	end
	if key == 'right' then
		fractalSubIndex = fractalSubIndex % #fractals[fractalIndex] + 1
		time = 0
	end
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	time = time + dt
	width, height = love.graphics.getWidth(), love.graphics.getHeight()
end

function love.wheelmoved(x, y)
	time = time + y / 10
end

function love.draw()
	love.graphics.setColor(0.98, 0.2, 0.114, 1)
	love.graphics.print(time, 0, 0)
	love.graphics.setColor(1, 1, 1, 1)
	fractals[fractalIndex][fractalSubIndex]()
	local ry = height - 10
	for row = #fractals, 1, -1 do
		rx = 10
		for col = 1, #fractals[row] do
			if row == fractalIndex and col == fractalSubIndex then
				love.graphics.setColor(0, 1, 0, 1)
			else
				love.graphics.setColor(0, 0, 1, 1)
			end
			love.graphics.rectangle('fill', rx, ry - 10, 10, 10)
			love.graphics.setColor(1, 1, 1, 1)
			rx = rx + 15
		end
		ry = ry - 15
	end
end