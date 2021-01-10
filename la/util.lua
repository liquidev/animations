-- la.util - various utilities


local util = {}


function util.copyColor(color)
  return pan.rgba(color.r * 255, color.g * 255, color.b * 255, color.a * 255)
end


function util.blendColors(a, b, t)
  local br = pan.interp(a.r, b.r, t) * 255
  local bg = pan.interp(a.g, b.g, t) * 255
  local bb = pan.interp(a.b, b.b, t) * 255
  local ba = pan.interp(a.a, b.a, t) * 255
  return rgba(br, bg, bb, ba)
end


function util.colorWithAlpha(color, alpha)
  return pan.rgba(color.r * 255, color.g * 255, color.b * 255, alpha)
end


return util
