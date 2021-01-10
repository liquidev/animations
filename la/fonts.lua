-- la.fonts - common fonts

do

  local fontFamily = "Roboto Mono"

  local fonts = {
    regular = pan.font(fontFamily),
    bold = pan.font(fontFamily, pan.fwBold),
    italic = pan.font(fontFamily, pan.fwNormal, pan.fsItalic),
    boldItalic = pan.font(fontFamily, pan.fwBold, pan.fwItalic),
  }

  print("la.fonts module loaded")
  return fonts

end
