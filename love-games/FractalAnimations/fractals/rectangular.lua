function recursiveDrawRectangular(pos, side, rotation)
	if pos.x - side > width or pos.y - side > height or pos.x + side < 0 or pos.y + side < 0 then

	end
	if side <= 4 then
		vecPoint(pos)
	else
		local sside = side * math.sqrt(2) / 3
		local a1, a2, a3, a4 = pos + Vector(sside, 0):rotated(rotation), 
							   pos + Vector(sside, 0):rotated(rotation + math.pi / 2), 
							   pos + Vector(sside, 0):rotated(rotation + math.pi), 
							   pos + Vector(sside, 0):rotated(rotation + 3 * math.pi / 2)
		recursiveDrawRectangular(a1, sside, rotation + math.pi / 4)
		recursiveDrawRectangular(a2, sside, rotation + math.pi / 4)
		recursiveDrawRectangular(a3, sside, rotation + math.pi / 4)
		recursiveDrawRectangular(a4, sside, rotation + math.pi / 4)
	end
end

function drawRectangular()
	recursiveDrawRectangular(Vector(width / 2, height / 2), time * 100 + 20, math.pi / 4)
end

return {drawRectangular}