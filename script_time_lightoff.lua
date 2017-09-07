timeon = uservariables['minTimeOn']
forcetimeout = uservariables['forceLightTimeout']

time = os.date("*t")
minutesnow = time.min + time.hour * 60
minHuiskamerTemp = uservariables['minHuiskamerTemp']
sunset = minutesnow > timeofday['SunsetInMinutes'] - 30
sunrising = minutesnow < timeofday['SunriseInMinutes'] + 90

sUV, sSolar = otherdevices_svalues['UVWeerstation']:match("([^;]+);([^;]+)")
sunisdark = tonumber(sUV) < uservariables['minSunlight']

--sunset = true
night = sunset or timeofday['Nighttime'] or sunrising
sleeptime = time.hour >= 0 and time.hour <= 5

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
                -- This PIR was not logged before with a lower lastupdate value. Put it in the table.
                -- So we can compare the PIR that was turned off last to the treshold.
                groupLastOff[groupName] = difference
            end
            -- Huiskamerlampen should stay on when someone's in the room. Let's check temperature for that
            if ((sunisdark == true or night == true) and sleeptime == false and groupName == 'Huiskamer') then
                print ('[' .. groupName .. '] Temperature is ' .. otherdevices['Huiskamertemperatuur'] .. ' Min treshold: ' .. minHuiskamerTemp)
                if (tonumber(otherdevices['Huiskamertemperatuur']) >= minHuiskamerTemp) then
                    groupLastOff[groupName] = nil
                end
            end
        end
    end
end

for groupName,difference in pairs(groupLastOff) do
    if (otherdevices[groupName .. 'Force'] == 'On') then
        print ('lastupdate force: ' .. timedifference(otherdevices_lastupdate[groupName .. 'Force']) .. ' time ' .. tostring(otherdevices_lastupdate[groupName .. 'Force']))
        if (timedifference(otherdevices_lastupdate[groupName .. 'Force']) > forcetimeout) then
            commandArray[groupName .. 'Force'] = 'Off'
            print ('[' .. groupName .. '] Forced on, turning off because of forceTimeout...')
        else
            print ('[' .. groupName .. '] Forced on, not turning off...')
        end
    -- Check all groups that the last PIR that was turned off is out of the treshold
    -- Note: Only groups that are currently on are in the table,
    -- we don't need to turn off a group that's already off ;-)
    elseif (difference > timeon) then
        print ('[' .. groupName .. '] All PIRs off for atleast ' .. timeon .. ' seconds, turning off lights')
        commandArray['Group:' .. groupName .. 'Regular'] = 'Off'
        commandArray['Group:' .. groupName .. 'Dim'] = 'Off'
    else
        print ('[' .. groupName .. '] Not all PIR(s) off for atleast ' .. timeon .. ', waiting...')
    end
end

return commandArray
