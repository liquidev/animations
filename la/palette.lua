-- la.palette - shared palette for all of my videos

do

  -- indexed colors
  local palette = {
    -- generated with coolors.co
    pan.hex"#1C0785",
    pan.hex"#3A0CA3",
    pan.hex"#7209B7",
    pan.hex"#F72585",
    pan.hex"#00C3FF",
    pan.hex"#00FFFF",
    pan.hex"#00FA9A",
    pan.hex"#FAFA37",
    pan.hex"#FFFFFF",
  }

  -- named colors

  palette.transparent = pan.rgba(0, 0, 0, 0)

  palette.darkBackground = palette[1]
  palette.background = palette[2]
  palette.lightBackground = palette[3]
  palette.neonPink = palette[4]
  palette.blue = palette[5]
  palette.neonBlue = palette[6]
  palette.teal = palette[7]
  palette.neonYellow = palette[8]
  palette.white = palette[9]

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
