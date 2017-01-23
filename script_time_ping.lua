commandArray = {}
local devicesToPing = {}

--devicesToPing['FrankZZ'] = '192.168.1.75'
devicesToPing['ChromecastMalissa'] = '192.168.1.65'
--devicesToPing['TabletHarrie'] = '192.168.1.67'
--devicesToPing['TelefoonAnnemiek'] = '192.168.1.66'
--devicesToPing['TelefoonHarrie'] = '192.168.1.77'
--devicesToPing['ComputerBeneden'] = '192.168.1.22'

for name,ip in pairs(devicesToPing) do

    --ping_success=os.execute('sudo arping -q -c1 -W 1 ' .. ip .. '>/dev/null')
    ping_success=os.execute('ping -w2 -c1 ' .. ip .. '>/dev/null')
    if (ping_success) then
        if (uservariables[name .. 'gone'] > 0) then
            table.insert(commandArray, {['Variable:' .. name .. 'gone'] = '0'})
        end
        if (otherdevices[name] == 'Off') then
            print(name .. ' sighted')
            table.insert(commandArray, {[name] = 'On'})
        end
    elseif (otherdevices[name] == 'On') then
        print(name .. ' gone')
        if (uservariables[name .. 'gone'] == 3) then
            table.insert(commandArray, {[name] = 'Off'})
        else
            table.insert(commandArray, {['Variable:' .. name .. 'gone'] = tostring(uservariables[name .. 'gone'] + 1) })
        end
    end
end
return commandArray
