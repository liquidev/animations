-- la.text - text animating utilities

do

  local text = {}

  -- Adds text character by character.
  -- fn is a function that takes the params (add, index, char), where
  -- add is a function that takes (dx, dy) and adds the next character to the
  -- path, index is the index of the currently rendered character, char is the
  -- UTF-8 encoded character.
  --
  -- Example:
  -- text.chars(font, 32, 32, "hello la.text", 16, function (add, index, char)
  --   local offset = math.sin(pan.time + index / 10)
  --   add(0, offset)
  -- end)
  function text.perchar(font, x, y, text, size, fn, w, h, halign, valign)
    local charX, baseline

    local tw, th = pan.textSize(font, text, size)

    if halign == nil then halign = taLeft end

    if halign == taLeft then charX = x
    elseif halign == taCenter then charX = x + w / 2 - tw / 2
    elseif halign == taRight then charX = x + w - tw
    end

    pan.pushPath()
    pan.begin()
    pan.text(
      font, x, y, text, size,
      w, h, halign, valign
    )
    _, baseline = pan.pathCursor()
    pan.popPath()

    local index = 1
    for _, codepoint in utf8.codes(text) do

      local char = utf8.char(codepoint)
      local add = function (dx, dy)
        if dx == nil then dx = 0 end
        if dy == nil then dy = 0 end
        pan.moveTo(charX + dx, baseline + dy)
        pan.addText(font, char, size)
        charX, _ = pan.pathCursor()
      end
      fn(add, index, char)

      index = index + 1

    end
  end
  
  print("la.text module loaded")
  return text

end
