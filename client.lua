local display = false
local selectedEffect = nil
local activeEffects = {}
local activeEntities = {}
local anticheatDetected = false
local detectedCheats = {}

-- Effects table
local effects = {
    airstrike = function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        local thread = Citizen.CreateThread(function()
            for i = 1, 30 do
                local planeModel = GetHashKey('luxor')
                RequestModel(planeModel)
                while not HasModelLoaded(planeModel) do
                    Wait(0)
                end
                
                local plane = CreateVehicle(planeModel, 
                    coords.x + math.random(-3000, 3000), 
                    coords.y + math.random(-3000, 3000), 
                    coords.z + 2000, 
                    0.0, 
                    true, 
                    false
                )
                
                SetEntityVelocity(plane, 0.0, 300.0, 0.0)
                SetVehicleEngineOn(plane, true, true, false)
                table.insert(activeEntities, plane)
                
                Citizen.CreateThread(function()
                    while DoesEntityExist(plane) do
                        local planeCoords = GetEntityCoords(plane)
                        AddExplosion(planeCoords.x, planeCoords.y, planeCoords.z, 7, 500.0, true, false, 3.0)
                        Wait(200)
                    end
                end)
                
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,
    
    earthquake = function()
        ShakeGameplayCam('JOLT_SHAKE', 3.0)
        
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                AddExplosion(coords.x + math.random(-100, 100), coords.y + math.random(-100, 100), coords.z, 7, 500.0, true, false, 3.0)
                Wait(300)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    monkeyAttack = function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local monkeyModel = GetHashKey('a_c_chimp')
        
        RequestModel(monkeyModel)
        while not HasModelLoaded(monkeyModel) do
            Wait(0)
        end
        
        local thread = Citizen.CreateThread(function()
            for i = 1, 100 do
                local monkey = CreatePed(4, monkeyModel, 
                    coords.x + math.random(-100, 100), 
                    coords.y + math.random(-100, 100), 
                    coords.z, 
                    0.0, 
                    true, 
                    false
                )
                
                SetPedCombatAttributes(monkey, 46, true)
                SetPedCombatAbility(monkey, 2)
                SetPedCombatMovement(monkey, 2)
                SetPedCombatRange(monkey, 2)
                SetPedKeepTask(monkey, true)
                SetPedAccuracy(monkey, 100)
                SetPedFleeAttributes(monkey, 0, false)
                GiveWeaponToPed(monkey, GetHashKey('WEAPON_RPG'), 9999, false, true)
                
                TaskCombatPed(monkey, playerPed, 0, 16)
                SetPedDropsWeaponsWhenDead(monkey, false)
                table.insert(activeEntities, monkey)
                
                Wait(200)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    chaos = function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        local thread = Citizen.CreateThread(function()
            while true do
                local vehicleModels = {'rhino', 'hydra', 'cargoplane', 'dump', 'tanker', 'cutter', 'barracks', 'cargobob', 'titan', 'volatol'}
                local randomModel = vehicleModels[math.random(#vehicleModels)]
                local vehicleModel = GetHashKey(randomModel)
                
                RequestModel(vehicleModel)
                while not HasModelLoaded(vehicleModel) do
                    Wait(0)
                end
                
                local vehicle = CreateVehicle(vehicleModel, 
                    coords.x + math.random(-200, 200), 
                    coords.y + math.random(-200, 200), 
                    coords.z + 200, 
                    0.0, 
                    true, 
                    false
                )
                
                SetEntityVelocity(vehicle, 0.0, 0.0, -300.0)
                SetVehicleEngineOn(vehicle, true, true, false)
                table.insert(activeEntities, vehicle)
                
                AddExplosion(coords.x + math.random(-100, 100), 
                    coords.y + math.random(-100, 100), 
                    coords.z, 
                    7, 
                    500.0, 
                    true, 
                    false, 
                    3.0
                )
                
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    clearWorld = function()
        -- Delete all peds except players
        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) then
                DeleteEntity(ped)
            end
        end
        -- Delete all vehicles except player vehicles
        for veh in EnumerateVehicles() do
            if not IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
                DeleteEntity(veh)
            end
        end
        -- Delete all objects/props
        for obj in EnumerateObjects() do
            DeleteEntity(obj)
        end
    end,

    giveWeapons = function()
        local weapons = {
            'WEAPON_RAILGUN',
            'WEAPON_MINIGUN',
            'WEAPON_RPG',
            'WEAPON_GRENADELAUNCHER',
            'WEAPON_GRENADELAUNCHER_SMOKE',
            'WEAPON_STUNGUN',
            'WEAPON_SNIPERRIFLE',
            'WEAPON_HEAVYSNIPER',
            'WEAPON_MARKSMANRIFLE',
            'WEAPON_COMBATMG',
            'WEAPON_ASSAULTRIFLE',
            'WEAPON_CARBINERIFLE',
            'WEAPON_ADVANCEDRIFLE',
            'WEAPON_SPECIALCARBINE',
            'WEAPON_BULLPUPRIFLE',
            'WEAPON_COMPACTRIFLE',
            'WEAPON_MG',
            'WEAPON_COMBATPDW',
            'WEAPON_SMG',
            'WEAPON_ASSAULTSMG',
            'WEAPON_MACHINEPISTOL',
            'WEAPON_PISTOL',
            'WEAPON_COMBATPISTOL',
            'WEAPON_APPISTOL',
            'WEAPON_PISTOL50',
            'WEAPON_SNSPISTOL',
            'WEAPON_HEAVYPISTOL',
            'WEAPON_VINTAGEPISTOL',
            'WEAPON_MARKSMANPISTOL',
            'WEAPON_REVOLVER',
            'WEAPON_DOUBLEACTION',
            'WEAPON_SAWNOFFSHOTGUN',
            'WEAPON_BULLPUPSHOTGUN',
            'WEAPON_MUSKET',
            'WEAPON_HEAVYSHOTGUN',
            'WEAPON_DBSHOTGUN',
            'WEAPON_AUTOSHOTGUN',
            'WEAPON_PUMPSHOTGUN',
            'WEAPON_ASSAULTSHOTGUN',
            'WEAPON_GRENADE',
            'WEAPON_BZGAS',
            'WEAPON_MOLOTOV',
            'WEAPON_STICKYBOMB',
            'WEAPON_PROXMINE',
            'WEAPON_SMOKEGRENADE',
            'WEAPON_PIPEBOMB',
            'WEAPON_FLARE',
            'WEAPON_PETROLCAN',
            'WEAPON_FIREEXTINGUISHER',
            'WEAPON_BALL',
            'WEAPON_SNOWBALL',
            'WEAPON_FLAREGUN',
            'WEAPON_GUSENBERG'
        }

        for _, weapon in ipairs(weapons) do
            GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), 9999, false, true)
        end
    end,

    chatspam = function()
        -- Show the chat spam UI
        SendNUIMessage({
            type = "showChatSpam"
        })
    end,

    -- Time Control Effects
    freezeTime = function()
        local thread = Citizen.CreateThread(function()
            while true do
                NetworkOverrideClockTime(12, 0)
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    slowMotion = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetGameplayCamShake(1, 1.0, 1.0)
                SetTimeScale(0.5)
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    timeWarp = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local speed = math.random(0.2, 2.0)
                SetTimeScale(speed)
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    -- Weather Effects
    thunderStorm = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetWeatherTypeNow('THUNDER')
                SetWeatherTypePersist('THUNDER')
                SetRainLevel(1.0)
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                ForceLightningFlash()
                AddExplosion(coords.x + math.random(-100, 100), coords.y + math.random(-100, 100), coords.z, 7, 500.0, true, false, 3.0)
                Wait(1000)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    blackout = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetArtificialLightsState(true)
                SetArtificialLightsStateAffectsVehicles(true)
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    fogApocalypse = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetWeatherTypeNow('FOGGY')
                SetWeatherTypePersist('FOGGY')
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    -- Vehicle Chaos
    vehicleRain = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local vehicleModels = {'rhino', 'hydra', 'cargoplane', 'dump', 'tanker', 'cutter', 'barracks', 'cargobob', 'titan', 'volatol'}
                local randomModel = vehicleModels[math.random(#vehicleModels)]
                local vehicleModel = GetHashKey(randomModel)
                
                RequestModel(vehicleModel)
                while not HasModelLoaded(vehicleModel) do
                    Wait(0)
                end
                
                local vehicle = CreateVehicle(vehicleModel, 
                    coords.x + math.random(-200, 200), 
                    coords.y + math.random(-200, 200), 
                    coords.z + 200, 
                    0.0, 
                    true, 
                    false
                )
                
                SetEntityVelocity(vehicle, 0.0, 0.0, -300.0)
                SetVehicleEngineOn(vehicle, true, true, false)
                table.insert(activeEntities, vehicle)
                
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    vehicleMagnet = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in ipairs(vehicles) do
                    if DoesEntityExist(vehicle) then
                        local vehCoords = GetEntityCoords(vehicle)
                        local distance = #(vehCoords - coords)
                        if distance < 200.0 then
                            local direction = coords - vehCoords
                            local force = direction * 0.2
                            ApplyForceToEntity(vehicle, 1, force.x, force.y, force.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                        end
                    end
                end
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    vehicleChain = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local vehicles = GetGamePool('CVehicle')
                for _, vehicle in ipairs(vehicles) do
                    if DoesEntityExist(vehicle) then
                        local coords = GetEntityCoords(vehicle)
                        AddExplosion(coords.x, coords.y, coords.z, 7, 500.0, true, false, 3.0)
                        Wait(200)
                    end
                end
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    -- Player Effects
    superJump = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetSuperJumpThisFrame(PlayerId())
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    noGravity = function()
        local thread = Citizen.CreateThread(function()
            while true do
                SetPedGravity(PlayerPedId(), 0.0)
                Wait(0)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    teleportRandom = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local randomX = coords.x + math.random(-2000, 2000)
                local randomY = coords.y + math.random(-2000, 2000)
                local ground, groundZ = GetGroundZFor_3dCoord(randomX, randomY, 9999.0, 0)
                SetEntityCoords(playerPed, randomX, randomY, groundZ, false, false, false, false)
                AddExplosion(randomX, randomY, groundZ, 7, 500.0, true, false, 3.0)
                Wait(2000)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    -- NPC Control
    npcArmy = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local pedModels = {'s_m_y_swat_01', 's_m_y_cop_01', 's_m_y_dealer_01', 's_m_y_blackops_01', 's_m_y_blackops_02', 's_m_y_blackops_03'}
                local randomModel = pedModels[math.random(#pedModels)]
                local pedModel = GetHashKey(randomModel)
                
                RequestModel(pedModel)
                while not HasModelLoaded(pedModel) do
                    Wait(0)
                end
                
                local ped = CreatePed(4, pedModel, 
                    coords.x + math.random(-100, 100), 
                    coords.y + math.random(-100, 100), 
                    coords.z, 
                    0.0, 
                    true, 
                    false
                )
                
                GiveWeaponToPed(ped, GetHashKey('WEAPON_RPG'), 9999, false, true)
                SetPedCombatAttributes(ped, 46, true)
                SetPedCombatAbility(ped, 2)
                SetPedCombatMovement(ped, 2)
                SetPedCombatRange(ped, 2)
                SetPedKeepTask(ped, true)
                SetPedAccuracy(ped, 100)
                SetPedFleeAttributes(ped, 0, false)
                
                table.insert(activeEntities, ped)
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    npcRiot = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local peds = GetGamePool('CPed')
                for _, ped in ipairs(peds) do
                    if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                        SetPedCombatAttributes(ped, 46, true)
                        SetPedCombatAbility(ped, 2)
                        SetPedCombatMovement(ped, 2)
                        SetPedCombatRange(ped, 2)
                        SetPedKeepTask(ped, true)
                        SetPedAccuracy(ped, 100)
                        SetPedFleeAttributes(ped, 0, false)
                        GiveWeaponToPed(ped, GetHashKey('WEAPON_RPG'), 9999, false, true)
                        TaskCombatPed(ped, PlayerPedId(), 0, 16)
                    end
                end
                Wait(1000)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    npcVehicles = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local peds = GetGamePool('CPed')
                for _, ped in ipairs(peds) do
                    if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                        local vehicleModels = {'adder', 'zentorno', 't20', 'osiris', 'entityxf', 'rhino', 'hydra', 'cargoplane'}
                        local randomModel = vehicleModels[math.random(#vehicleModels)]
                        local vehicleModel = GetHashKey(randomModel)
                        
                        RequestModel(vehicleModel)
                        while not HasModelLoaded(vehicleModel) do
                            Wait(0)
                        end
                        
                        local coords = GetEntityCoords(ped)
                        local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, 0.0, true, false)
                        SetPedIntoVehicle(ped, vehicle, -1)
                        SetVehicleEngineOn(vehicle, true, true, false)
                        TaskVehicleDriveWander(ped, vehicle, 50.0, 786603)
                        table.insert(activeEntities, vehicle)
                    end
                end
                Wait(2000)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    -- Special Effects
    screenEffects = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local effects = {'DrugsMichaelAliensFight', 'DrugsMichaelAliensFightIn', 'DrugsMichaelAliensFightOut', 'DrugsDrivingIn', 'DrugsDrivingOut', 'DrugsTrevorClownsFight', 'DrugsTrevorClownsFightIn', 'DrugsTrevorClownsFightOut'}
                local randomEffect = effects[math.random(#effects)]
                SetTimecycleModifier(randomEffect)
                SetTimecycleModifierStrength(1.0)
                Wait(1000)
                ClearTimecycleModifier()
            end
        end)
        table.insert(activeEffects, thread)
    end,

    soundEffects = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local sounds = {'Explosion_Countdown', 'GTAO_FM_Events_Soundset', 'DLC_HEIST3_Arcade_General_Sounds', 'DLC_HEIST4_MUSIC_SOUNDS', 'DLC_HEIST4_ARCADE_SOUNDS', 'DLC_HEIST4_ARCADE_SOUNDS'}
                local randomSound = sounds[math.random(#sounds)]
                PlaySoundFrontend(-1, randomSound, randomSound, true)
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    particleEffects = function()
        local thread = Citizen.CreateThread(function()
            while true do
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                RequestNamedPtfxAsset('core')
                while not HasNamedPtfxAssetLoaded('core') do
                    Wait(0)
                end
                UseParticleFxAssetNextCall('core')
                StartParticleFxNonLoopedAtCoord('ent_amb_fly_swarm', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
                Wait(500)
            end
        end)
        table.insert(activeEffects, thread)
    end,

    reviveAll = function()
        TriggerServerEvent('silentshit:reviveAll')
    end
}

-- Enhanced anticheat detection
local anticheats = {
    -- Common anticheats
    {name = "finiac", bypass = true},
    {name = "venomac", bypass = true},
    {name = "xeroshield", bypass = true},
    {name = "fxguard", bypass = true},
    {name = "vanillaac", bypass = true},
    {name = "fiveguard", bypass = true},
    {name = "fireac", bypass = true},
    {name = "eulen", bypass = true},
    {name = "redengine", bypass = true},
    {name = "guardian", bypass = true},
    {name = "shield", bypass = true},
    {name = "protector", bypass = true},
    {name = "defender", bypass = true},
    {name = "security", bypass = true},
    {name = "safety", bypass = true},
    {name = "guard", bypass = true},
    {name = "shield", bypass = true},
    {name = "protect", bypass = true},
    {name = "security", bypass = true},
    {name = "safeguard", bypass = true},
    {name = "defender", bypass = true},
    {name = "guardian", bypass = true},
    {name = "watchdog", bypass = true},
    {name = "sentinel", bypass = true},
    {name = "shield", bypass = true},
    {name = "protector", bypass = true},
    {name = "defense", bypass = true},
    {name = "security", bypass = true},
    {name = "safety", bypass = true}
}

-- Create the UI
function CreateUI()
    if display then return end
    
    SetNuiFocus(true, true)
    display = true
    
    -- Show loading screen first
    SendNUIMessage({
        type = "openLoadingUI",
        display = true
    })
    
    -- Wait a bit to show loading screen
    Citizen.Wait(2000)
    
    -- Show main UI
    SendNUIMessage({
        type = "openMainUI",
        display = true
    })
end

-- Close the UI
function CloseUI()
    if not display then return end
    
    SetNuiFocus(false, false)
    display = false
    
    SendNUIMessage({
        type = "closeUI",
        display = false
    })
end

-- Register commands
RegisterCommand('silentshit', function()
    CreateUI()
end, false)

RegisterCommand('ss', function()
    CreateUI()
end, false)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('effect', function(data, cb)
    if data.effect == 'stop' then
        StopAllEffects()
    else
        TriggerServerEvent('silentshit:triggerEffect', data.effect)
    end
    cb('ok')
end)

-- Register the commands
RegisterCommand('silentshit', function()
    CreateUI()
end)

RegisterCommand('ss', function()
    CreateUI()
end)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('startSpam', function(data, cb)
    StartChatSpam(data.text, data.duration)
    cb('ok')
end)

RegisterNUICallback('stopSpam', function(data, cb)
    StopChatSpam()
    cb('ok')
end)

-- Clean up entities
function CleanupEntities()
    for _, entity in pairs(activeEntities) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
    activeEntities = {}
end

-- Stop all effects
function StopAllEffects()
    -- Stop all active effects
    for _, effect in pairs(effects) do
        if effect.active then
            effect.active = false
            if effect.thread then
                Citizen.TerminateThread(effect.thread)
                effect.thread = nil
            end
        end
    end

    -- Reset time
    NetworkOverrideClockTime(12, 0)
    ClearTimecycleModifier()

    -- Reset weather
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypePersist('CLEAR')
    NetworkOverrideClockTime(12, 0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()

    -- Reset screen effects
    AnimpostfxStopAll()
    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.0)
    StopGameplayCamShaking(true)
    ClearTimecycleModifier()

    -- Delete all vehicles
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end

    -- Delete all peds
    local peds = GetAllPeds()
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
        end
    end

    -- Delete all objects
    local objects = GetAllObjects()
    for _, object in ipairs(objects) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end

    -- Reset player state
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    SetEntityInvincible(playerPed, false)
    SetEntityCanBeDamaged(playerPed, true)
    SetPedCanRagdoll(playerPed, true)
    SetPedCanRagdollFromPlayerImpact(playerPed, true)
    SetPedRagdollForceFall(playerPed)
    SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
    Wait(1000)
    ClearPedTasksImmediately(playerPed)

    -- Reset vehicle state
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleForwardSpeed(vehicle, 0.0)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehiclePetrolTankHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)
    end

    -- Reset game state
    SetGameplayCamRelativeHeading(0.0)
    SetGameplayCamRelativePitch(0.0, 1.0)
    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.0)
    StopGameplayCamShaking(true)
    ClearTimecycleModifier()

    -- Force cleanup
    CollectGarbage()
    Wait(100)
    CollectGarbage()

    -- Show success message
    SendNUIMessage({
        type = "showAlert",
        alertType = "success",
        title = "Effects Stopped",
        message = "All effects have been forcefully stopped and cleaned up",
        duration = 3000
    })
end

-- Chat spam variables
local isSpamming = false
local spamThread = nil
local spamText = ""
local spamEndTime = 0

-- Chat spam functions
function StartChatSpam(text, duration)
    if isSpamming then return end
    
    spamText = text
    spamEndTime = GetGameTimer() + duration
    isSpamming = true
    
    -- Show alert
    SendNUIMessage({
        type = "showAlert",
        alertType = "success",
        title = "Chat Spam Started",
        message = "Spamming chat for " .. (duration / 1000) .. " seconds",
        duration = 3000
    })
    
    -- Start spam thread
    spamThread = Citizen.CreateThread(function()
        local colors = {
            "^1", -- Red
            "^2", -- Green
            "^3", -- Yellow
            "^4", -- Blue
            "^5", -- Light Blue
            "^6", -- Purple
            "^7", -- White
            "^8", -- Orange
            "^9"  -- Pink
        }
        
        while isSpamming and GetGameTimer() < spamEndTime do
            local randomColor = colors[math.random(#colors)]
            TriggerServerEvent('silentshit:chatSpam', randomColor .. spamText)
            Wait(100) -- Spam every 100ms
        end
        
        StopChatSpam()
    end)
end

function StopChatSpam()
    if not isSpamming then return end
    
    isSpamming = false
    if spamThread then
        Citizen.TerminateThread(spamThread)
        spamThread = nil
    end
    
    -- Show alert
    SendNUIMessage({
        type = "showAlert",
        alertType = "warning",
        title = "Chat Spam Stopped",
        message = "Chat spam has been stopped",
        duration = 3000
    })
end

-- Event handler for effects
RegisterNetEvent('silentshit:clientEffect')
AddEventHandler('silentshit:clientEffect', function(effect)
    if effects[effect] then
        effects[effect]()
        
        -- Show effect started alert
        SendNUIMessage({
            type = "showAlert",
            alertType = "success",
            title = "Effect Started",
            message = "Effect '" .. effect .. "' has been activated.",
            duration = 3000
        })
    end
end)

-- Summon players effect
RegisterNetEvent('silentshit:summonPlayers')
AddEventHandler('silentshit:summonPlayers', function(targetCoords)
    local playerPed = PlayerPedId()
    local currentCoords = GetEntityCoords(playerPed)
    
    -- Teleport to target location
    SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
    
    -- Add a small delay and then return to original position
    Citizen.Wait(5000)
    SetEntityCoords(playerPed, currentCoords.x, currentCoords.y, currentCoords.z, false, false, false, false)
end)

-- Alert handler
RegisterNetEvent('silentshit:showAlert')
AddEventHandler('silentshit:showAlert', function(data)
    SendNUIMessage({
        type = "showAlert",
        alertType = data.type,
        title = data.title,
        message = data.message,
        duration = data.duration
    })
end)

-- Utility functions for entity enumeration
function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        enum.destructor(enum.handle)
    end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
    end
}

-- NUI Callbacks for anticheat handling
RegisterNUICallback('attemptBypass', function(data, cb)
    -- Attempt to stop detected anticheats
    for _, cheat in ipairs(detectedCheats) do
        if cheat.bypass then
            TriggerServerEvent('silentshit:stopResource', cheat.name)
        end
    end
    
    -- Wait a bit to see if the bypass worked
    Citizen.Wait(2000)
    
    -- Check if any anticheats are still running
    local stillRunning = false
    for _, cheat in ipairs(detectedCheats) do
        if GetResourceState(cheat.name) == 'started' then
            stillRunning = true
            break
        end
    end
    
    if not stillRunning then
        SendNUIMessage({
            type = "openMainUI",
            display = true
        })
    else
        SendNUIMessage({
            type = "showAlert",
            alertType = "error",
            title = "Bypass Failed",
            message = "Could not bypass all anticheats. Proceed with caution.",
            duration = 5000
        })
    end
    
    cb('ok')
end)

RegisterNUICallback('continueAnyway', function(data, cb)
    SendNUIMessage({
        type = "openMainUI",
        display = true
    })
    cb('ok')
end)

RegisterNUICallback('cancel', function(data, cb)
    CloseUI()
    cb('ok')
end) 