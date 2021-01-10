animation { width = 1920, height = 1080, framerate = 60, length = 5 }

local la = {
  text = pan.require("la.text"),
  fonts = pan.require("la.fonts"),
}

local colors = {
  white = hex"#FFFFFF",
  black = hex"#000000AA",
}
local paints = {}
for name, value in pairs(colors) do
  paints[name] = solid(value)
end

local pretitle, title = "Part 1", "Creating a vector graphics context"

function render()
  clear(paints.white)

  begin()
  la.text.slideout(
    0, 1, 0.075,
    la.fonts.regular, 64, height / 2 - 48, pretitle, 56, colors.black,
    0, 0, taLeft, taBottom
  )
  la.text.slideout(
    1, 1, 0.05,
    la.fonts.bold, 64, height / 2, title, 72, colors.black,
    0, 0, taLeft, taMiddle
  )

  local fadeOut = easel(0, 255, 3.5, 1, quinticIn)
  rectf(0, 0, width, height, solid(rgba(255, 255, 255, fadeOut)))
end
