local nuiOpen   = false
local uiVisible = true

-- Table des joueurs (serverId) actuellement en mode caméra, hors soi-même
local playersInCam = {}


local controlIdToName = {
    ["0"]   = "V",      ["20"]  = "Z",      ["26"]  = "C",      ["29"]  = "B",
    ["30"]  = "D",      ["32"]  = "W",      ["33"]  = "S",      ["34"]  = "A",
    ["44"]  = "Q",      ["45"]  = "R",      ["46"]  = "E",      ["47"]  = "G",
    ["49"]  = "F",      ["73"]  = "X",      ["74"]  = "H",      ["182"] = "L",
    ["244"] = "M",      ["245"] = "T",      ["246"] = "Y",      ["249"] = "N",
    ["303"] = "U",      ["311"] = "K",

    ["19"]  = "LAlt",   ["21"]  = "LShift", ["36"]  = "LCtrl",
    ["22"]  = "Espace", ["37"]  = "Tab",    ["137"] = "Caps",
    ["18"]  = "Entrée", ["201"] = "Entrée",
    ["177"] = "Retour", ["178"] = "Suppr",  ["214"] = "Suppr",
    ["199"] = "P",
    ["200"] = "Échap",  ["322"] = "Échap",

    ["172"] = "↑",      ["173"] = "↓",      ["174"] = "←",      ["175"] = "→",

    ["10"]  = "PgUp",   ["11"]  = "PgDn",
    ["213"] = "Home",
    ["316"] = "PgUp",   ["317"] = "PgDn",

    ["39"]  = "[",      ["40"]  = "]",
    ["81"]  = ".",      ["82"]  = ",",
    ["83"]  = "=",      ["84"]  = "-",
    ["243"] = "~",

    ["157"] = "1",      ["158"] = "2",      ["160"] = "3",      ["164"] = "4",
    ["165"] = "5",      ["159"] = "6",      ["161"] = "7",      ["162"] = "8",
    ["163"] = "9",

    ["288"] = "F1",     ["289"] = "F2",     ["170"] = "F3",
    ["166"] = "F5",     ["167"] = "F6",     ["168"] = "F7",     ["169"] = "F8",
    ["56"]  = "F9",     ["57"]  = "F10",    ["344"] = "F11",

    ["107"] = "Num6",   ["108"] = "Num4",   ["117"] = "Num7",   ["118"] = "Num9",
    ["314"] = "Num+",   ["315"] = "Num-",
}

local function sendNui(data)
    SendNUIMessage(data)
end

local function openDurationModal()
    SetNuiFocus(true, true)
    nuiOpen = true
    sendNui({ action = 'openDuration' })
end

local function getKeyNameForCommand(commandName)
    local bindString = GetControlInstructionalButton(2, GetHashKey(commandName) | 0x80000000, true)
    if bindString and type(bindString) == 'string' and string.len(bindString) > 2 then
        local keyName = string.sub(bindString, 3)
        if keyName ~= 'NONE' then
            if controlIdToName[keyName] then
                keyName = controlIdToName[keyName]
            end
            return keyName
        end
    end
    return nil
end

AddEventHandler('photomode:onFreecamStart', function()
    uiVisible = true
    
    local dynamicKeys = {}
    for k, v in pairs(Config.Keys) do dynamicKeys[k] = v end
    
    local quitKey = getKeyNameForCommand('photomode')
    if quitKey then dynamicKeys.Quit = quitKey end

    local dofKey = getKeyNameForCommand('photomode_dof')
    if dofKey then dynamicKeys.Dof = dofKey end

    local clearKey = getKeyNameForCommand('photomode_cleartransitions')
    if clearKey then dynamicKeys.ClearPoints = clearKey end

    sendNui({ action = 'setFilters', filters = Config.Filters })
    sendNui({ action = 'setKeys', keys = dynamicKeys })
    sendNui({ action = 'showUI' })
end)

AddEventHandler('photomode:onFreecamStop', function()
    sendNui({ action = 'hideUI' })
    SetNuiFocus(false, false)
    nuiOpen   = false
    uiVisible = true
end)

RegisterNetEvent('photomode:setPlayerState')
AddEventHandler('photomode:setPlayerState', function(serverId, active)
    local ownServerId = GetPlayerServerId(PlayerId())
    if serverId == ownServerId then return end

    if active then
        playersInCam[serverId] = true
    else
        playersInCam[serverId] = nil
    end
end)

AddEventHandler('photomode:onPointSet', function(label)
    if label == 'reset' then
        sendNui({ action = 'resetPoints' })
    else
        sendNui({ action = 'pointSet', point = label })
    end
end)

AddEventHandler('photomode:onTransitionStart', function(duration)
    sendNui({ action = 'transitionStart', duration = duration })
end)

AddEventHandler('photomode:onSegmentAdded', function(segCount)
    sendNui({ action = 'segmentAdded', segmentCount = segCount })
    SetNuiFocus(false, false)
    nuiOpen = false
end)

AddEventHandler('photomode:onSegmentStart', function(idx, total, duration)
    sendNui({ action = 'segmentStart', index = idx, total = total, duration = duration })
end)

AddEventHandler('photomode:openDuration', function()
    openDurationModal()
end)

RegisterNUICallback('setDuration', function(data, cb)
    local ms = tonumber(data.duration) or Config.TransitionDefaultTime
    ms = math.max(500, math.min(ms, 60000))
    cb({})
    if data.addMore then
        TriggerEvent('photomode:addSegmentAndContinue', ms)
    else
        TriggerEvent('photomode:launchChain', ms)
    end
end)

RegisterNUICallback('closeDurationModal', function(data, cb)
    SetNuiFocus(false, false)
    nuiOpen = false
    cb({})
    if not data.confirmed then
        TriggerEvent('photomode:cancelTransition')
    end
end)

RegisterNUICallback('updateEffects', function(data, cb)
    local enabled  = data.enabled
    local strength = tonumber(data.strength) or 1.0
    local near     = tonumber(data.near)     or 2.0
    local far      = tonumber(data.far)      or 5.0
    local filterEnabled = data.filterEnabled
    local filter   = data.filter
    local filterStrength = tonumber(data.filterStrength) or 1.0
    local shakeEnabled = data.shakeEnabled
    local shakeStrength = tonumber(data.shakeStrength) or 0.5
    exports['zx_photomode']:setEffects(enabled, strength, near, far, filterEnabled, filter, filterStrength, shakeEnabled, shakeStrength)
    cb({})
end)

RegisterNUICallback('openEffectsPanel', function(data, cb)
    SetNuiFocus(true, true)
    nuiOpen = true
    local state = exports['zx_photomode']:getEffects()
    SendNUIMessage({ action = 'openEffectsPanel', effects = state })
    cb({})
end)

RegisterNUICallback('closeEffectsPanel', function(data, cb)
    SetNuiFocus(false, false)
    nuiOpen = false
    cb({})
end)

RegisterCommand('photomode_dof', function()
    if not exports['zx_photomode']:isFreecamActive() then return end
    if nuiOpen then
        SetNuiFocus(false, false)
        nuiOpen = false
        SendNUIMessage({ action = 'closeEffectsPanel' })
    else
        SetNuiFocus(true, true)
        nuiOpen = true
        local state = exports['zx_photomode']:getEffects()
        SendNUIMessage({ action = 'openEffectsPanel', effects = state })
    end
end, false)
RegisterKeyMapping('photomode_dof', 'Photo Mode: Profondeur de champ', 'keyboard', '')

RegisterCommand('photomode_ui', function()
    if not exports['zx_photomode']:isFreecamActive() then return end
    if not nuiOpen then
        uiVisible = not uiVisible
        sendNui({ action = uiVisible and 'showControls' or 'hideControls' })
    end
end, false)
RegisterKeyMapping('photomode_ui', 'Photo Mode: Cacher UI', 'keyboard', '')

CreateThread(function()
    while true do
        Wait(0)

        if not exports['zx_photomode']:isFreecamActive() then goto continue end
        local ped    = PlayerPedId()
        local origin = GetEntityCoords(ped)
        local camPos = exports['zx_photomode']:getFreecamPos()

        if camPos then
            local dist = #(origin - camPos)
            local fadeStartDist = Config.MaxDistance - 5.0
            if dist >= fadeStartDist then
                local alphaPct = math.min(1.0, (dist - fadeStartDist) / 5.0)
                local c = Config.MarkerColor
                DrawMarker(
                    28,
                    origin.x, origin.y, origin.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.MaxDistance * 2.0, Config.MaxDistance * 2.0, Config.MaxDistance * 2.0,
                    c.r, c.g, c.b, math.floor(c.a * alphaPct),
                    false, false, 2, false, nil, nil, false
                )
            end
        end

        ::continue::
    end
end)


CreateThread(function()
    while true do
        local sleep = 500 

        for serverId in pairs(playersInCam) do
            local targetPlayer = GetPlayerFromServerId(serverId)

            if targetPlayer == -1 then
                playersInCam[serverId] = nil
            else
                local targetPed = GetPlayerPed(targetPlayer)
                if targetPed ~= 0 and DoesEntityExist(targetPed) then
                    local headPos
                    local boneIndex = GetEntityBoneIndexByName(targetPed, 'IK_Head')
                    if boneIndex ~= -1 then
                        headPos = GetWorldPositionOfEntityBone(targetPed, boneIndex)
                    else
                        headPos = GetEntityCoords(targetPed) + vector3(0.0, 0.0, 1.0)
                    end

                    local dist = #(GetEntityCoords(PlayerPedId()) - headPos)
                    if dist < 15.0 then
                        sleep = 0 

                        local textPos = headPos + vector3(0.0, 0.0, 0.35)
                        SetTextScale(0.32, 0.32)
                        SetTextFont(4)
                        SetTextProportional(1)
                        SetTextColour(255, 255, 255, 215)
                        SetTextEdge(2, 0, 0, 0, 150)
                        SetTextDropShadow()
                        SetTextOutline()
                        SetTextEntry('STRING')
                        SetTextCentre(true)
                        AddTextComponentString('📷 En mode photo')
                        SetDrawOrigin(textPos.x, textPos.y, textPos.z, 0)
                        DrawText(0.0, 0.0)
                        ClearDrawOrigin()
                    end
                end
            end
        end

        Wait(sleep)
    end
end)