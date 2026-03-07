function recursiveTriFractal(pos, side)
	if pos.x > width or pos.y > height then
		return
	end
	if side < 1 then
		vecPoint(pos)
	else
		recursiveTriFractal(pos + Vector(side / 4, side * math.sqrt(3) / 4), side / 2)
		recursiveTriFractal(pos + Vector(side / 2, 0), side / 2)
		recursiveTriFractal(pos, side / 2)
	end
end

function drawTriFractal()
	recursiveTriFractal(Vector(width / 4, height / 4), width * math.pow(1.5, time) / 2)
end

function recursiveAnimateTri(pos, side, k)
	local a1, a2, a3 = pos + Vector(side / 4, -side * math.sqrt(3) / 4), pos + Vector(side * 3 / 4, -side * math.sqrt(3) / 4), pos + Vector(side / 2, 0)
	if k >= 1 then
		vecLine(a1, a2)
		vecLine(a2, a3)
		vecLine(a3, a1)
		recursiveAnimateTri(pos, side / 2, k - 1)
		recursiveAnimateTri(a1, side / 2, k - 1)
		recursiveAnimateTri(a3, side / 2, k - 1)
	else
		vecLine(a1, a1 + (a2 - a1) * k)
		vecLine(a2, a2 + (a3 - a2) * k)
		vecLine(a3, a3 + (a1 - a3) * k)
	end
end

function animateTri()
	recursiveAnimateTri(Vector(width / 8, height * 7 / 8), width * 3 / 4, math.abs((time + 8) % 17 - 8))
end

return {drawTriFractal, animateTri}