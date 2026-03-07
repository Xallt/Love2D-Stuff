function recursiveDrawCurve(pos, side, rotation)
	if pos.x - side * 4 > width or pos.y - side * 4 > height or pos.y + side * 4 < 0 then
		return
	end
	rotation = rotation or 0
	if side <= 4 then
		vecLine(pos, pos + Vector(side, 0):rotated(rotation))
		vecLine(pos + Vector(side, 0):rotated(rotation), pos + Vector(side, -side):rotated(rotation))
		vecLine(pos + Vector(side, -side):rotated(rotation), pos + Vector(2 * side, -side):rotated(rotation))
		vecLine(pos + Vector(2 * side, -side):rotated(rotation), pos + Vector(2 * side, 0):rotated(rotation))
		vecLine(pos + Vector(2 * side, 0):rotated(rotation), pos + Vector(2 * side, side):rotated(rotation))
		vecLine(pos + Vector(2 * side, side):rotated(rotation), pos + Vector(3 * side, side):rotated(rotation))
		vecLine(pos + Vector(3 * side, side):rotated(rotation), pos + Vector(3 * side, 0):rotated(rotation))
		vecLine(pos + Vector(3 * side, 0):rotated(rotation), pos + Vector(4 * side, 0):rotated(rotation))
	else
		recursiveDrawCurve(pos, side / 4, rotation)
		recursiveDrawCurve(pos + Vector(side, 0):rotated(rotation), side / 4, rotation - math.pi / 2)
		recursiveDrawCurve(pos + Vector(side, -side):rotated(rotation), side / 4, rotation)
		recursiveDrawCurve(pos + Vector(side * 2, -side):rotated(rotation), side / 4, rotation + math.pi / 2)
		recursiveDrawCurve(pos + Vector(side * 2, 0):rotated(rotation), side / 4, rotation + math.pi / 2)
		recursiveDrawCurve(pos + Vector(side * 2, side):rotated(rotation), side / 4, rotation)
		recursiveDrawCurve(pos + Vector(side * 3, side):rotated(rotation), side / 4, rotation - math.pi / 2)
		recursiveDrawCurve(pos + Vector(side * 3, 0):rotated(rotation), side / 4, rotation)
	end
end

function drawCurve()
	recursiveDrawCurve(Vector(0, height / 2), width / 8 * math.pow(1.5, time))
end

function recursiveAnimateCurve(pos, side, k, rotation)
	if pos.x - side * 4 > width or pos.y - side * 4 > height or pos.y + side * 4 < 0 then
		return
	end
	rotation = rotation or 0
	if k <= 1 then
		local a1, a2, a3 = pos + Vector(side, 0):rotated(rotation), pos + Vector(side, -side):rotated(rotation), pos + Vector(2 * side, -side):rotated(rotation)
		local a4, a5, a6 = pos + Vector(2 * side, 0):rotated(rotation), pos + Vector(2 * side, side):rotated(rotation), pos + Vector(3 * side, side):rotated(rotation)
		local a7, a8 = pos + Vector(3 * side, 0):rotated(rotation), pos + Vector(4 * side, 0):rotated(rotation)
		vecLine(pos, a1)
		vecLine(a7, a8)
		vecLine(pos + (a8 - pos) * k, a8)
		vecLine(a1, a1 + (a2 - a1) * clamp(k * 6, 0, 1))
		vecLine(a2, a2 + (a3 - a2) * clamp(k * 6 - 1, 0, 1))
		vecLine(a3, a3 + (a4 - a3) * clamp(k * 6 - 2, 0, 1))
		vecLine(a4, a4 + (a5 - a4) * clamp(k * 6 - 3, 0, 1))
		vecLine(a5, a5 + (a6 - a5) * clamp(k * 6 - 4, 0, 1))
		vecLine(a6, a6 + (a7 - a6) * clamp(k * 6 - 5, 0, 1))
	else
		recursiveAnimateCurve(pos, side / 4, k - 1, rotation)
		recursiveAnimateCurve(pos + Vector(side, 0):rotated(rotation), side / 4, k - 1, rotation - math.pi / 2)
		recursiveAnimateCurve(pos + Vector(side, -side):rotated(rotation), side / 4, k - 1, rotation)
		recursiveAnimateCurve(pos + Vector(side * 2, -side):rotated(rotation), side / 4, k - 1, rotation + math.pi / 2)
		recursiveAnimateCurve(pos + Vector(side * 2, 0):rotated(rotation), side / 4, k - 1, rotation + math.pi / 2)
		recursiveAnimateCurve(pos + Vector(side * 2, side):rotated(rotation), side / 4, k - 1, rotation)
		recursiveAnimateCurve(pos + Vector(side * 3, side):rotated(rotation), side / 4, k - 1, rotation - math.pi / 2)
		recursiveAnimateCurve(pos + Vector(side * 3, 0):rotated(rotation), side / 4, k - 1, rotation)
	end
end

function animateCurve()
	recursiveAnimateCurve(Vector(0, height / 2), width / 4, math.abs((time + 4) % 9 - 4))
end

return {drawCurve, animateCurve}