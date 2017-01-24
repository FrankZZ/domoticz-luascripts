timeon = 900
function timedifference(s)
    year = string.sub(s, 1, 4)
    month = string.sub(s, 6, 7)
    day = string.sub(s, 9, 10)
    hour = string.sub(s, 12, 13)
    minutes = string.sub(s, 15, 16)
    seconds = string.sub(s, 18, 19)
    t1 = os.time()
    t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
    difference = os.difftime (t1, t2)
    return difference
end

commandArray = {}
groupLastOff = {}

for i,deviceValue in pairs(otherdevices) do
    deviceName = tostring(i)
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    groupName = deviceName:sub(5)

    if (type == 'PIR') then
        if (otherdevices[groupName] ~= 'Off') then
            difference = timedifference(otherdevices_lastupdate[deviceName])
            print ('[' .. groupName .. '] PIR ' .. id .. ' is off for ' .. difference .. ' seconds. Treshold: ' .. timeon)
            if (groupLastOff[groupName] == nil or difference < groupLastOff[groupName]) then
                groupLastOff[groupName] = difference
            end
        end
    end
end

for groupName,difference in pairs(groupLastOff) do
    if (difference > timeon) then
        print ('[' .. groupName .. '] All PIRs off for atleast ' .. timeon .. ' seconds, turning off lights')
        commandArray['Group:' .. groupName .. 'Regular'] = 'Off'
        commandArray['Group:' .. groupName .. 'Dim'] = 'Off'
    else
        print ('[' .. groupName .. '] Not all PIR(s) off for atleast ' .. timeon .. ', waiting...')
    end
end

return commandArray
