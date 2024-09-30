QBCore = exports["qb-core"]:GetCoreObject()

local PlayerData = QBCore.Functions.GetPlayerData()
local hunger = nil
local thirst = nil
local ped, health, armor, pid, Player, playerId, playersCount, stamina
local isPauseMenuActive = false

RegisterNetEvent('hud:client:UpdateNeeds')
AddEventHandler('hud:client:UpdateNeeds', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload")
AddEventHandler("QBCore:Client:OnPlayerUnload", function()
    PlayerData = {}
    SendNUIMessage({ action = 'hideAllHud' }) 
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(100)
    SendNUIMessage({ action = 'ShowAllHud' }) 
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Wait(100)
        if LocalPlayer.state.isLoggedIn then
            SendNUIMessage({ action = 'ShowAllHud' })
        else
            SendNUIMessage({ action = 'hideAllHud' })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        local pauseMenuState = IsPauseMenuActive()

        if pauseMenuState ~= isPauseMenuActive then
            isPauseMenuActive = pauseMenuState

            if isPauseMenuActive then
                SendNUIMessage({ action = 'hideAllHud' })
                SendNUIMessage({ action = 'hideStaminaNeedsStatus' }) 
            else
                if LocalPlayer.state.isLoggedIn then
                    SendNUIMessage({ action = 'ShowAllHud' })
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do 
        Wait(500)
        if not isPauseMenuActive and LocalPlayer.state.isLoggedIn then 
            QBCore.Functions.GetPlayerData(function(PlayerData)
                ped = PlayerPedId()
                health = GetEntityHealth(ped)
                armor = GetPedArmour(ped)
                Player = QBCore.Functions.GetPlayerData()
                playerId = PlayerId() 
                pid = GetPlayerServerId(PlayerId())
                playersCount = 1
                stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
                
                SendNUIMessage({
                    action = 'updateStatus',
                    pid = pid,
                    health = health - 100,
                    armor = armor,
                    hunger = hunger,
                    thirst = thirst,
                    stamina = stamina,
                    oxigen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
                })
                
            end)
        else
            SendNUIMessage({ action = 'hideAllHud' })
        end
        Wait(1000)
    end
end)
