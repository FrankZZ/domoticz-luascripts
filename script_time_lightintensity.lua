time = os.date("*t")
minutesnow = time.min + time.hour * 60
sunset = minutesnow > timeofday['SunsetInMinutes'] - 30
sunrising = minutesnow < timeofday['SunriseInMinutes'] + 120
--sunset = true
night = sunset or timeofday['Nighttime'] or sunrising
sleeptime = time.hour >= uservariables['sleepTimeStartHour'] or time.hour < uservariables['sleepTimeStopHour']

sUV, sSolar = otherdevices_svalues['UVWeerstation']:match("([^;]+);([^;]+)")
sunisdark = tonumber(sUV) < uservariables['minSunlight']

--sleeptime = true

-- function LogVariables(x,depth,name)
--     for k,v in pairs(x) do
--         if (depth>0) or ((string.find(k,'device')~=nil) or (string.find(k,'variable')~=nil) or
--                          (string.sub(k,1,4)=='time') or (string.sub(k,1,8)=='security')) then
--             if type(v)=="string" then print(name.."['"..k.."'] = '"..v.."'") end
--             if type(v)=="number" then print(name.."['"..k.."'] = "..v) end
--             if type(v)=="boolean" then print(name.."['"..k.."'] = "..tostring(v)) end
--             if type(v)=="table" then LogVariables(v,depth+1,k); end
--         end
--     end
-- end
-- -- call with this command
-- LogVariables(_G,0,'');

commandArray = {}
for deviceName,deviceValue in pairs(otherdevices) do
    type = deviceName:sub(0,3)
    id = deviceName:sub(4,4)
    name = deviceName:sub(5)
    if (type == 'PIR' and id == '0') then
        print ('lightintensity: ' .. name .. ': ' .. tostring(otherdevices[name]) .. '. sleeptime: ' .. tostring(sleeptime) .. ' ' .. name .. 'Dim: ' .. tostring(otherdevices_scenesgroups[name .. 'Dim']) .. ' ' .. name .. 'Regular: ' .. tostring(otherdevices_scenesgroups[name .. 'Regular']) .. ' Force: ' .. tostring(otherdevices[name .. 'Force']))
        if(tostring(otherdevices[name .. 'Force']) == 'On') then
            print ('[' .. name .. '] Is forced on, not doing anything...')
        else
            if (otherdevices[name] ~= 'Off') then
                if (sleeptime and otherdevices_scenesgroups[name .. 'Regular'] == 'On') then
                    print ('[' .. name .. '] It\'s sleeptime and light was on Regular, change to dim')

                    table.insert(commandArray, {['Group:' .. name .. 'Regular'] = 'Off' })
                    table.insert(commandArray, {['Group:' .. name .. 'Dim'] = 'On'})
                elseif (otherdevices_scenesgroups[name .. 'Dim'] == 'On' and not sleeptime) then
                    print ('[' .. name .. '] Sleeptime ended and light was dim, change to Regular')

                    table.insert(commandArray, {['Group:' .. name .. 'Dim'] = 'Off'})
                    table.insert(commandArray, {['Group:' .. name .. 'Regular'] = 'On'})
                end
            end
        end
    end
end

return commandArray
