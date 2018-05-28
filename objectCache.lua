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

  if (result < 0) then
    result = result * -1
  end

  return result
end

function sysCall_init()
    -- do some initialization here:

    fileName = "cacheSimulation.txt"
    listOfjoints = {"backRLeg_Joint01", "backRLeg_Joint02", "backRLeg_Joint03", "backLLeg_Joint01", "backLLeg_Joint02", "backLLeg_Joint03", "frontRLeg_Joint01", "frontRLeg_Joint02", "frontRLeg_Joint03", "frontLLeg_Joint01", "frontLLeg_Joint02", "frontLLeg_Joint03"}

    -- backRLeg= inv:txx, off:xxx; backLLeg= inv:fxt, off: txf; frontRLeg= inv:txx, off:xxx; frontLeftLeg= inv: fxt, off:txf
    --           {            BR          }{         BL        }{          FR        }{         FL         }
    invList    = {false,    false,  true,  false,  false,  true, true,   false,  true, false,  false,  true}
    offsetList = {100,      0,      0,      100,    0,      0,    100,    0,      0,      100,    0,      0}
    handleList = {}

    -- Open open a file in write mode
    outFile = io.open(fileName, "w")
    io.output(outFile)
    --io.write("INIT\n")

    -- Get joints handles
    for count=1, #listOfjoints, 1 do
      handleList[count] = sim.getObjectHandle(listOfjoints[count])
    end
    --handle = sim.getObjectHandle("backLLeg_Joint01")
end

function sysCall_actuation()
    -- put your actuation code here
    --
    -- For example:
    --
    -- local position=sim.getObjectPosition(handle,-1)
    -- position[1]=position[1]+0.001
    -- sim.setObjectPosition(handle,-1,position)
end

function sysCall_sensing()
    -- put your sensing code here
    currentTime = sim.getSimulationTime() -- Get current simulation time
    local outLine = currentTime

    -- Get joints angles
    --jointAngle = sim.getJointPosition(handle)
    for count=1, #listOfjoints, 1 do
      -- local joint = math.floor(math.deg(sim.getJointPosition(handleList[count]) + 3) + 8.14)
      local joint = sim.getJointPosition(handleList[count])
      outLine = outLine..";"..joint
    end

    --io.write(currentTime .. ";" .. jointAngle .. "\n")
    io.write(outLine.."\n")
end

function sysCall_cleanup()
    -- do some clean-up here
    io.close(outFile)

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
end
