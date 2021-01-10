-- la.tokes - Advanced Text Animation System

-- limitations:
-- · currently does not support line breaks. use separate tokes objects for that

local util = pan.require "la.util"

local tokes = {}
tokes.__index = tokes

-- Creates a new tokes object from the given table.
function tokes.new(t)

  local self = {}
  assert(t ~= nil)
  assert(type(t.font) == "userdata")
  assert(type(t.size) == "number")
  setmetatable(self, tokes)

  self.font = t.font
  self.fontSize = t.size
  self.byindex = {}
  self.bytag = {}

  self.height = 0

  local x = 0
  for i, spec in ipairs(t) do
    assert(type(spec[1]) == "string")

    local tw, th = pan.textSize(t.font, spec[1], t.size)
    local token = {
      -- these values should never be modified after they're assigned!
      sourceText = spec[1],
      sourceColor = spec[2] or t.color,
      sourceX = x + (t.x or 0),
      sourceY = t.y or 0,
      tag = spec.tag,
      underline = 0,
      width = tw,
    }
    token.text = token.sourceText
    token.color = token.sourceColor
    token.x = token.sourceX
    token.y = token.sourceY

    self.byindex[i] = token
    if type(token.tag) == "string" then
      self:_addToTag(token, token.tag)
    end

    x = x + tw
    self.height = math.max(self.height, th)
  end

  self.width = x

  return self

end


function tokes._addToTag(self, token, tag)
  if self.bytag[tag] == nil then
    self.bytag[tag] = {}
  end
  table.insert(self.bytag[tag], token)
end


-- Draws tokes at the given position. This is the "raw" function without
-- support for alignment.
function tokes.raw_draw(self, x, y)

  for _, token in ipairs(self.byindex) do
    local tx, ty = x + token.x, y + token.y
    pan.textf(
      self.font,
      tx, ty,
      token.text, self.fontSize,
      pan.solid(token.color)
    )
    if token.underline > 0 and token.underline < 2 then
      local thickness = self.fontSize / 10.6
      local paint = pan.solid(token.color):lineWidth(thickness)
      local x0, x1 = tx, tx + token.width
      local y = math.floor(ty + self.height * 1.15 + thickness) + 0.5

      if token.underline < 1 then
        x1 = pan.interp(x0, x1, token.underline)
      elseif token.underline > 1 then
        x0 = pan.interp(x0, x1, token.underline - 1)
      end


      pan.line(x0, y, x1, y, paint)
    end
  end

end


-- Draws tokes at the given position.
function tokes.draw(self, x, y, w, h, halign, valign)

  w = w or 0
  h = h or 0
  halign = halign or pan.taLeft
  valign = valign or pan.taTop

  local tw, th = self.width, self.height
  local tx, ty = x, y + th

  if     halign == pan.taCenter then tx = x + w / 2 - tw / 2
  elseif halign == pan.taRight  then tx = x + w - tw
  end

  if     valign == pan.taMiddle then ty = y + h / 2 - th / 2
  elseif valign == pan.taBottom then ty = y + h
  end

  tokes.raw_draw(self, tx, ty)

end


-- Eases and fades in all tokens from bottom.
-- delta controls the interval at which tokens appear one by one.
function tokes.transitionIn(self, starttime, delta)

  for i, token in ipairs(self.byindex) do
    local t = pan.easel(0, 1, starttime + (i - 1) * delta, 1, pan.quinticOut)
    if t <= 1 then
      token.y =
        pan.map(t, 0, 1, token.sourceY + self.height * 0.75, token.sourceY)
      token.color = util.colorWithAlpha(token.color, t * 255)
    end
  end

end


-- Fades out all tokens.
-- Note that you want to put this *after* all your highlights.
function tokes.transitionOut(self, starttime, length)

  for i, token in ipairs(self.byindex) do
    local t = pan.easel(1, 0, starttime, length)
    if t < 1 then
      token.color = util.colorWithAlpha(token.color, t * 255)
    end
  end

end


-- Tints tagged tokens with the given color.
function tokes.tint(self, tag, starttime, endtime, color)

  assert(type(self.bytag[tag]) == "table")

  local fadeTime = 0.2

  for _, token in ipairs(self.bytag[tag]) do
    local tin = pan.ease(0, 1, starttime, starttime + fadeTime)
    local tout = pan.ease(1, 0, endtime - fadeTime, endtime)
    local t = tin * tout
    if t > 0 or tout == 0 then
      token.color = util.blendColors(token.sourceColor, color, t)
    end
  end

end

-- Eases the underline property on tagged tokens.
function tokes.underline(self, tag, starttime, endtime)

  assert(type(self.bytag[tag]) == "table")

  local easeTime = 0.3

  for _, token in ipairs(self.bytag[tag]) do
    token.underline = pan.keyframes {
      { time = starttime, val = 0 },
      { time = starttime + easeTime, val = 1, easing = pan.quadInOut },
      { time = endtime - easeTime, val = 1 },
      { time = endtime, val = 2, easing = pan.quadInOut },
    }
  end

end


return tokes
