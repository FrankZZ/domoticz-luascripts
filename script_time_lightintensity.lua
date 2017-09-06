time = os.date("*t")
minutesnow = time.min + time.hour * 60
sunset = minutesnow > timeofday['SunsetInMinutes'] - 30
sunrising = minutesnow < timeofday['SunriseInMinutes'] + 120
--sunset = true
night = sunset or timeofday['Nighttime'] or sunrising
sleeptime = time.hour >= 22 or time.hour <= 5

sUV, sSolar = otherdevices_svalues['UVWeerstation']:match("([^;]+);([^;]+)")
sunisdark = tonumber(sUV) < uservariables['minSunlight']

--sleeptime = true

commandArray = {}
for deviceName,deviceValue in pairs(otherdevices) do
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    name = deviceName:sub(5)
    if (type == 'PIR' and id == '0') then
        if(otherdevices[name .. 'Force' == 'On']) then
            print ('[' .. name .. '] Is forced on, not doing anything...')
        else
            if (deviceValue == 'On' and otherdevices[name] == 'Off') then
                if (sleeptime and otherdevices['Group:' .. name .. 'Regular'] == 'On') then
                    print ('[' .. name .. '] It\'s sleeptime and light was on Regular, change to dim')

                    table.insert(commandArray, {['Group:' .. name .. 'Regular'] = 'Off' })
                    table.insert(commandArray, {['Group:' .. name .. 'Dim'] = 'On'})
                elseif (otherdevices['Group:' .. name .. 'Dim'] == 'On' and not sleeptime) then
                    print ('[' .. name .. '] Sleeptime ended and light was dim, change to Regular')

                    table.insert(commandArray, {['Group:' .. name .. 'Dim'] = 'Off'})
                    table.insert(commandArray, {['Group:' .. name .. 'Regular'] = 'On'})
                end
            end
        end
    end
end

return commandArray
