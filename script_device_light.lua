time = os.date("*t")
minutesnow = time.min + time.hour * 60
sunset = minutesnow > timeofday['SunsetInMinutes'] - 30
sunrising = minutesnow < timeofday['SunriseInMinutes'] + 60
--sunset = true
night = sunset or timeofday['Nighttime'] or sunrising
sleeptime = time.hour >= 0 and time.hour <= 5
--sleeptime = true

commandArray = {}
for deviceName,deviceValue in pairs(devicechanged) do
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    name = deviceName:sub(5)
    if (type == 'PIR') then
        print ('[' .. name .. '] ' .. deviceName .. ' changed to ' .. deviceValue .. ' Id: ' .. id .. ' Night: ' .. tostring(night) .. ' Sunset: ' .. tostring(sunset) .. ' ' .. name .. ': ' .. tostring(otherdevices[name]) .. ' - ' .. tostring(otherdevices_svalues[name]))
        if (deviceValue == 'On' and otherdevices[name] == 'Off') then
            if (sleeptime) then
                print ('[' .. name .. '] On dim')
                commandArray['Group:' .. name .. 'Dim'] = 'On'
            elseif (night) then
                print ('[' .. name .. '] On')
                commandArray['Group:' .. name .. 'Regular'] = 'On'
            end
        -- elseif (deviceValue == 'Off' and otherdevices[name] ~= 'Off') then
        --     allPIRsOff = true
        --     for pirName,pirValue in pairs(otherdevices) do
        --         if (pirName:sub(0,3) == 'PIR' and pirName:sub(5) == name and pirValue ~= 'Off') then
        --             allPIRsOff = false
        --         end
        --     end
        --     if (allPIRsOff == true) then
        --         print ('[' .. name .. '] All PIRs off, turning off lights')
        --         commandArray['Group:' .. name .. 'Regular'] = 'Off'
        --         commandArray['Group:' .. name .. 'Dim'] = 'Off'
        --     else
        --         print ('[' .. name .. '] Other PIR(s) not off, waiting...')
        --     end
        end
    end
end

return commandArray
