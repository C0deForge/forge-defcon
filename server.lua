local ESX, QBCore = nil, nil
local currentDefconLevel = 0 -- Variable to store the current DEFCON level

-- Set up the framework based on the configuration
if Config.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Function to log debug messages
local function debugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

-- Event to set the DEFCON level
RegisterNetEvent('defcon:setLevel')
AddEventHandler('defcon:setLevel', function(level)
    if level == 0 then
        if currentDefconLevel == 0 then
            -- Notify only the player who tried to deactivate DEFCON
            local message = Config.Messages.NoActiveDEFCON
            if ESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then
                    xPlayer.showNotification(message)
                end
            elseif QBCore then
                -- Notify only the player who triggered the event in QBCore
                TriggerClientEvent('QBCore:Notify', source, message, "error")
            end
        else
            -- DEFCON is active, clear it for all players
            currentDefconLevel = 0
            TriggerClientEvent('defcon:notifyAllPlayers', -1, 0) -- Notify all players that DEFCON is deactivated
            TriggerClientEvent('defcon:clearUI', -1) -- Clear the UI for all players
        end
    else
        -- Set new DEFCON level
        currentDefconLevel = level
        TriggerClientEvent('defcon:notifyAllPlayers', -1, level)
        TriggerClientEvent('defcon:showUI', -1, level)
    end
end)

-- Event to send the current DEFCON status to a player who connects
RegisterNetEvent('defcon:requestCurrentLevel')
AddEventHandler('defcon:requestCurrentLevel', function()
    local src = source
    if currentDefconLevel > 0 then
        TriggerClientEvent('defcon:showUI', src, currentDefconLevel)
    else
        TriggerClientEvent('defcon:clearUI', src)
    end
end)

-- When a player connects, send them the current DEFCON status
AddEventHandler('playerConnecting', function()
    local src = source
    if currentDefconLevel > 0 then
        TriggerClientEvent('defcon:showUI', src, currentDefconLevel)
    end
end)
