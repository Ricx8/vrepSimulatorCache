function split(str, character)
  result = {}

  index = 1
  for s in string.gmatch(str, "[^"..character.."]+") do
    result[index] = s
    index = index + 1
  end

  return result
end

function sysCall_init()
    -- do some initialization here:

    -- Make sure you read the section on "Accessing general-type objects programmatically"
    -- For instance, if you wish to retrieve the handle of a scene object, use following instruction:
    --
    -- handle=sim.getObjectHandle('sceneObjectName')
    --
    -- Above instruction retrieves the handle of 'sceneObjectName' if this script's name has no '#' in it
    --
    -- If this script's name contains a '#' (e.g. 'someName#4'), then above instruction retrieves the handle of object 'sceneObjectName#4'
    -- This mechanism of handle retrieval is very convenient, since you don't need to adjust any code when a model is duplicated!
    -- So if the script's name (or rather the name of the object associated with this script) is:
    --
    -- 'someName', then the handle of 'sceneObjectName' is retrieved
    -- 'someName#0', then the handle of 'sceneObjectName#0' is retrieved
    -- 'someName#1', then the handle of 'sceneObjectName#1' is retrieved
    -- ...
    --
    -- If you always want to retrieve the same object's handle, no matter what, specify its full name, including a '#':
    --
    -- handle=sim.getObjectHandle('sceneObjectName#') always retrieves the handle of object 'sceneObjectName'
    -- handle=sim.getObjectHandle('sceneObjectName#0') always retrieves the handle of object 'sceneObjectName#0'
    -- handle=sim.getObjectHandle('sceneObjectName#1') always retrieves the handle of object 'sceneObjectName#1'
    -- ...
    --
    -- Refer also to sim.getCollisionhandle, sim.getDistanceHandle, sim.getIkGroupHandle, etc.

    fileName = "cacheSimulation.txt"
    oldTime = 0

    -- Open open a file in write mode
    outFile = io.open(fileName, "w")
    io.output(outFile)
    --io.write("INIT\n")

    -- Get joints handles
    handle = sim.getObjectHandle("backLLeg_Joint01")
    --io.write(handle .. "\n")
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

    -- Get joints angles
    jointAngle = sim.getJointPosition(handle)

    io.write(currentTime .. ";" .. jointAngle .. "\n")
end

function sysCall_cleanup()
    -- do some clean-up here
    io.close(outFile)

    previousData = {0, 0, 0}
    outFile = io.open(fileName, "r")
    cacheFile = io.open(fileName:gsub(".txt", ".cache"), "w")
    io.output(cacheFile)

    for line in outFile:lines() do
      local tmp = split(line, ";")
      subTime = tmp[1] - previousData[1]

      io.write(subTime .. ";" .. previousData[2] .. "\n")

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
