function recursiveDrawDragon(pos, steps, side, rotation)
	rotation = rotation or 0
	if steps == 0 then
		vecLine(pos, pos + Vector(side, 0):rotated(rotation))
		return Vector(side, 0):rotated(rotation)
	else
		local offset1 = recursiveDrawDragon(pos, steps - 1, side, rotation)
		local offset2 = recursiveDrawDragon(pos + offset1 - offset1:rotated(math.pi / 2), steps - 1, side, rotation + math.pi / 2)
		return offset1 - offset1:rotated(math.pi / 2)
	end
end

function drawDragon()
	recursiveDrawDragon(Vector(width / 2, height / 2), math.floor(math.abs((time * 3 + 15) % 31 - 15)), 8)
end

return {drawDragon}