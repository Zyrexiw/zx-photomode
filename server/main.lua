RegisterCommand('photomode', function(source, args, rawCommand)
    if source > 0 then
        TriggerClientEvent('photomode:toggle', source)
    end
end, Config.RequireAdmin)

RegisterNetEvent('photomode:requestToggle')
AddEventHandler('photomode:requestToggle', function()
    local src = source
    if src > 0 then
        if Config.RequireAdmin and not IsPlayerAceAllowed(tostring(src), 'command.photomode') then return end
        TriggerClientEvent('photomode:toggle', src)
    end
end)

RegisterNetEvent('photomode:notifyState')
AddEventHandler('photomode:notifyState', function(active)
    local src = source
    if src > 0 then
        TriggerClientEvent('photomode:setPlayerState', -1, src, active and true or false)
    end
end)