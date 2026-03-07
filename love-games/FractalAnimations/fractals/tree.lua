function recursiveTreeFractal(pos, side, angle, rotation)
	rotation = rotation or 0
	if side < 1 then
		return
	else 
		local left, right = pos + Vector(-math.sin(angle) * side, -math.cos(angle) * side):rotated(rotation), pos + Vector(math.sin(angle) * side, -math.cos(angle) * side):rotated(rotation)
		vecLine(pos, left)
		vecLine(pos, right)
		recursiveTreeFractal(left, side * 3 / 5, angle, rotation - angle)
		recursiveTreeFractal(right, side * 3 / 5, angle, rotation + angle)
	end
end
function drawTreeFractal()
	recursiveTreeFractal(Vector(width / 2, height), height * 2 / 5, math.sin(time / 3) * math.pi / 2)
end

return {drawTreeFractal}