Stick = class('Stick')

function Stick:initialize(x1, y1, x2, y2, texture)
  self.x = x1
  self.y = y1
  self.rotation = math.atan2(y2 - y1, x2 - x1)
  self.length = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
  if texture then
    self.texture = texture
  else
    self.texture = love.graphics.newCanvas(1, 1)
    love.graphics.setCanvas(self.texture)
    love.graphics.clear(1, 1, 1)
    love.graphics.setCanvas()
  end
end

function Stick:animateTo(x1, y1, x2, y2, duration, ease)
  local newRotation = math.atan2(y2 - y1, x2 - x1)
  local newLength = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
  self._moveTween = tween.new(duration or 1, self, {x = x1, y = y1, rotation = newRotation, length = newLength}, ease or 'inOutCubic')
end

function Stick:update(dt)
  if self._moveTween then
    if self._moveTween:update(dt) then
      self._moveTween = nil
    end
  end
end

function Stick:endAnimation()
  self._moveTween:set(self._moveTween.duration)
  self._moveTween = nil
end

function Stick:render()
  love.graphics.draw(self.texture, self.x, self.y, self.rotation, self.length / self.texture:getWidth(), 1)
end

function Stick:isAnimating()
  return self._moveTween ~= nil
end

function Stick:destination()
  return self.x + math.cos(self.rotation) * self.length, self.y + math.sin(self.rotation) * self.length
end

function Stick:unpack()
  return self.x, self.y, self:destination()
end

function Stick:copy()
  return Stick:new(self.x, self.y, self:destination())
end

return Stick
