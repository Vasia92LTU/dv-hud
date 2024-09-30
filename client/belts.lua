local isUiOpen = false
local speedBuffer = {}
local velBuffer = {}
local SeatbeltON = false
local InVehicle = false
 


RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', 'B')
RegisterCommand("seatbelt", function()
    SeatbeltON = not SeatbeltON
    if SeatbeltON then
        Citizen.Wait(1)
        TriggerEvent('seatbelt:client:ToggleSeatbelt', SeatbeltON)
        isUiOpen = true
    else
        TriggerEvent('seatbelt:client:ToggleSeatbelt', SeatbeltON)
        isUiOpen = true
    end
end)

function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

 
Citizen.CreateThread(function()
    local timer = 1000
    while true do
        Citizen.Wait(timer)
        local ped = PlayerPedId()
        local car = GetVehiclePedIsIn(ped)
        if car ~= 0 and (InVehicle or IsCar(car)) then
            timer = 10
            InVehicle = true
            if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                TriggerEvent('seatbelt:client:ToggleSeatbelt', SeatbeltON)
                isUiOpen = true
            end
            if SeatbeltON then
                DisableControlAction(0, 75, true) -- Disable exit vehicle when stop
                DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
            end
            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)
            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)
            if not SeatbeltON and speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and
                speedBuffer[2] > (100 / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.555) then
                local co = GetEntityCoords(ped)
                local fw = Fwv(ped)
                SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                SetEntityVelocity(ped, velBuffer.x, velBuffer.y, velBuffer.z)
                Citizen.Wait(1)
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
            end
        elseif InVehicle then
            InVehicle = false
            SeatbeltON = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                TriggerEvent('seatbelt:client:ToggleSeatbelt', SeatbeltON)
                isUiOpen = false
            end
            timer = 1000
        end
    end
end)
