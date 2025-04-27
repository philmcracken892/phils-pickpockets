local RSGCore = exports['rsg-core']:GetCoreObject()
local robberyList = {}
local activeRobberies = {} 




RegisterNetEvent('phils-pickpocket:server:startRobbery')
AddEventHandler('phils-pickpocket:server:startRobbery', function(targetId)
    local src = source
    local robber = RSGCore.Functions.GetPlayer(src)
    local victim = RSGCore.Functions.GetPlayer(targetId)
    
    if not robber or not victim then
        return 
    end
    
    
    if robberyList[src] then
        local currentTime = os.time()
        local timeElapsed = currentTime - robberyList[src]
        
        if timeElapsed < Config.CooldownTime then
            local timeLeft = Config.CooldownTime - timeElapsed
            TriggerClientEvent('phils-pickpocket:client:notifyCooldown', src, timeLeft)
            return
        end
    end
    
    
    TriggerClientEvent('phils-pickpocket:client:notifyVictim', targetId)
    
    
    exports['rsg-inventory']:OpenInventoryById(src, tonumber(targetId))
    
    
    activeRobberies[src] = {
        victim = targetId,
        startTime = os.time()
    }
    
   
    TriggerClientEvent('phils-pickpocket:client:notifyRobber', src, true)
    
   
    robberyList[src] = os.time()
end)


RegisterNetEvent('phils-pickpocket:server:cancelRobbery')
AddEventHandler('phils-pickpocket:server:cancelRobbery', function()
    local src = source
    
    if activeRobberies[src] then
       
        exports['rsg-inventory']:CloseInventory(src)
        
        
        local victim = activeRobberies[src].victim
        TriggerClientEvent('ox-lib:notify', victim, {
            title = 'ROBBERY',
            description = Config.Messages.escapeSuccess,
            type = 'success',
            position = 'top',
            duration = Config.NotifyDuration.normal
        })
        
       
        activeRobberies[src] = nil
    end
end)


RegisterNetEvent('rsg-inventory:server:inventoryClosed')
AddEventHandler('rsg-inventory:server:inventoryClosed', function(source)
    local src = source
    
    if activeRobberies[src] then
        
        TriggerClientEvent('phils-pickpocket:client:endRobbery', src)
        
   
        activeRobberies[src] = nil
    end
end)


RegisterNetEvent('rsg-inventory:server:transferItem')
AddEventHandler('rsg-inventory:server:transferItem', function(item, amount, fromInventory, toInventory)
    
    for _, blacklistedItem in ipairs(Config.BlacklistedItems) do
        if item.name == blacklistedItem then
           
            local src = source
            TriggerClientEvent('ox-lib:notify', src, {
                title = 'ROBBERY',
                description = Config.Messages.blacklistedItem,
                type = 'error',
                position = 'top',
                duration = Config.NotifyDuration.short
            })
            
           
            return false
        end
    end
    
   
end)