local freecamActive   = false
local freecamCam      = nil
local playerOriginCoords = nil
local playerOriginHeading = nil
local fov             = Config.DefaultFov
local targetFov       = Config.DefaultFov

local waypoints        = {}    
local pendingSegments  = {}   
local transitionStep   = 0     
local inTransition     = false

local camPos      = vector3(0, 0, 0)
local camRot      = vector3(0, 0, 0)
local camVelocity = vector3(0.0, 0.0, 0.0)
local fovVelocity = 0.0

local dofEnabled  = false
local dofStrength = 1.0
local dofNear     = 2.0
local dofFar      = 5.0

local filterEnabled  = false
local filterName     = "none"
local filterStrength = 1.0

local shakeEnabled  = false
local shakeStrength = 0.5

local function applyEffects()
    if not freecamCam then return end
    
    if dofEnabled then
        SetUseHiDof()
        SetCamNearDof(freecamCam, dofNear)
        SetCamFarDof(freecamCam, dofFar)
        SetCamUseShallowDofMode(freecamCam, true)
        SetCamDofStrength(freecamCam, dofStrength)
        SetCamDofMaxNearInFocusDistanceBlendLevel(freecamCam, dofNear)
        SetCamDofMaxNearInFocusDistance(freecamCam, dofNear)
        SetCamDofFocusDistanceBias(freecamCam, dofFar)
    else
        SetCamUseShallowDofMode(freecamCam, false)
        SetCamDofStrength(freecamCam, 0.0)
    end
    
    if filterEnabled and filterName and filterName ~= "none" then
        SetTimecycleModifier(filterName)
        SetTimecycleModifierStrength(filterStrength)
    else
        ClearTimecycleModifier()
    end
    
    if shakeEnabled then
        if not IsCamShaking(freecamCam) then
            ShakeCam(freecamCam, "HAND_SHAKE", shakeStrength)
        else
            SetCamShakeAmplitude(freecamCam, shakeStrength)
        end
    else
        if IsCamShaking(freecamCam) then
            StopCamShaking(freecamCam, true)
        end
    end
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpVec3(a, b, t)
    return vector3(lerp(a.x, b.x, t), lerp(a.y, b.y, t), lerp(a.z, b.z, t))
end

local function easeInOut(t)
    return t * t * (3 - 2 * t)
end

local function destroyCam()
    if freecamCam and DoesCamExist(freecamCam) then
        DestroyCam(freecamCam, false)
        freecamCam = nil
    end
    RenderScriptCams(false, false, 0, true, true)
end

local function initFreecam()
    local ped = PlayerPedId()
    playerOriginCoords  = GetEntityCoords(ped)
    playerOriginHeading = GetEntityHeading(ped)

    camPos      = vector3(playerOriginCoords.x, playerOriginCoords.y, playerOriginCoords.z + 2.0)
    camRot      = vector3(-10.0, 0.0, playerOriginHeading)
    camVelocity = vector3(0.0, 0.0, 0.0)
    fovVelocity = 0.0
    fov         = Config.DefaultFov
    targetFov   = Config.DefaultFov

    freecamCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(freecamCam, camPos.x, camPos.y, camPos.z)
    SetCamRot(freecamCam, camRot.x, camRot.y, camRot.z, 2)
    SetCamFov(freecamCam, fov)
    SetCamActive(freecamCam, true)
    RenderScriptCams(true, false, 0, true, true)

    TriggerServerEvent('photomode:notifyState', true)
end

local function stopFreecam()
    if not freecamActive then return end
    freecamActive  = false
    inTransition   = false
    transitionStep = 0
    waypoints      = {}
    pendingSegments = {}
    fov            = Config.DefaultFov
    targetFov      = Config.DefaultFov
    camVelocity    = vector3(0.0, 0.0, 0.0)
    fovVelocity    = 0.0

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearTimecycleModifier()

    destroyCam()
    ExecuteCommand('togglehud')
    TriggerEvent('photomode:onFreecamStop')

    TriggerServerEvent('photomode:notifyState', false)
end

local function runSegment(seg, onDone)
    local startPos = seg.from.pos
    local startRot = seg.from.rot
    local startFov = seg.from.fov
    local startDof = seg.from.dof
    local endPos   = seg.to.pos
    local endRot   = seg.to.rot
    local endFov   = seg.to.fov
    local endDof   = seg.to.dof
    local duration = seg.duration
    local elapsed  = 0

    CreateThread(function()
        local prev = GetGameTimer()
        while inTransition and elapsed < duration do
            local now = GetGameTimer()
            elapsed   = elapsed + (now - prev)
            prev      = now
            local t   = easeInOut(math.min(elapsed / duration, 1.0))

            local pos = lerpVec3(startPos, endPos, t)
            local rot = lerpVec3(startRot, endRot, t)
            local f   = lerp(startFov, endFov, t)

            local d_strength = lerp(startDof.strength, endDof.strength, t)
            local d_near     = lerp(startDof.near, endDof.near, t)
            local d_far      = lerp(startDof.far, endDof.far, t)
            local f_strength = lerp(startDof.filterStrength, endDof.filterStrength, t)
            local s_strength = lerp(startDof.shakeStrength, endDof.shakeStrength, t)

            SetCamCoord(freecamCam, pos.x, pos.y, pos.z)
            SetCamRot(freecamCam, rot.x, rot.y, rot.z, 2)
            SetCamFov(freecamCam, f)

            camPos = pos
            camRot = rot
            fov    = f

            dofEnabled  = startDof.enabled or endDof.enabled
            dofStrength = d_strength
            dofNear     = d_near
            dofFar      = d_far

            filterEnabled  = (t > 0.5) and endDof.filterEnabled or startDof.filterEnabled
            filterName     = (t > 0.5) and endDof.filter or startDof.filter
            filterStrength = f_strength

            shakeEnabled  = startDof.shakeEnabled or endDof.shakeEnabled
            shakeStrength = s_strength

            applyEffects()
            Wait(0)
        end

        if inTransition then
            camPos = endPos
            camRot = endRot
            fov    = endFov
            dofEnabled     = endDof.enabled
            dofStrength    = endDof.strength
            dofNear        = endDof.near
            dofFar         = endDof.far
            filterName     = endDof.filter
            filterStrength = endDof.filterStrength
            shakeEnabled   = endDof.shakeEnabled
            shakeStrength  = endDof.shakeStrength
            filterEnabled  = endDof.filterEnabled

            SetCamCoord(freecamCam, camPos.x, camPos.y, camPos.z)
            SetCamRot(freecamCam, camRot.x, camRot.y, camRot.z, 2)
            SetCamFov(freecamCam, fov)
        end

        if onDone then onDone() end
    end)
end

local function startChainedTransitions()
    if #pendingSegments == 0 or inTransition then return end
    inTransition = true

    local totalDuration = 0
    for _, seg in ipairs(pendingSegments) do
        totalDuration = totalDuration + seg.duration
    end

    TriggerEvent('photomode:onTransitionStart', totalDuration)

    local segs = pendingSegments
    local idx  = 1

    local function runNext()
        if not inTransition or idx > #segs then
            inTransition    = false
            transitionStep  = 0
            waypoints       = {}
            pendingSegments = {}
            return
        end
        TriggerEvent('photomode:onSegmentStart', idx, #segs, segs[idx].duration)
        runSegment(segs[idx], function()
            idx = idx + 1
            runNext()
        end)
    end
    runNext()
end

local function startTransition(duration)
    if #waypoints >= 2 then
        pendingSegments = {{ from = waypoints[1], to = waypoints[2], duration = duration }}
        startChainedTransitions()
    end
end

local function handleMovement(delta)
    if inTransition then return end

    local isFast = IsControlPressed(0, Config.Controls.FastMove)
    local speed  = isFast and Config.FastMoveSpeed or Config.MoveSpeed

    local rotZ  = math.rad(camRot.z)
    local fwd   = vector3(-math.sin(rotZ), math.cos(rotZ), 0.0)
    local right = vector3( math.cos(rotZ), math.sin(rotZ), 0.0)

    local axisRX = GetControlNormal(0, 220)
    local axisRY = GetControlNormal(0, 221)

    local inputX, inputY, inputZ = 0.0, 0.0, 0.0
    if IsDisabledControlPressed(0, 32)                       then inputY =  1.0 end
    if IsDisabledControlPressed(0, 33)                       then inputY = -1.0 end
    if IsDisabledControlPressed(0, 34)                       then inputX = -1.0 end
    if IsDisabledControlPressed(0, 35)                       then inputX =  1.0 end
    if IsDisabledControlPressed(0, Config.Controls.MoveUp)   then inputZ =  1.0 end
    if IsDisabledControlPressed(0, Config.Controls.MoveDown) then inputZ = -1.0 end

    local targetVel = fwd   * (inputY * speed)
                    + right * (inputX * speed)
                    + vector3(0.0, 0.0, inputZ * speed)

    local t = math.min(Config.MoveSmoothing * delta, 1.0)
    camVelocity = vector3(
        camVelocity.x + (targetVel.x - camVelocity.x) * t,
        camVelocity.y + (targetVel.y - camVelocity.y) * t,
        camVelocity.z + (targetVel.z - camVelocity.z) * t
    )

    local nextPos = camPos + camVelocity * delta

    if Config.Collisions then
        local ray = StartShapeTestRay(
            camPos.x, camPos.y, camPos.z,
            nextPos.x, nextPos.y, nextPos.z,
            1, PlayerPedId(), 0
        )
        local _, hit, endCoords, surfaceNormal, _ = GetShapeTestResult(ray)
        if hit == 1 then
            nextPos = endCoords + surfaceNormal * 0.15
            local dot = camVelocity.x * surfaceNormal.x
                      + camVelocity.y * surfaceNormal.y
                      + camVelocity.z * surfaceNormal.z
            if dot < 0 then
                camVelocity = vector3(
                    camVelocity.x - dot * surfaceNormal.x,
                    camVelocity.y - dot * surfaceNormal.y,
                    camVelocity.z - dot * surfaceNormal.z
                )
            end
        end
    end

    camPos = nextPos

    local dist = #(camPos - playerOriginCoords)
    if dist > Config.MaxDistance then
        local dir = camPos - playerOriginCoords
        camPos = playerOriginCoords + (dir / dist) * Config.MaxDistance
    end

    local moveRoll = 0.0
    if IsDisabledControlPressed(0, Config.Controls.RollLeft)  then moveRoll = -1.0 end
    if IsDisabledControlPressed(0, Config.Controls.RollRight) then moveRoll =  1.0 end

    local rotSpeed = Config.RotateSpeed * delta * 100
    camRot = vector3(
        math.max(-89.0, math.min(89.0, camRot.x - axisRY * rotSpeed)),
        camRot.y + moveRoll * (Config.RotateSpeed * delta * 50),
        camRot.z - axisRX * rotSpeed
    )

    local scrollUp    = GetControlNormal(0, 241)
    local scrollDown  = GetControlNormal(0, 242)
    local scrollInput = (scrollDown - scrollUp) * Config.ZoomSpeed

    fovVelocity = (fovVelocity + scrollInput) * math.max(0.0, 1.0 - Config.ZoomSmoothing * delta)
    targetFov   = math.max(Config.MinFov, math.min(Config.MaxFov, targetFov + fovVelocity))
    fov         = fov + (targetFov - fov) * math.min(delta * 8.0, 1.0)

    SetCamCoord(freecamCam, camPos.x, camPos.y, camPos.z)
    SetCamRot(freecamCam, camRot.x, camRot.y, camRot.z, 2)
    SetCamFov(freecamCam, fov)

    applyEffects()
end

AddEventHandler('photomode:doStartTransition', function(duration)
    startTransition(duration)
end)

AddEventHandler('photomode:addSegmentAndContinue', function(duration)
    if #waypoints >= 2 then
        local seg = { from = waypoints[1], to = waypoints[2], duration = duration }
        table.insert(pendingSegments, seg)
    end
    transitionStep = 3
    waypoints = {}
    TriggerEvent('photomode:onSegmentAdded', #pendingSegments)
end)

AddEventHandler('photomode:launchChain', function(duration)
    if #waypoints >= 2 then
        local seg = { from = waypoints[1], to = waypoints[2], duration = duration }
        table.insert(pendingSegments, seg)
    end
    startChainedTransitions()
end)

AddEventHandler('photomode:cancelTransition', function()
    transitionStep  = 0
    waypoints       = {}
    pendingSegments = {}
    TriggerEvent('photomode:onPointSet', 'reset')
end)

RegisterCommand('photomode_setpoint', function()
    if not freecamActive then return end
    local currentPoint = {
        pos = camPos,
        rot = camRot,
        fov = fov,
        dof = { enabled = dofEnabled, strength = dofStrength, near = dofNear, far = dofFar, filterEnabled = filterEnabled, filter = filterName, filterStrength = filterStrength, shakeEnabled = shakeEnabled, shakeStrength = shakeStrength }
    }
    if transitionStep == 0 then
        waypoints       = { currentPoint }
        pendingSegments = {}
        transitionStep  = 1
        TriggerEvent('photomode:onPointSet', 'A')
    elseif transitionStep == 3 then
        waypoints      = { currentPoint }
        transitionStep = 1
        TriggerEvent('photomode:onPointSet', 'A')
    elseif transitionStep == 1 then
        table.insert(waypoints, currentPoint)
        transitionStep = 2
        TriggerEvent('photomode:onPointSet', 'B')
        TriggerEvent('photomode:openDuration')
    end
end, false)
RegisterKeyMapping('photomode_setpoint', 'Photo Mode: Definir un point', 'keyboard', '')

RegisterCommand('photomode_cleartransitions', function()
    if not freecamActive then return end
    if inTransition then return end 
    transitionStep  = 0
    waypoints       = {}
    pendingSegments = {}
    TriggerEvent('photomode:onPointSet', 'reset')
end, false)
RegisterKeyMapping('photomode_cleartransitions', 'Photo Mode: Réinitialiser les transitions', 'keyboard', '')

RegisterNetEvent('photomode:toggle')
AddEventHandler('photomode:toggle', function()
    local ped = PlayerPedId()
    
    if not freecamActive then
        if IsPedDeadOrDying(ped, true) then return end
        if IsPedFalling(ped) then return end
    end

    if freecamActive then
        stopFreecam()
    else
        freecamActive = true
        initFreecam()
        ExecuteCommand('togglehud')
        TriggerEvent('photomode:onFreecamStart')
    end
end)

RegisterCommand('photomode', function()
    TriggerServerEvent('photomode:requestToggle')
end, false)
RegisterKeyMapping('photomode', 'Photo Mode: Toggle', 'keyboard', '')

CreateThread(function()
    local prev = GetGameTimer()
    while true do
        Wait(0)

        local now   = GetGameTimer()
        local delta = math.min((now - prev) / 1000.0, 0.05)
        prev = now

        if freecamActive then
            handleMovement(delta)

            DisableAllControlActions(0)
            EnableControlAction(0, Config.Controls.FastMove, true)
            EnableControlAction(0, 220, true)
            EnableControlAction(0, 221, true)
            EnableControlAction(0, 241, true)
            EnableControlAction(0, 242, true)
            EnableControlAction(0, Config.Controls.RollLeft, true)
            EnableControlAction(0, Config.Controls.RollRight, true)
        end
    end
end)

exports('startFreecam', function()
    if not freecamActive then
        freecamActive = true
        initFreecam()
        ExecuteCommand('togglehud')
        TriggerEvent('photomode:onFreecamStart')
    end
end)

exports('stopFreecam', function()
    stopFreecam()
end)

exports('isFreecamActive', function()
    return freecamActive
end)

exports('getFreecamPos', function()
    return camPos
end)

exports('setEffects', function(enabled, strength, near, far, fEnabled, filter, fStrength, sEnabled, sStrength)
    dofEnabled  = enabled
    dofStrength = strength or dofStrength
    dofNear     = near    or dofNear
    dofFar      = far     or dofFar
    filterEnabled = fEnabled
    filterName  = filter  or filterName
    filterStrength = fStrength or filterStrength
    if sEnabled ~= nil then shakeEnabled = sEnabled end
    shakeStrength = sStrength or shakeStrength
end)

exports('getEffects', function()
    return { enabled = dofEnabled, strength = dofStrength, near = dofNear, far = dofFar, filterEnabled = filterEnabled, filter = filterName, filterStrength = filterStrength, shakeEnabled = shakeEnabled, shakeStrength = shakeStrength }
end)