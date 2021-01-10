animation { width = 1920, height = 1080, framerate = 60, length = 4.5 }

local la = {
  time = pan.require("la.time"),
  fonts = pan.require("la.fonts"),
  text = pan.require("la.text"),
}

local paints = {
  white  = solid(hex"#FFFFFF"),
  red    = solid(hex"#FF6F6F"),
  orange = solid(hex"#FFB574"),
  gold   = solid(hex"#FFDD75"),
  black  = solid(hex"#000000AA"),
}

function drawL()

  push()
  rotate(easel(0, math.pi / 4 + math.pi * 2, 0, 2.0, quinticOut))

  begin()
  arc(0, 0, easel(0, 40, 0, 2, quinticOut), 0, math.pi)
  fill(paints.orange)

  pop()

end

function drawQ()

  begin()
  local startAngle, endAngle =
    easel(math.pi / 2, 0, 0, 2, quinticOut),
    easel(math.pi / 2, math.pi, 0, 2, quinticOut)
  arc(0, 0, 32, startAngle, endAngle)
  stroke(paints.red:lineWidth(32))

  rectf(0, 16, easel(0, 48, 0.11, 2, quinticOut), 32, paints.red)

end

function drawD()

  local function bullet(dx, dy)
    push()
    translate(dx, dy)
    arc(0, 0, 26, 3 / 2 * math.pi, math.pi / 2)
    rect(-16, -26, 16, 52)
    pop()
  end

  push()
  translate(14, 0)

  begin()
  bullet(easel(-44, 0, 0, 2, quinticOut), 0)
  clip()

  begin()
  bullet(0, 0)
  fill(paints.gold)

  pop()

end

function drawText()

  begin()
  if time < 3 then
    cliprect(-32, 56, 64, 20)
  end
  la.text.perchar(
    la.fonts.regular, 0, 56, "lqdev", 16,
    function (add, index)
      local t = 1 + (index - 1) * 0.1
      add(0, keyframes {
        { time = t,     val = 20 },
        { time = t + 1, val = 0,   easing = quarticOut },
      })
    end,
    0, 0, taCenter, taTop
  )
  fill(paints.black)

end

function render()
  clear(paints.white)

  push()
  translate(width / 2, height / 2 - 48)
  scale(4, 4)

  la.time.at(1.0, drawD)
  la.time.at(0.0, drawL)
  la.time.at(0.5, drawQ)
  drawText()

  pop()

  local fadeOpacity = easel(0, 255, 3, 1, quinticIn)
  rectf(0, 0, width, height, solid(rgba(255, 255, 255, fadeOpacity)))
end
