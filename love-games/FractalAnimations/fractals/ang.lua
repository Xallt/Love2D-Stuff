function recursiveAngFractal(pos, side, rotation)
	if pos.x > width + side * 3 or pos.y > height + side * 3 then
		return
	end
	rotation = rotation or 0
	local next1 = pos + Vector(side, 0):rotated(rotation)
	local next2 = pos + Vector(side * 3 / 2, -side * math.sqrt(3) / 2):rotated(rotation)
	local next3 = pos + Vector(side * 2, 0):rotated(rotation)
	local next4 = pos + Vector(side * 3, 0):rotated(rotation)
	if side >= 2 then
		recursiveAngFractal(pos, side / 3, rotation)
		recursiveAngFractal(next1, side / 3, rotation - math.pi / 3)
		recursiveAngFractal(next2, side / 3, rotation + math.pi / 3)
		recursiveAngFractal(next3, side / 3, rotation)
	else
		vecLine(pos, next1)
		vecLine(next1, next2)
		vecLine(next2, next3)
		vecLine(next3, next4)
	end
end

function drawAngFractal() 
	recursiveAngFractal(Vector(0, height * 2 / 3), width / 2 * math.pow(1.5, time), 0)
end

function recursiveAnimateAng(pos, side, k, rotation)
	rotation = rotation or 0
	local next1 = pos + Vector(side, 0):rotated(rotation)
	local next2 = pos + Vector(side * 3 / 2, -side * math.sqrt(3) / 2):rotated(rotation)
	local next3 = pos + Vector(side * 2, 0):rotated(rotation)
	local next4 = pos + Vector(side * 3, 0):rotated(rotation)
	if k < 1 then
		vecLine(pos, next1)
		vecLine(next3, next4)
		if k < 0.5 then
			vecLine(next1, next1 + (next2 - next1) * k * 2)
		else
			vecLine(next1, next2)
			vecLine(next2, next2 + (next3 - next2) * (2 * k - 1))
		end
		vecLine(next1 + (next3 - next1) * k, next3)
	else
		recursiveAnimateAng(pos, side / 3, k - 1, rotation)
		recursiveAnimateAng(next1, side / 3, k - 1, rotation - math.pi / 3)
		recursiveAnimateAng(next2, side / 3, k - 1, rotation + math.pi / 3)
		recursiveAnimateAng(next3, side / 3, k - 1, rotation)
	end
end

function animateAng()
	recursiveAnimateAng(Vector(0, height * 2 / 3), width / 3, math.abs((time + 7) % 15 - 7))
end

return {drawAngFractal, animateAng}