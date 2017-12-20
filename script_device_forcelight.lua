commandArray = {}
for deviceName,deviceValue in pairs(devicechanged) do
    type = deviceName:sub(-5)
    name = deviceName:sub(1,-6)
    
    if (type == 'Force') then
        if(deviceValue == 'On') then
            print ('[' .. name .. '] Forcing on...')
            commandArray['Group:' .. name .. 'Regular'] = 'On'
        elseif(deviceValue == 'Off') then
            print ('[' .. name .. '] Forcing off...')
            commandArray['Group:' .. name .. 'Regular'] = 'Off'
        end
    elseif (type == 'Buttn' and deviceValue == 'On') then
        if(otherdevices[name .. 'Force'] == 'Off') then
            print ('[' .. name .. '] Button press, Forcing on...')
            commandArray[name .. 'Force'] = 'On'
        else
            print ('[' .. name .. '] Button pressed again, Forcing off...')
            commandArray[name .. 'Force'] = 'Off'
        end
    end
end

return commandArray
