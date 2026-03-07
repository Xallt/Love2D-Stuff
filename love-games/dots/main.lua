clicks = 0
dots = {}
force = 0.2
dpc = 20
function love.draw()
	love.graphics.print("Clicks: " .. clicks, x, y)
	for i = 1, #dots do
		love.graphics.points(dots[i].x, dots[i].y)
	end 
end

function spawnPoint(x, y)
	table.insert(dots, {x = x, y = y, vx = 0, vy = 0})
end

function dropPoints(x, y, count, offset)
	for i = 1, count do
		spawnPoint(x + math.random(-offset, offset), y + math.random(-offset, offset))
	end
end

function love.update(delta)
	for i = 1, #dots do
		dots[i].x, dots[i].y = dots[i].x + dots[i].vx, dots[i].y + dots[i].vy
		if dots[i].x > love.graphics.getWidth() then
			dots[i].vx = -math.abs(dots[i].vx)
			dots[i].x = love.graphics.getWidth() * 2 - dots[i].x
		end
		if dots[i].y > love.graphics.getHeight() then
			dots[i].vy = -math.abs(dots[i].vy)
			dots[i].y = love.graphics.getHeight() * 2 - dots[i].y
		end
		if dots[i].x < 0 then
			dots[i].vx = math.abs(dots[i].vx)
			dots[i].x = -dots[i].x
		end
		if dots[i].y < 0 then
			dots[i].vy = math.abs(dots[i].vy)
			dots[i].y = -dots[i].y
		end
		dots[i].vx = dots[i].vx * math.pow(0.8, delta)
		dots[i].vy = dots[i].vy * math.pow(0.8, delta)
	end
	if love.mouse.isDown(1) then
		clicks = clicks + 1
		dropPoints(love.mouse.getX(), love.mouse.getY(), 10, 5)
	end
	if love.mouse.isDown(2) then
		mx, my = love.mouse.getPosition()
		for i = 1, #dots do
			dx, dy = mx - dots[i].x, my - dots[i].y
			dlen = math.sqrt(dx * dx + dy * dy)
			dx, dy = dx / dlen * force, dy / dlen * force
			dots[i].vx = dots[i].vx + dx
			dots[i].vy = dots[i].vy + dy
		end 
	end
end