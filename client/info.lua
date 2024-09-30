local QBCore = exports['qb-core']:GetCoreObject()

local function getCurrentWeaponAmmo()
    local playerPed = PlayerPedId()
    local weapon = GetSelectedPedWeapon(playerPed) 
    if weapon ~= nil and weapon ~= `WEAPON_UNARMED` then
        local ammo = GetAmmoInPedWeapon(playerPed, weapon) 
        local _, currentMagazine = GetAmmoInClip(playerPed, weapon) 
        return ammo, currentMagazine, true 
    end
    return 0, 0, false 
end

local function updateHUD()
    local playerData = QBCore.Functions.GetPlayerData()
    local jobLabel = playerData.job and playerData.job.label or "Unknown"
    local jobGrade = playerData.job and playerData.job.grade and playerData.job.grade.name or "Not available"
    local cash = playerData.money and playerData.money.cash or 0
    local bank = playerData.money and playerData.money.bank or 0
    local serverId = GetPlayerServerId(PlayerId())
    local ammo, currentMagazine, hasWeapon = getCurrentWeaponAmmo()

    local gangLabel = playerData.gang and playerData.gang.label or "XxX" -- Gang label
    local gangGrade = playerData.gang and playerData.gang.grade and playerData.gang.grade.name or "" -- Gang rank/grade

    SendNUIMessage({
        action = "updateHUD",
        jobLabel = jobLabel,
        jobGrade = jobGrade,
        cash = cash,
        bank = bank,
        serverId = serverId,
        ammo = ammo,
        currentMagazine = currentMagazine,
        hasWeapon = hasWeapon,
        gangLabel = gangLabel,  
        gangGrade = gangGrade   
    })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 
        updateHUD()
    end
end)

local function updateHUDVisibility(visible)
    SendNUIMessage({
        action = 'toggleHUD',
        visible = visible
    })
end

local function isPauseMenuActive()
    return IsPauseMenuActive()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 

        local shouldShowHUD = not isPauseMenuActive()
        updateHUDVisibility(shouldShowHUD)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SendNUIMessage({
        action = 'playerLoaded'
    })

end)
