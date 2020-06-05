-- la.trim - trim paths module for pan

do

  local trim = {}

  -- Prepares the given list of points for trimming.
  -- This computes individual segments, and their lengths.
  function trim.prepare(path)

    if #path == 0 then error("path must have at least 1 point") end

    path.segments = {}

    -- find the segments
    local totalLen = 0.0
    for index = 2, #path do
      local a, b = path[index - 1], path[index]
      local segment = { a = a, b = b }
      local dx = b.x - a.x
      local dy = b.y - a.y
      segment.len = math.sqrt(dx * dx + dy * dy)
      totalLen = totalLen + segment.len
      table.insert(path.segments, segment)
    end

    -- normalize the segments' lengths
    for _, segment in ipairs(path.segments) do
      segment.normLen = segment.len / totalLen
    end

    -- mark the start/end of each segment
    local percent = 0.0
    for _, segment in ipairs(path.segments) do
      segment.pstart = percent
      percent = percent + segment.normLen
      segment.pend = percent
    end

    path.preparedForTrimming = true

  end

  -- Draws the given path, trimmed between pstart and pend.
  -- pstart and pend have to be numbers between 0 and 1, if they exceed that
  -- range, they are clamped.
  function trim.add(path, pstart, pend)

    if not path.preparedForTrimming then
      error("path is not prepared for trimming, use trim.prepare() on it")
    end

    -- failsafe for dumb people (like me)
    if pstart > pend then
      pstart, pend = pend, pstart
    end
    pstart = pan.clamp(pstart, 0.0, pend)
    pend = pan.clamp(pend, pstart, 1.0)

    -- find the indices of the first and last path
    local indexFirst, indexLast = 0, 0

    for index = 1, #path.segments do
      local segment = path.segments[index]
      if segment.pstart - 0.0001 <= pstart then
        indexFirst = index
      else
        break
      end
    end

    for index = #path.segments, 1, -1 do
      local segment = path.segments[index]
      if segment.pend + 0.0001 >= pend then
        indexLast = index
      else
        break
      end
    end

    -- draw the path
    for index = indexFirst, indexLast do
      local segment = path.segments[index]
      local ax, ay, bx, by = segment.a.x, segment.a.y, segment.b.x, segment.b.y

      -- remap coordinates
      if index == indexFirst then
        local t = pan.map(pstart, segment.pstart, segment.pend, 0.0, 1.0)
        ax = pan.interp(ax, segment.b.x, t)
        ay = pan.interp(ay, segment.b.y, t)
      end
      if index == indexLast then
        local t = 1.0 - pan.map(pend, segment.pstart, segment.pend, 0.0, 1.0)
        bx = pan.interp(bx, segment.a.x, t)
        by = pan.interp(by, segment.a.y, t)
      end

      -- add line to path
      if index == indexFirst then
        moveTo(ax, ay)
      end
      lineTo(bx, by)
    end

  end

  print("la.trim module loaded")
  return trim

end
