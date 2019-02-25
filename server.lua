ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback("hasticket", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ticket = xPlayer.getInventoryItem('ticket').count

   
    if ticket > 0 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("usedTicket")
AddEventHandler("usedTicket", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("ticket", 1)

end)

ESX.RegisterServerCallback("harhanticket", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ticket = xPlayer.getInventoryItem('ticket').count

    if ticket > 0 then
        cb(true)
    else 
        cb(false) 
    end
end)

RegisterServerEvent("buyticket")
AddEventHandler("buyticket", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

    if xPlayer.getMoney() >= 250 then
        xPlayer.addInventoryItem("ticket", 1)
        xPlayer.removeMoney("250")
        TriggerClientEvent("esx:showNotification", _source,  "Du köpte en engångsbiljett")
    else
        TriggerClientEvent("esx:showNotification", _source,  "Du har inte tillräckligt med pengar")

    end
end)