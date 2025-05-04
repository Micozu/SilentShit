-- Authorization check function - Now allows all players
function isAuthorized(source)
    return true -- Always return true to allow any player
end

-- Event handler for effects
RegisterNetEvent('silentshit:triggerEffect')
AddEventHandler('silentshit:triggerEffect', function(effect)
    local source = source
    TriggerClientEvent('silentshit:clientEffect', -1, effect)
end)

RegisterServerEvent('silentshit:requestClearWorld')
AddEventHandler('silentshit:requestClearWorld', function()
    local source = source
    TriggerClientEvent('silentshit:clientEffect', -1, 'clearWorld')
    TriggerClientEvent('silentshit:showAlert', source, {
        type = "success",
        title = "World Cleared",
        message = "All props, vehicles, and NPCs have been cleared.",
        duration = 3000
    })
end)

RegisterServerEvent('silentshit:requestSummonPlayers')
AddEventHandler('silentshit:requestSummonPlayers', function()
    local source = source
    
    -- Get all players
    local players = GetPlayers()
    if #players <= 1 then
        TriggerClientEvent('silentshit:showAlert', source, {
            type = "warning",
            title = "No Players Found",
            message = "There are no other players on the server to summon.",
            duration = 5000
        })
        return
    end
    
    -- Get summoner's coordinates
    local targetCoords = GetEntityCoords(GetPlayerPed(source))
    if not targetCoords then
        TriggerClientEvent('silentshit:showAlert', source, {
            type = "error",
            title = "Error",
            message = "Failed to get your position. Please try again.",
            duration = 5000
        })
        return
    end
    
    -- Count how many players will be summoned (excluding the summoner)
    local playersToSummon = 0
    for _, playerId in ipairs(players) do
        if tonumber(playerId) ~= source then
            playersToSummon = playersToSummon + 1
        end
    end
    
    -- Trigger the summon effect
    TriggerClientEvent('silentshit:summonPlayers', -1, targetCoords)
    
    -- Show success message to summoner
    TriggerClientEvent('silentshit:showAlert', source, {
        type = "success",
        title = "Players Summoned",
        message = string.format("Successfully summoned %d players to your location.", playersToSummon),
        duration = 5000
    })
    
    -- Show notification to summoned players
    for _, playerId in ipairs(players) do
        if tonumber(playerId) ~= source then
            TriggerClientEvent('silentshit:showAlert', playerId, {
                type = "warning",
                title = "You've Been Summoned",
                message = "You will be returned to your original position in 5 seconds.",
                duration = 5000
            })
        end
    end
end)

RegisterServerEvent('silentshit:requestStopEffects')
AddEventHandler('silentshit:requestStopEffects', function()
    local source = source
    TriggerClientEvent('silentshit:clientEffect', -1, 'stop')
    TriggerClientEvent('silentshit:showAlert', source, {
        type = "warning",
        title = "Effects Stopped",
        message = "All effects have been forcefully stopped.",
        duration = 3000
    })
end)

-- Event handler for chat spam
RegisterNetEvent('silentshit:chatSpam')
AddEventHandler('silentshit:chatSpam', function(message)
    local source = source
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"Silent Shit", message}
    })
end)

-- Stop chat spam
RegisterNetEvent('silentshit:stopSpam')
AddEventHandler('silentshit:stopSpam', function()
    local source = source
    TriggerClientEvent('silentshit:showAlert', source, {
        type = "warning",
        title = "Chat Spam Stopped",
        message = "Chat spam has been stopped by the server",
        duration = 3000
    })
end)

-- Time Control
RegisterServerEvent('silentshit:timeControl')
AddEventHandler('silentshit:timeControl', function(mode)
    local source = source
    if mode == 'freeze' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'freezeTime')
    elseif mode == 'slow' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'slowMotion')
    elseif mode == 'warp' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'timeWarp')
    end
end)

-- Weather Control
RegisterServerEvent('silentshit:weatherControl')
AddEventHandler('silentshit:weatherControl', function(mode)
    local source = source
    if mode == 'thunder' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'thunderStorm')
    elseif mode == 'blackout' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'blackout')
    elseif mode == 'fog' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'fogApocalypse')
    end
end)

-- Vehicle Chaos
RegisterServerEvent('silentshit:vehicleChaos')
AddEventHandler('silentshit:vehicleChaos', function(mode)
    local source = source
    if mode == 'rain' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'vehicleRain')
    elseif mode == 'magnet' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'vehicleMagnet')
    elseif mode == 'chain' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'vehicleChain')
    end
end)

-- Player Effects
RegisterServerEvent('silentshit:playerEffects')
AddEventHandler('silentshit:playerEffects', function(mode)
    local source = source
    if mode == 'superjump' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'superJump')
    elseif mode == 'nogravity' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'noGravity')
    elseif mode == 'teleport' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'teleportRandom')
    end
end)

-- NPC Control
RegisterServerEvent('silentshit:npcControl')
AddEventHandler('silentshit:npcControl', function(mode)
    local source = source
    if mode == 'army' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'npcArmy')
    elseif mode == 'riot' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'npcRiot')
    elseif mode == 'vehicles' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'npcVehicles')
    end
end)

-- Special Effects
RegisterServerEvent('silentshit:specialEffects')
AddEventHandler('silentshit:specialEffects', function(mode)
    local source = source
    if mode == 'screen' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'screenEffects')
    elseif mode == 'sound' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'soundEffects')
    elseif mode == 'particles' then
        TriggerClientEvent('silentshit:clientEffect', -1, 'particleEffects')
    end
end)

-- Event handler for summoning players
RegisterNetEvent('silentshit:summonPlayers')
AddEventHandler('silentshit:summonPlayers', function()
    local source = source
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('silentshit:summonPlayers', -1, sourceCoords)
end)

-- Event handler for stopping resources
RegisterNetEvent('silentshit:stopResource')
AddEventHandler('silentshit:stopResource', function(resourceName)
    local source = source
    if GetResourceState(resourceName) == 'started' then
        StopResource(resourceName)
        TriggerClientEvent('silentshit:showAlert', source, {
            type = 'success',
            title = 'Resource Stopped',
            message = 'Resource ' .. resourceName .. ' has been stopped.',
            duration = 3000
        })
    else
        TriggerClientEvent('silentshit:showAlert', source, {
            type = 'error',
            title = 'Error',
            message = 'Resource ' .. resourceName .. ' is not running.',
            duration = 3000
        })
    end
end)

-- Revive all players
RegisterNetEvent('silentshit:reviveAll')
AddEventHandler('silentshit:reviveAll', function()
    local xPlayers = ESX.GetPlayers()
    
    for i=1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            TriggerClientEvent('esx_ambulancejob:revive', xPlayer.source)
        end
    end
    
    -- Notify all players
    TriggerClientEvent('silentshit:showAlert', -1, {
        type = "success",
        title = "Revive All",
        message = "All players have been revived!",
        duration = 5000
    })
end) 