animation { width = 1920, height = 1080, length = 4.5 }

-- la libs
local la = {}
la.trim = pan.require "la/trim"
la.palette, la.paints = unpack(pan.require "la/palette")
la.fonts = pan.require "la/fonts"
la.text = pan.require "la/text"

-- logo data
local LogoSize = 400
local LOffset = -LogoSize / 2 + 48
local LogoHalf = {
  { x = LOffset + 32,                       y = -LogoSize / 2 },
  { x = LOffset + 32,                       y = 64 },
  { x = LOffset + math.floor(LogoSize / 3), y = 32 },
  { x = LOffset + math.floor(LogoSize / 3), y = -48 },
}
local LogoFont = la.fonts.bold
local LogoName = "lqdev"
local LogoTextSize = 72

la.trim.prepare(LogoHalf)

-- box with logo inside of it
function addLogo()
  rect(-LogoSize / 2, -LogoSize / 2, LogoSize, LogoSize)
  for _, scale in ipairs({-1, 1}) do
    push()
    pan.scale(scale, scale)
    la.trim.add(LogoHalf, 0.0, easel(0.0, 1.0, 0.0, 2.5, quinticInOut))
    pop()
  end
end

function drawLogo(dx, dy, scale, paint)
  if scale ~= 0 then
    begin()
    push()
    translate(width / 2, height / 2)
    translate(dx, dy)
    pan.scale(scale, scale)
    addLogo()
    pop()
    stroke(paint)
  end
end

function drawName(dx, dy, paint)
  local tw, th = pan.textSize(LogoFont, LogoName, LogoTextSize)
  push()
  translate(width / 2, height / 2)
  translate(0, LogoSize / 2 + 48)
  translate(dx, dy)
  begin()
  if time < 3 then
    cliprect(-tw / 2, 0, tw, th + 12, la.paints.text)
  end
  la.text.perchar(
    LogoFont, 0, 0, LogoName, LogoTextSize,
    function (add, index)
      local t = 1 + (index - 1) * 0.1
      add(0, keyframes {
        { time = t,        val = 72 },
        { time = t + 1.0,  val = 0,   easing = quarticOut },
        { time = t + 1.75, val = 0 },
        { time = t + 2.75, val = height / 2, easing = quinticIn },
      })
    end,
    0, 0, taCenter, taTop
  )
  fill(paint)
  pop()
end

function render()
  clear(la.paints.background)

  local logoScale = keyframes {
    { time = 0.0, val = 0.0 },
    { time = 1.5, val = 1.0, easing = quarticOut },
    { time = 2.5, val = 1.0 },
    { time = 4.0, val = 0.0, easing = quarticIn },
  }
  drawLogo(32, 32, logoScale, la.paints.purple)
  drawLogo(16, 16, logoScale, la.paints.neonPink)
  drawLogo(0, 0, logoScale, la.paints.text)
  drawName(12, 12, la.paints.neonPink)
  drawName(0, 0, la.paints.text)
end
