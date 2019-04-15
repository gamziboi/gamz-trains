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

        TriggerClientEvent("esx:showNotification", src,  "You bought a ticket")

    else
        TriggerClientEvent("esx:showNotification", src,  "You don't have enough money")

    end
    
end)
