commandArray = {}
for deviceName,deviceValue in pairs(devicechanged) do
    if (deviceName == 'Chromecast kijken') then
        commandArray['ChromecastHDMIExtractor'] = deviceValue
    end
end

return commandArray
