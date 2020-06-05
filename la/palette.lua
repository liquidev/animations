-- la.palette - shared palette for all of my videos

do

  -- indexed colors
  local palette = {
    -- generated with coolors.co
    pan.hex"#F72585",  -- Flickr Pink
    pan.hex"#7209B7",  -- Purple
    pan.hex"#3A0CA3",  -- Trypan Blue
    pan.hex"#4361EE",  -- Ultramarine Blue
    pan.hex"#00FFFF",  -- Aqua
    pan.hex"#00FA9A",  -- Medium Spring Green
    pan.hex"#FAFA37",  -- Maximum Yellow
    pan.hex"#FFFFFF",  -- White
  }

  -- named colors
  palette.transparent = pan.rgba(0, 0, 0, 0)
  palette.neonPink = palette[1]
  palette.purple = palette[2]
  palette.background = palette[3]
  palette.blue = palette[4]
  palette.neonBlue = palette[5]
  palette.teal = palette[6]
  palette.neonYellow = palette[7]
  palette.white = palette[8]

  palette.text = palette.white

  local paints = {}
  for key, value in pairs(palette) do
    paints[key] = pan.solid(value)
      :lineWidth(8)
      :lineCap(pan.lcRound)
      :lineJoin(pan.ljRound)
  end

  print("la.palette module loaded")
  return { palette, paints }

end
