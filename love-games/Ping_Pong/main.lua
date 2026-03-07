-- Platform constants
PLATFORM_HEIGHT = 40
PLATFORM_WIDTH = 8
PLATFORM_OFFSET = 6
SPEED = 300

-- The ball constants
BALL_START_SPEED = 200
BALL_SPEEDUP = 15
BALL_MAX_SPEED = 420
BALL_RADIUS = 5

-- Window dimensions
WINDOW_WIDTH = 480
WINDOW_HEIGHT = 320

-- Players' positions
local player1Y
local player2Y

-- Game data
score1 = 0
score2 = 0
ballPosition = {x = 240, y = 160}
ballVelocity = {x = 0, y = 0}
ballSpeed = BALL_START_SPEED
timer = 0

local scoreFont
local running = true

-- Making the low resolution look pixelated
love.graphics.setDefaultFilter("nearest", "nearest")

-- Uses the github.com/Ulydev/push for the virtual resolution
local push = require 'push'
push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, 1200, 800, {fullscreen = false, resizable = false, vsync = true})

function reflect(mirror, object)
	return 2 * mirror - object
end

function restartPlatforms()
	player1Y = (WINDOW_HEIGHT - PLATFORM_HEIGHT) / 2
	player2Y = (WINDOW_HEIGHT - PLATFORM_HEIGHT) / 2
end

function startGame(mode)
	if mode == 1 then
		ballPosition = {x = PLATFORM_OFFSET + PLATFORM_WIDTH + 4 * BALL_RADIUS, y = WINDOW_HEIGHT / 2}
		ballVelocity = {x = 1, y = 0}
	elseif mode == 2 then
		ballPosition = {x = WINDOW_WIDTH - PLATFORM_WIDTH - PLATFORM_WIDTH - 4 * BALL_RADIUS, y = WINDOW_HEIGHT / 2}
		ballVelocity = {x = -1, y = 0}
	else
		ballPosition = {x = WINDOW_WIDTH / 2, y = WINDOW_HEIGHT / 2}
		ballVelocity = {x = 2, y = 3}
	end
	ballSpeed = BALL_START_SPEED
end

function love.load()
	push = require 'push'
	scoreFont = love.graphics.newFont("res/LuckiestGuy-Regular.ttf", 30)
	love.graphics.setFont(scoreFont)
	restartPlatforms()
	startGame()
end
function love.draw()
	push:start()
	love.graphics.printf("Score: " .. tostring(score1), 80, 0, 100, "center")
	love.graphics.printf("Score: " .. tostring(score2), 300, 0, 100, "center")
	love.graphics.rectangle("fill", PLATFORM_OFFSET, player1Y, PLATFORM_WIDTH, PLATFORM_HEIGHT)
	love.graphics.rectangle("fill", WINDOW_WIDTH - PLATFORM_OFFSET - PLATFORM_WIDTH, player2Y, PLATFORM_WIDTH, PLATFORM_HEIGHT)
	love.graphics.circle("fill", ballPosition.x, ballPosition.y, BALL_RADIUS)
	push:finish()
end
function movePlayers(delta)
	if love.keyboard.isDown("up") then
		player2Y = math.max(player2Y - delta * SPEED, 0)
	end
	if love.keyboard.isDown("down") then
		player2Y = math.min(player2Y + delta * SPEED, WINDOW_HEIGHT - PLATFORM_HEIGHT)
	end
	if love.keyboard.isDown("w") then
		player1Y = math.max(player1Y - delta * SPEED, 0)
	end
	if love.keyboard.isDown("s") then
		player1Y = math.min(player1Y + delta * SPEED, WINDOW_HEIGHT - PLATFORM_HEIGHT)
	end
end
function moveBall(delta)
	local velocityVecLength = math.sqrt(ballVelocity.x * ballVelocity.x + ballVelocity.y * ballVelocity.y)
	ballPosition.x, ballPosition.y = ballPosition.x + delta * ballSpeed * ballVelocity.x / velocityVecLength, ballPosition.y + delta * ballSpeed * ballVelocity.y / velocityVecLength
	if ballPosition.y - BALL_RADIUS < 0 then
		ballPosition.y = 2 * BALL_RADIUS - ballPosition.y
		ballVelocity.y = -ballVelocity.y
	end
	if ballPosition.y + BALL_RADIUS > WINDOW_HEIGHT then
		ballPosition.y = 2 * (WINDOW_HEIGHT - BALL_RADIUS) - ballPosition.y
		ballVelocity.y = -ballVelocity.y
	end
end

function handlePlayer1Collision()
	local leftEdge = ballPosition.x - BALL_RADIUS
	if ballPosition.y < player1Y or ballPosition.y > player1Y + PLATFORM_HEIGHT or leftEdge > PLATFORM_OFFSET + PLATFORM_WIDTH then
		return
	end
	ballPosition.x = reflect(PLATFORM_OFFSET + PLATFORM_WIDTH, leftEdge) + BALL_RADIUS
	ballVelocity.x, ballVelocity.y = ballPosition.x - PLATFORM_OFFSET, (ballPosition.y - player1Y - PLATFORM_HEIGHT / 2) / 2
	ballSpeed = math.min(ballSpeed + BALL_SPEEDUP, BALL_MAX_SPEED)
end

function handlePlayer2Collision()	
	local rightEdge = ballPosition.x + BALL_RADIUS
	if ballPosition.y < player2Y or ballPosition.y > player2Y + PLATFORM_HEIGHT or rightEdge < WINDOW_WIDTH - PLATFORM_OFFSET - PLATFORM_WIDTH then
		return
	end
	ballPosition.x = reflect(WINDOW_WIDTH - PLATFORM_OFFSET - PLATFORM_WIDTH, rightEdge) - BALL_RADIUS
	ballVelocity.x, ballVelocity.y = ballPosition.x - WINDOW_WIDTH + PLATFORM_OFFSET, (ballPosition.y - player2Y - PLATFORM_HEIGHT / 2) / 2
	ballSpeed = math.min(ballSpeed + BALL_SPEEDUP, BALL_MAX_SPEED)
end

function handleCollisions()
	handlePlayer1Collision()
	handlePlayer2Collision()
end

function whoLost()
	if ballPosition.x - BALL_RADIUS <= 0 then
		return 1
	end
	if ballPosition.x + BALL_RADIUS >= WINDOW_WIDTH then
		return 2
	end
	return 0
end

function love.update(delta)
	if not running then
		return
	end
	movePlayers(delta)
	moveBall(delta)
	handleCollisions()
	local gameState = whoLost()
	if gameState ~= 0 then
		if gameState == 1 then
			score2 = score2 + 50
			startGame(1)
		else
			score1 = score1 + 50
			startGame(2)
		end
	end
end