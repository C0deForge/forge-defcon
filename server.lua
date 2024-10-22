local ESX, QBCore = nil, nil
local currentDefconLevel = 0 -- Variable para almacenar el nivel actual de DEFCON

-- Configurar el framework según la configuración
if Config.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Función para imprimir mensajes de depuración
local function debugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

-- Evento para establecer el nivel de DEFCON
RegisterNetEvent('defcon:setLevel')
AddEventHandler('defcon:setLevel', function(level)
    currentDefconLevel = level
    TriggerClientEvent('defcon:notifyAllPlayers', -1, level)
    TriggerClientEvent('defcon:showUI', -1, level)
end)

-- Evento para limpiar el nivel de DEFCON
RegisterNetEvent('defcon:clearLevel')
AddEventHandler('defcon:clearLevel', function()
    if currentDefconLevel == 0 then
        local message = Config.Messages.NoActiveDEFCON
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.showNotification(message)
        elseif QBCore then
            TriggerClientEvent('QBCore:Notify', source, message, "error")
        end
    else
        currentDefconLevel = 0
        TriggerClientEvent('defcon:notifyAllPlayers', -1, 'remove')
        TriggerClientEvent('defcon:clearUI', -1)
    end
end)

-- Evento para enviar el estado actual del DEFCON a un jugador que se conecta
RegisterNetEvent('defcon:requestCurrentLevel')
AddEventHandler('defcon:requestCurrentLevel', function()
    local src = source
    if currentDefconLevel > 0 then
        TriggerClientEvent('defcon:showUI', src, currentDefconLevel)
    else
        TriggerClientEvent('defcon:clearUI', src)
    end
end)

-- Cuando un jugador se conecta, enviarle el estado actual del DEFCON
AddEventHandler('playerConnecting', function()
    local src = source
    if currentDefconLevel > 0 then
        TriggerClientEvent('defcon:showUI', src, currentDefconLevel)
    end
end)