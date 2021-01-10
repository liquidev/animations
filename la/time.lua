-- Timings and stuff.

do

  local time = {
    at = function (time, callback)
      -- Delay `callback` by `time` seconds.
      -- Unlike `pan.warpTime`, this does not execute the callback
      -- if `pan.time` is less than `time`.
      if pan.time >= time then
        pan.warpTime(time, callback)
      end
    end
  }

  print("la.time module loaded")
  return time

end
