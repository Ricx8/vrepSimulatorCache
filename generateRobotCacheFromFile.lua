function split(str, character)
  result = {}

  index = 1
  for s in string.gmatch(str, "[^"..character.."]+") do
    result[index] = s
    index = index + 1
  end

  return result
end

function invAngle(a)
  local maxV = 180
  local result = maxV - a

  return result
end

fileName = "cacheSimulation.txt"

-- backRLeg= inv:txx, off:xxx; backLLeg= inv:fxt, off: txf; frontRLeg= inv:txx, off:xxx; frontLeftLeg= inv: fxt, off:txf
--           {            BR          }{         BL        }{          FR         }{         FL         }
invList    = {true,    false,  false,  false,  false,  true, true,   false,  false, false,  false,  true}
offsetList = {100,      0,      0,      100,    0,      0,    100,    0,      0,      100,    0,      0}
handleList = {}



outFile = io.open(fileName, "r")
cacheFile = io.open(fileName:gsub(".txt", ".cache"), "w")
io.output(cacheFile)

for line in outFile:lines() do
  local tmp = split(line, ";")
  local outLine = tmp[1]

  for count=2, #tmp, 1 do
    local angle = 0

    angle = math.floor(math.deg(tmp[count] + 3) + 8.14) - offsetList[count-1]

    if (invList[count-1]) then
      angle = invAngle(angle)
    end

    outLine = outLine..";"..angle
  end

  io.write(outLine.."\n")
end

io.close(outFile)
io.close(cacheFile)
