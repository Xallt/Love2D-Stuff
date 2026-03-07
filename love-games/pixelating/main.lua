local kirby
local pixelatingShaderCode = [[
	uniform vec2 resolution;
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
    	vec4 texcolor = Texel(texture, floor(texture_coords * resolution) / resolution);
        return texcolor * color;
    }
]]
local shader

local time
local res = 3

function love.load()
	time = 0
	kirby = love.graphics.newImage("Kirby.png")
	love.window.setMode(kirby:getWidth(), kirby:getHeight(), {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	shader = love.graphics.newShader(pixelatingShaderCode)
end

function love.update(dt)
	time = time + dt
end

function love.draw()
	love.graphics.setShader(shader)
	shader:send("resolution", {res, res})
	love.graphics.draw(kirby, 0, 0)
	love.graphics.setShader()
	love.graphics.setNewFont(24)
	love.graphics.printf("Scroll", 0, 0, love.graphics.getWidth(), "center")
end

function love.wheelmoved(x, y)
	if y > 0 then
		res = res + 1
	elseif y < 0 then
		res = math.max(res - 1, 1)
	end
end