ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("usedTicket")
AddEventHandler("usedTicket", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("ticket", 1)

end)

RegisterServerEvent("buyticket")
AddEventHandler("buyticket", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() >= Config.TicketPrice then

        xPlayer.addInventoryItem(Config.NeededItem, 1)

        xPlayer.removeMoney(Config.TicketPrice)

        TriggerClientEvent("esx:showNotification", src,  "Du köpte en engångsbiljett")

    else
        TriggerClientEvent("esx:showNotification", src,  "Du har inte tillräckligt med pengar")

    end
    
end)