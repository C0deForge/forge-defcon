local ESX, QBCore = nil, nil

-- Set up the framework based on the configuration
if Config.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "QB" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local radarVisible, defconActive = false, false

-- Function to log debug messages
local function debugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

-- Function to check if a player can access the DEFCON command
local function canAccessDefcon(rank, job)
    local requiredRanks = Config.DefconRanks[job]
    if requiredRanks then
        for _, requiredRank in ipairs(requiredRanks) do
            if rank == requiredRank then
                return true
            end
        end
    end
    return false
end

-- Command to set the DEFCON
RegisterCommand('defcon', function()
    local job, grade, onDuty

    if ESX then
        local xPlayer = ESX.GetPlayerData()
        job, grade = xPlayer.job.name, xPlayer.job.grade
    elseif QBCore then
        local PlayerData = QBCore.Functions.GetPlayerData()
        job, grade, onDuty = PlayerData.job.name, PlayerData.job.grade.level, PlayerData.job.onduty
    end

    debugPrint("Job: " .. job .. ", Grade: " .. grade .. ", OnDuty: " .. tostring(onDuty))

    -- Check permissions only when opening the menu
    if canAccessDefcon(grade, job) and (ESX or onDuty) then
        TriggerEvent('defcon:openMenu')
    else
        local message = Config.Messages.NoPermission
        if ESX then
            ESX.ShowNotification(message)
        elseif QBCore then
            QBCore.Functions.Notify(message, "error")
        end
    end
end, false)

-- Event to open the DEFCON menu
RegisterNetEvent('defcon:openMenu')
AddEventHandler('defcon:openMenu', function()
    local elements = {
        {header = Config.MenuHeaders.DEFCON1, value = 1},
        {header = Config.MenuHeaders.DEFCON2, value = 2},
        {header = Config.MenuHeaders.DEFCON3, value = 3},
        {header = Config.MenuHeaders.DEFCON4, value = 4},
        {header = Config.MenuHeaders.DEFCON5, value = 5},
        {header = Config.MenuHeaders.RemoveDEFCON, value = 0}
    }

    if ESX then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'defcon_menu', {
            title = Config.MenuTitle,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local level = data.current.value
            TriggerServerEvent('defcon:setLevel', level)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    elseif QBCore then
        local qbElements = {}
        for _, element in ipairs(elements) do
            table.insert(qbElements, {
                header = element.header,
                params = {
                    event = 'defcon:selectLevel',
                    args = { level = element.value }
                }
            })
        end
        exports['qb-menu']:openMenu(qbElements)
    end
end)

-- Event to handle DEFCON level selection in QB-Core
RegisterNetEvent('defcon:selectLevel')
AddEventHandler('defcon:selectLevel', function(data)
    local level = data.level
    TriggerServerEvent('defcon:setLevel', level)
end)

-- Event to notify all players about the DEFCON level
RegisterNetEvent('defcon:notifyAllPlayers')
AddEventHandler('defcon:notifyAllPlayers', function(level)
    local defconMsg = level == 0 and
        Config.Messages.DEFCONDeactivated or
        Config.Messages.DEFCONActivated .. level .. Config.Messages.BeCareful

    debugPrint("Notification Triggered: " .. defconMsg)

    if ESX then
        ESX.ShowAdvancedNotification('LSPD', 'Alert', defconMsg, 'CHAR_CALL911', 1)
    elseif QBCore then
        QBCore.Functions.Notify(defconMsg, "primary")
    end
end)

-- Event to show the DEFCON UI
RegisterNetEvent('defcon:showUI')
AddEventHandler('defcon:showUI', function(level)
    if level > 0 then
        local color = Config.DefconColors[level]
        SendNUIMessage({
            action = 'showDefconUI',
            defconLevel = level,
            defconColor = color
        })

        if not defconActive then
            defconActive = true
            monitorRadar()
        end
    else
        -- If the level is 0, clear the UI
        TriggerEvent('defcon:clearUI')
    end
end)

-- Event to clear the DEFCON UI
RegisterNetEvent('defcon:clearUI')
AddEventHandler('defcon:clearUI', function()
    SendNUIMessage({ action = 'clearDefconUI' })
    defconActive = false
end)

-- Function to monitor radar status
function monitorRadar()
    Citizen.CreateThread(function()
        while defconActive do
            Citizen.Wait(500)
            local radarActive = IsRadarEnabled()

            if radarActive and not radarVisible then
                radarVisible = true
                SendNUIMessage({ action = 'moveUp' })
            elseif not radarActive and radarVisible then
                radarVisible = false
                SendNUIMessage({ action = 'moveDown' })
            end
        end
    end)
end

-- Request DEFCON status on player spawn
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('defcon:requestCurrentLevel')
end)

-- Handle server response for current DEFCON level
RegisterNetEvent('defcon:currentLevel')
AddEventHandler('defcon:currentLevel', function(level)
    if level > 0 then
        TriggerEvent('defcon:showUI', level)
    else
        TriggerEvent('defcon:clearUI')
    end
end)
