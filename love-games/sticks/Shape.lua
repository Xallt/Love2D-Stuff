Shape = class("Shape")

Shape.static.zero = {{0, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}, {0, 2, 0, 1}, {0, 1, 0, 0}}
Shape.static[0] = Shape.zero

Shape.static.one = {{1, 0, 1, 1}, {1, 1, 1, 2}}
Shape.static[1] = Shape.one

Shape.static.two = {{0, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 0, 1}, {0, 1, 0, 2}, {0, 2, 1, 2}}
Shape.static[2] = Shape.two

Shape.static.three = {{0, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 0, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}}
Shape.static[3] = Shape.three

Shape.static.four = {{0, 0, 0, 1}, {0, 1, 1, 1}, {1, 1, 1, 0}, {1, 1, 1, 2}}
Shape.static[4] = Shape.four

Shape.static.five = {{0, 0, 1, 0}, {0, 0, 0, 1}, {0, 1, 1, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}}
Shape.static[5] = Shape.five

Shape.static.six = {{0, 0, 1, 0}, {0, 0, 0, 1}, {0, 1, 1, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}, {0, 2, 0, 1}}
Shape.static[6] = Shape.six

Shape.static.seven = {{0, 0, 1, 0}, {1, 0, 0, 1}, {0, 1, 0, 2}}
Shape.static[7] = Shape.seven

Shape.static.eight = {{0, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 0, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}, {0, 1, 0, 2}, {0, 0, 0, 1}}
Shape.static[8] = Shape.eight

Shape.static.nine = {{0, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, 0, 1}, {1, 1, 1, 2}, {1, 2, 0, 2}, {0, 0, 0, 1}}
Shape.static[9] = Shape.nine

function Shape:initialize(sticks, x, y, scale)
  scale = scale or 1
  self.sticks = {}
  for i = 1, #sticks do
    table.insert(self.sticks, Stick:new(x + sticks[i][1] * scale, y + sticks[i][2] * scale, x + sticks[i][3] * scale, y + sticks[i][4] * scale))
  end
end

function Shape:animateTo(sticks, x, y, scale, duration, ease)
  ease = ease or 'inOutCubic'
  if self._newSticks then
    for i = 1, #self.sticks do
      self.sticks[i]:endAnimation()
    end
    self._newSticks = nil
  end

  -- Random shuffle
  for i = 1, #self.sticks do
    a, b = math.random(1, #self.sticks), math.random(1, #self.sticks)
    local cStick = self.sticks[a]
    self.sticks[a] = self.sticks[b]
    self.sticks[b] = cStick
  end

  if #sticks > #self.sticks then
    local oldSize = #self.sticks
    for i = 1, #sticks - oldSize do
      table.insert(self.sticks, self.sticks[math.random(1, oldSize)]:copy())
    end
    for i = 1, #self.sticks do
      self.sticks[i]:animateTo(x + sticks[i][1] * scale, y + sticks[i][2] * scale, x + sticks[i][3] * scale, y + sticks[i][4] * scale, duration, ease)
    end
  else
    for i = 1, #sticks do
      self.sticks[i]:animateTo(x + sticks[i][1] * scale, y + sticks[i][2] * scale, x + sticks[i][3] * scale, y + sticks[i][4] * scale, duration, ease)
    end
    for i = #sticks + 1, #self.sticks do
      a = math.random(1, #sticks)
      self.sticks[i]:animateTo(x + sticks[a][1] * scale, y + sticks[a][2] * scale, x + sticks[a][3] * scale, y + sticks[a][4] * scale, duration, ease)
    end
  end
  self._newSticks = sticks
end

function Shape:update(dt)
  for i = 1, #self.sticks do
    self.sticks[i]:update(dt)
  end

  if self._newSticks then
    if #self.sticks > #self._newSticks then
      for i = #self.sticks, #self._newSticks + 1, -1 do
        if not self.sticks[i]:isAnimating() then
          table.remove(self.sticks, i)
        end
      end
      if #self.sticks == #self._newSticks then
          self._newSticks = nil
      end
    else
      local animating = false
      for i = 1, #self.sticks do
        animating = animating or self.sticks[i]:isAnimating()
      end
      if not animating then
        self._newSticks = nil
      end
    end
  end
end

function Shape:render()
  for i = 1, #self.sticks do
    self.sticks[i]:render()
  end
end

function Shape:isAnimating()
  return self._newSticks ~= nil
end

return Shape
