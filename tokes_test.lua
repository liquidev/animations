animation { width = 400, height = 400, length = 3, framerate = 60 }

local tokes = pan.require "la.tokes"

local cbg, cfg = hex"#000000", hex"#ffffff"
local bg, fg = solid(cbg), solid(cfg)

local text = tokes.new {
  font = pan.font("Iosevka Curly"), size = 32,
  color = cfg,
  { "Hello",   tag = "hello" },
  { " world!", tag = "world" }
}

function render()
  clear(bg)

  text:tint("world", 1, 2, hex"#00ff00")
  text:underline("hello", 1, 2)

  text:transitionIn(0, 0.25)
  text:transitionOut(2.5, 0.5)

  tokes.draw(text, 0, 0, width, height, taCenter, taMiddle)
end
