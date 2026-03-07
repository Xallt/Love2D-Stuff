-- Libraries
class = require 'middleclass'
tween = require 'tween'

Stick = require 'Stick'
Shape = require 'Shape'


local SCALE, SPACE = 90, 20
local WIDTH, HEIGHT = 800, 600

-- A shape for each digit
local hour1, hour2, minute1, minute2, second1, second2

local prevTime
local timer

function love.load()
  math.randomseed(os.time())
	love.window.setMode(WIDTH, HEIGHT, {resizable=false})
	time = os.date("*t")
	hour1 = Shape:new(Shape[math.floor(time.hour / 10)], WIDTH / 2 - 3 * SCALE - 4.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	hour2 = Shape:new(Shape[time.hour % 10], WIDTH / 2 - 2 * SCALE - 3.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	minute1 = Shape:new(Shape[math.floor(time.min / 10)], WIDTH / 2 - SCALE - 0.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	minute2 = Shape:new(Shape[time.min % 10], WIDTH / 2 + 0.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	second1 = Shape:new(Shape[math.floor(time.sec / 10)], WIDTH / 2 + SCALE + 3.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	second2 = Shape:new(Shape[time.sec % 10], WIDTH / 2 + 2 * SCALE + 4.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
	prevTime = time
	timer = 0
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit(0)
  end
end

function love.update(dt)
  hour1:update(dt)
	hour2:update(dt)
	minute1:update(dt)
	minute2:update(dt)
	second1:update(dt)
	second2:update(dt)
	timer = timer + dt
	if timer >= 1 then
		local time = os.date("*t")
		if math.floor(time.hour / 10) ~= math.floor(prevTime.hour / 10) then
			hour1:animateTo(Shape[math.floor(time.hour / 10)], WIDTH / 2 - 3 * SCALE - 4.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		if time.hour % 10 ~= prevTime.hour % 10 then
			hour2:animateTo(Shape[time.hour % 10], WIDTH / 2 - 2 * SCALE - 3.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		if math.floor(time.min / 10) ~= math.floor(prevTime.min / 10) then
			minute1:animateTo(Shape[math.floor(time.min / 10)], WIDTH / 2 - SCALE - 0.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		if time.min % 10 ~= prevTime.min % 10 then
			minute2:animateTo(Shape[time.min % 10], WIDTH / 2 + 0.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		if math.floor(time.sec / 10) ~= math.floor(prevTime.sec / 10) then
			second1:animateTo(Shape[math.floor(time.sec / 10)], WIDTH / 2 + SCALE + 3.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		if time.sec % 10 ~= prevTime.sec % 10 then
			second2:animateTo(Shape[time.sec % 10], WIDTH / 2 + 2 * SCALE + 4.5 * SPACE, (HEIGHT - 2 * SCALE) / 2, SCALE)
		end
		prevTime = time
		timer = 0
	end
end

function love.draw()
	hour1:render()
	hour2:render()
	minute1:render()
	minute2:render()
	second1:render()
	second2:render()
	love.graphics.rectangle("fill", WIDTH / 2 - SPACE * 2.5 - SCALE, (HEIGHT - SCALE * 2) / 2 + (2 * SCALE - 4 * SPACE) / 2, SPACE, SPACE)
	love.graphics.rectangle("fill", WIDTH / 2 - SPACE * 2.5 - SCALE, (HEIGHT - SCALE * 2) / 2 + (2 * SCALE - 4 * SPACE) / 2 + 3 * SPACE, SPACE, SPACE)
	love.graphics.rectangle("fill", WIDTH / 2 + SPACE * 1.5 + SCALE, (HEIGHT - SCALE * 2) / 2 + (2 * SCALE - 4 * SPACE) / 2, SPACE, SPACE)
	love.graphics.rectangle("fill", WIDTH / 2 + SPACE * 1.5 + SCALE, (HEIGHT - SCALE * 2) / 2 + (2 * SCALE - 4 * SPACE) / 2 + 3 * SPACE, SPACE, SPACE)
end
