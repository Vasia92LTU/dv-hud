-- Load the config file
local Config = Config  -- The shared_scripts loads this automatically

local belts = false

RegisterNetEvent('seatbelt:client:ToggleSeatbelt')
AddEventHandler('seatbelt:client:ToggleSeatbelt', function(state)
    belts = state
end)

-- Adjust the SendNUIMessage part in your main Lua script to include the speed unit
Citizen.CreateThread(function()
    local timer = 2000
    while true do
        Citizen.Wait(timer)
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleEngineOn(veh, true, true, true)
        if veh ~= 0 and GetIsVehicleEngineRunning(veh) == 1 then
            timer = 100
            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) or visible == true then
                local data = {}
                local speed = GetEntitySpeed(veh)

                -- Convert speed based on config setting
                if Config.SpeedUnit == "mph" then
                    data.Speed = speed * 2.236936  -- MPH conversion
                    data.Unit = "MPH"  -- Set unit as MPH
                else
                    data.Speed = speed * 3.6  -- KM/H conversion
                    data.Unit = "KM/H"  -- Set unit as KM/H
                end

                -- Other data collection
                data.MaxSpeed = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveMaxFlatVel")
                data.rpm = GetVehicleCurrentRpm(veh)
                data.gear = GetVehicleCurrentGear(veh)
                data.Fuel = GetVehicleFuelLevel(veh)
                data.Rpm = GetVehicleCurrentRpm(veh)
                data.Damage = GetEntityHealth(veh)
                data.MaxDamage = GetEntityMaxHealth(veh)
                local _, lights, _ = GetVehicleLightsState(veh)
                data.Lights = lights
                data.Lock = GetVehicleDoorLockStatus(veh)
                local Damage_Percentage2 = (data.Damage / data.MaxDamage) * 100
                local Damage_Percentage = 100 - Damage_Percentage2
                if Damage_Percentage > 60 then
                    SetEntityMaxSpeed(veh, (data.MaxSpeed / 7))
                end
                data.Belts = belts
                visible = true

                -- Send data with speed unit to NUI
                SendNUIMessage({ action = "show", data = data })
            else
                timer = 2000
                SendNUIMessage({ action = "hide" })
            end
        else
            timer = 2000
            SendNUIMessage({ action = "hide" })
            visible = true
        end
    end
end)

