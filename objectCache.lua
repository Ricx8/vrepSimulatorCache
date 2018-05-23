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
    listOfjoints = {"backLLeg_Joint01", "backLLeg_Joint02", "backLLeg_Joint03"}
    invList = {true, false, true}
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
      local joint = sim.getJointPosition(handleList[count])
      outLine = outLine..";"..joint
    end

    --io.write(currentTime .. ";" .. jointAngle .. "\n")
    io.write(outLine.."\n")
end

function sysCall_cleanup()
    -- do some clean-up here
    io.close(outFile)

    previousData = {}
    for i=1, #listOfjoints+1, 1 do
      previousData[i] = 0
    end


    outFile = io.open(fileName, "r")
    cacheFile = io.open(fileName:gsub(".txt", ".cache"), "w")
    io.output(cacheFile)

    for line in outFile:lines() do
      local tmp = split(line, ";")
      local outLine = tmp[1] - previousData[1]

      for count=2, #tmp, 1 do
        local angle = 0
        if (invList[count-1]) then
          angle = invAngle(math.floor(math.deg(previousData[count] + 3) + 8.14))
        else
          angle = math.floor(math.deg(previousData[count] + 3) + 8.14)
        end

        outLine = outLine..";"..angle
      end

      io.write(outLine .. "\n")

      previousData = tmp
    end

    io.close(outFile)
    io.close(cacheFile)
end

-- You can define additional system calls here:
--[[
function sysCall_suspend()
end

function sysCall_resume()
end

function sysCall_dynCallback(inData)
end

function sysCall_jointCallback(inData)
    return outData
end

function sysCall_contactCallback(inData)
    return outData
end

function sysCall_beforeCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be copied")
    end
end

function sysCall_afterCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was copied")
    end
end

function sysCall_beforeDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be deleted")
    end
    -- inData.allObjects indicates if all objects in the scene will be deleted
end

function sysCall_afterDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was deleted")
    end
    -- inData.allObjects indicates if all objects in the scene were deleted
end
--]]
