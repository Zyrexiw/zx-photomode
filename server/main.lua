local function hasPermission(source)
    return IsPlayerAceAllowed(tostring(source), Config.AcePerms)
end

RegisterCommand('photomode', function(source, args, rawCommand)
    if source > 0 then
        local unlimitedRange = hasPermission(source)
        TriggerClientEvent('photomode:toggle', source, unlimitedRange)
    end
end, Config.RequireAdmin)

RegisterNetEvent('photomode:requestToggle')
AddEventHandler('photomode:requestToggle', function()
    local src = source
    if src > 0 then
        if Config.RequireAdmin and not IsPlayerAceAllowed(tostring(src), 'command.photomode') then return end

        local unlimitedRange = hasPermission(src)
        TriggerClientEvent('photomode:toggle', src, unlimitedRange)
    end
end)

RegisterNetEvent('photomode:notifyState')
AddEventHandler('photomode:notifyState', function(active)
    local src = source
    if src > 0 then
        TriggerClientEvent('photomode:setPlayerState', -1, src, active and true or false)
    end
end)

local CAM_DIST_TOLERANCE = 5.0

RegisterNetEvent('photomode:reportCamPos')
AddEventHandler('photomode:reportCamPos', function(camPos)
    local src = source
    if src <= 0 then return end

    if hasPermission(src) then return end

    if type(camPos) ~= 'vector3' then return end

    local ped = GetPlayerPed(src)
    if ped == 0 then return end

    local playerCoords = GetEntityCoords(ped)
    local dist = #(camPos - playerCoords)

    if dist > (Config.MaxDistance + CAM_DIST_TOLERANCE) then
        TriggerClientEvent('photomode:toggle', src, false)
        print(('[photomode] %s (id:%s) a dépassé la distance maximale en freecam (%.1f > %.1f) - freecam arrêté.')
            :format(GetPlayerName(src) or '?', src, dist, Config.MaxDistance))
    end
end)