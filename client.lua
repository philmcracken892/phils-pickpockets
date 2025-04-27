local RSGCore = exports['rsg-core']:GetCoreObject()
local isRobbing = false
local lastRobberyTime = 0
local currentVictim = nil
local distanceCheckActive = false 
local lastWeaponNotifyTime = 0 


Citizen.CreateThread(function()
    exports['rsg-target']:AddGlobalPlayer({
        options = {
            {
                label = 'Rob',
                icon = 'fas fa-mask',
                canInteract = function(entity)
                   
                    if (GetGameTimer() - lastRobberyTime) < (Config.CooldownTime * 1000) then
                        return false
                    end
                    
                    
                    if Config.RequireWeapon then
                        local hasWeapon = false
                        local ped = PlayerPedId()
                        
                        
                        if Citizen.InvokeNative(0x8425C5F057012DAB, ped) ~= GetHashKey("WEAPON_UNARMED") then
                            hasWeapon = true
                        end
                        
                        if not hasWeapon then
                            -
                            local currentTime = GetGameTimer()
                            if (currentTime - lastWeaponNotifyTime) > Config.WeaponNotifyCooldown then
                                lib.notify({
                                    title = 'ROBBERY',
                                    description = Config.Messages.needWeapon,
                                    type = 'error',
                                    position = 'top',
                                    duration = Config.NotifyDuration.short
                                })
                                lastWeaponNotifyTime = currentTime
                            end
                            return false
                        end
                    end
                    
                    return true
                end,
                action = function(entity)
                    local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                    currentVictim = entity 
                    TriggerServerEvent('phils-pickpocket:server:startRobbery', targetId)
					TriggerServerEvent('rsg-lawman:server:lawmanAlert', 'Pickpockets in town!')
                end
            }
        },
        distance = Config.MaxTargetDistance
    })
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        
        if distanceCheckActive and currentVictim then
           
            local playerPos = GetEntityCoords(PlayerPedId())
            local victimPos = GetEntityCoords(currentVictim)
            local distance = #(playerPos - victimPos)
            
            
            if distance > Config.EscapeDistance then
                TriggerServerEvent('phils-pickpocket:server:cancelRobbery')
                distanceCheckActive = false
                currentVictim = nil
                
                lib.notify({
                    title = 'ROBBERY',
                    description = Config.Messages.victimEscaped,
                    type = 'error',
                    position = 'top',
                    duration = Config.NotifyDuration.normal
                })
            end
        else
            Citizen.Wait(1000) 
        end
    end
end)


RegisterNetEvent('phils-pickpocket:client:notifyVictim')
AddEventHandler('phils-pickpocket:client:notifyVictim', function()
    lib.notify({
        title = 'ROBBERY ALERT',
        description = Config.Messages.victimAlert,
        type = 'error',
        position = 'top',
        duration = Config.NotifyDuration.normal
    })
end)


RegisterNetEvent('phils-pickpocket:client:notifyRobber')
AddEventHandler('phils-pickpocket:client:notifyRobber', function(success)
    if success then
        lib.notify({
            title = 'ROBBERY',
            description = Config.Messages.robberySuccess,
            type = 'success',
            position = 'top',
            duration = Config.NotifyDuration.normal
        })
        
        lastRobberyTime = GetGameTimer()
        
        distanceCheckActive = true
    else
        lib.notify({
            title = 'ROBBERY',
            description = Config.Messages.robberyFailed,
            type = 'error',
            position = 'top',
            duration = Config.NotifyDuration.normal
        })
    end
end)


RegisterNetEvent('phils-pickpocket:client:endRobbery')
AddEventHandler('phils-pickpocket:client:endRobbery', function()
    distanceCheckActive = false
    currentVictim = nil
end)


RegisterNetEvent('phils-pickpocket:client:notifyCooldown')
AddEventHandler('phils-pickpocket:client:notifyCooldown', function(timeLeft)
    lib.notify({
        title = 'ROBBERY',
        description = string.format(Config.Messages.robberyCooldown, timeLeft),
        type = 'error',
        position = 'top',
        duration = Config.NotifyDuration.short
    })
end)