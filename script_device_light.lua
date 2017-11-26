time = os.date("*t")
minutesnow = time.min + time.hour * 60
sunset = minutesnow > timeofday['SunsetInMinutes'] - 60
sunrising = minutesnow < timeofday['SunriseInMinutes'] + 120
--sunset = true
night = sunset or timeofday['Nighttime'] or sunrising
sleeptime = time.hour >= uservariables['sleepTimeStartHour'] or time.hour < uservariables['sleepTimeStopHour']

sUV, sSolar = otherdevices_svalues['UVWeerstation']:match("([^;]+);([^;]+)")
sUV2 = otherdevices_svalues['UV2Weerstation']
sunisdark = sUV2 < uservariables['minSunlight']

--sleeptime = true

commandArray = {}
for deviceName,deviceValue in pairs(devicechanged) do
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    name = deviceName:sub(5)
    if (type == 'PIR') then
        if(otherdevices[name .. 'Force' == 'On']) then
            print ('[' .. name .. '] Is forced on, not doing anything...')
        else
            print ('[' .. name .. '] ' .. deviceName .. ' changed to ' .. deviceValue .. ' Id: ' .. id .. ' SunisDark: ' .. tostring(sunisdark) .. ' Night: ' .. tostring(night) .. ' Sunset: ' .. tostring(sunset) .. ' ' .. name .. ': ' .. tostring(otherdevices[name]) .. ' - ' .. tostring(otherdevices_svalues[name]))
            if (deviceValue == 'On' and otherdevices[name] == 'Off') then
                if (sleeptime) then
                    print ('[' .. name .. '] On dim')
                    commandArray['Group:' .. name .. 'Dim'] = 'On'
                elseif (night or (sunisdark and (name ~= 'Huiskamer' or sUV2 == 0.0))) then
                    print ('[' .. name .. '] On')
                    commandArray['Group:' .. name .. 'Regular'] = 'On'
                end
            end
        end
    end
end

return commandArray
