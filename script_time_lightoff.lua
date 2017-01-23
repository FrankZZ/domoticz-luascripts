timeon = 240
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
turn_off = {}

for i,deviceValue in pairs(otherdevices) do
    deviceName = tostring(i)
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    groupName = deviceName:sub(5)
    if (type == 'PIR') then
        difference = timedifference(otherdevices_lastupdate[deviceName])
        if (difference > timeon and difference < (timeon + 60) and turn_off[groupName] ~= false and otherdevices[groupName] ~= 'Off') then
            turn_off[groupName] = true
        else
            print ('[' .. groupName .. '] PIR ' .. id .. ' is off for ' .. difference .. ' seconds. Treshold: ' .. (timeon + 60))
            turn_off[groupName] = false
        end
    end
end

for groupName,turnOff in pairs(turn_off) do
    if (turnOff == true) then
        print ('[' .. groupName .. '] All PIRs off for atleast ' .. timeon .. ' seconds, turning off lights')
        commandArray['Group:' .. groupName .. 'Regular'] = 'Off'
        commandArray['Group:' .. groupName .. 'Dim'] = 'Off'
    else
        print ('[' .. groupName .. '] Not all PIR(s) off for atleast ' .. timeon .. ', waiting...')
    end
end

return commandArray