commandArray = {}
for deviceName,deviceValue in pairs(devicechanged) do
    type = deviceName:sub(-5)
    name = deviceName:sub(1,-5)
    if (type == 'Force') then
        if(otherdevices[name .. 'Force' == 'On']) then
            print ('[' .. name .. '] Forcing on...')
            commandArray['Group:' .. name .. 'Regular'] = 'On'
        elseif(otherdevices[name .. 'Force' == 'Off']) then
            print ('[' .. name .. '] Forcing off...')
            commandArray['Group:' .. name .. 'Regular'] = 'Off'
        end
    end
end

return commandArray
