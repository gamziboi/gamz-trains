
ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	    
end)


Citizen.CreateThread(function()
	while true do

		local sleepTime = 500

		for k , v in pairs(Config.Pos) do
			
			local coords = GetEntityCoords(PlayerPedId())
			local dst = GetDistanceBetweenCoords(coords, v.Coords.x, v.Coords.y, v.Coords.z, true)
			
			if dst <= 7.5 then
				sleepTime = 5
				
				local displayText = v.label

				if dst <= 1.25 then
					displayText = "[~r~E~w~] " .. v.label

					if IsControlJustReleased(0, 38) then
						TrainMenu(v)
					end
				end

				Marker(v.Coords.x, v.Coords.y, v.Coords.z, displayText)
			end

		end
		Citizen.Wait(sleepTime)

	end
end)

Draw3DText = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  
	local scale = (1/dist)*1
	local fov = (1/GetGameplayCamFov())*100
	local scale = 1.9
    
	if onScreen then
	    	SetTextScale(0.0*scale, 0.18*scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370

		DrawRect(_x,_y+0.0115, 0.01+ factor, 0.025, 35, 35, 35, 155)

	end
 end
 

Marker = function(x, y, z, text, type)
	if type == nil then
		type = 25
	end

	Draw3DText(x, y, z, text)
	DrawMarker(type, x, y, z - 0.98, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 2.0, 55, 175, 55, 100, false, true, 2, false, false, false, false)
end

Citizen.CreateThread(function()

	for k,v in pairs(Config.Pos) do
		
		local blip = AddBlipForCoord(v.Coords.x, v.Coords.y)
		SetBlipSprite (blip, 79)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 38)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.label)
		EndTextCommandSetBlipName(blip)
	end
end)

Destinations = function(destination)

	local elements = {}

	for k , v in pairs(Config.Pos) do
		table.insert(elements, {["label"] = v.label})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Destinations",
	{
		title    = destination["label"],
		align    = 'center',
		elements = elements
	}, function(data, menu)

		menu.close()

	   	teleport(destination)
	   
    	end, function(data, menu)
        menu.close()
    	end)
end



TrainMenu = function(destination)

	local elements = {
		{ ["label"] = 'Buy ticket - $' .. Config.TicketPrice, ["value"] = "buyticket"},
		{ ["label"] = 'Destinations ', ["value"] = "destinations"}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Trains",
	{
		title    = destination["label"],
		align    = 'center',
		elements = elements
	}, function(data, menu)

		local value = data.current.value

		if value == 'destinations' then
			if hasItem(Config.NeededItem) then
				menu.close()
				Destinations(destination)
			else
				ESX.ShowNotification("You have no ticket")
			end

		elseif value == 'buyticket' then
			
			TriggerServerEvent("buyticket", Config.TicketPrice)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

LoadModel = function(obj)
	RequestModel(obj)

	while not HasModelLoaded(obj) do
	    Citizen.Wait(5)
	end
 end

teleport = function(destination)

	if hasItem(Config.NeededItem) then

		DoScreenFadeOut(100)

		Citizen.Wait(100)

		TriggerServerEvent("usedTicket")

		SetEntityVisible(PlayerPedId(), false)

		TriggerEvent('InteractSound_CL:PlayOnOne', 'train', 0.65)

		SetEntityCoords(PlayerPedId(), destination["Coords"])

		Citizen.Wait(32000)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		
		SetEntityVisible(PlayerPedId(), true)

		DoScreenFadeIn(1500)
		
		ESX.ShowNotification("You traveled to " .. destination["label"])
	else 
		ESX.ShowNotification("You don't have a train ticket.")
	end

end


hasItem = function(item)
	local inventory = ESX.GetPlayerData()["inventory"]

	for i = 1, #inventory do
		if inventory[i]["name"] == item then
			if inventory[i]["count"] >= 1 then
				return true
			else
				return false
			end
		end
	end

end
