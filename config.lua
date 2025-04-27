Config = {}

-- General Settings
Config.CooldownTime = 320 -- Cooldown between robberies in seconds
Config.NotifyType = 'ox-lib' -- 'ox-lib' or 'rsg-core'

-- Distance Settings
Config.MaxTargetDistance = 10.0 -- Maximum distance to see the rob option
Config.EscapeDistance = 5.0 -- Distance at which victim can escape robbery

-- Weapon Check Settings
Config.RequireWeapon = true -- Require player to have a weapon to rob
Config.WeaponNotifyCooldown = 5000 -- Time in ms between weapon notification to prevent spam

-- Blacklisted Items (cannot be stolen)  --- noit sure if working 
Config.BlacklistedItems = {
    -- Revolvers
    "weapon_revolver_cattleman",
   
}

-- Notification Messages
Config.Messages = {
    robberyCooldown = "You must wait %s seconds before pickpocketing again",
    needWeapon = "You need a weapon to pickpocket someone!",
    victimAlert = "You are being pickpocketed!",
    robberySuccess = "pickpocket successful!",
    robberyFailed = "pickpocket failed!",
    victimEscaped = "The victim got away!",
    escapeSuccess = "You escaped the pickpocket!",
    blacklistedItem = "You cannot steal this item!"
}

-- Notification Display Settings
Config.NotifyDuration = {
    short = 3000,
    normal = 5000
}

-- Function to show notifications based on configured type
Config.Notify = function(source, title, message, type, duration)
    if Config.NotifyType == 'ox-lib' then
        TriggerClientEvent('ox-lib:notify', source, {
            title = title,
            description = message,
            type = type,
            position = 'top',
            duration = duration
        })
    elseif Config.NotifyType == 'rsg-core' then
        local RSGCore = exports['rsg-core']:GetCoreObject()
        if source then
            local Player = RSGCore.Functions.GetPlayer(source)
            if Player then
                TriggerClientEvent('RSGCore:Notify', source, message, type, duration)
            end
        end
    end
end