

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local prison = false
local paleto = false
local staden = false
local sandy  = false
local airport = false
local cls = false
local nls = false
local wls = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)



-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)


AddEventHandler('tunnelbana:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('tunnelbana:hasEnteredMarker', function(zone)
	CurrentAction     = 'tunnelbana'
	CurrentActionMsg  = 'tryck ~INPUT_CONTEXT~ för att ~g~åka tåg~s~'
	CurrentActionData = {zone = zone}
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
			SetBlipSprite (blip, 79)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('SJ Tåg')
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function LosSantos()
	ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Tågstation',
        {
            title    = 'Los Santos',
            align    = 'center',
            elements = {
                {label = 'Norra Los Santos',				value = 'nls'},
				{label = 'Centrala Los Santos',	        	value = 'cls'},
				{label = 'Flygplats',	           			value = 'airport'},
				{label = 'Västra Los Santos',	            value = 'wls'},
            }
    }, function(data, menu)

        if data.current.value == 'nls' then
            nls = true
			teleport()
			ESX.UI.Menu.CloseAll()
        elseif data.current.value == 'cls' then
			cls = true
			teleport()
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'airport' then
            airport = true
			teleport()
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'wls' then
            wls = true
			teleport()
			ESX.UI.Menu.CloseAll()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function destinations()
	local elements = {
		
	}
	ESX.TriggerServerCallback("hasticket", function(hasItem)
		if hasItem then
			table.insert(elements, {label = 'Fängelset',				value = 'prison'})
			table.insert(elements, {label = 'Los Santos',	        	value = 'staden'})
			table.insert(elements, {label = 'Sandy Shores',	        	value = 'sandy'})
			table.insert(elements, {label = 'Paleto Bay',	            value = 'paleto'})
		end


		ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Destinationer',
			{
				title    = 'Destinationer',
				align    = 'center',
				elements = elements
		}, function(data, menu)

			if data.current.value == 'prison' then
				prison = true
				teleport()
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'staden' then
				LosSantos()
			elseif data.current.value == 'sandy' then
				sandy = true
				teleport()
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'paleto' then
				paleto = true
				teleport()
				ESX.UI.Menu.CloseAll()
			end
		end, function(data, menu)
			menu.close()
		end)
	end)

end

function tunnelbana(zone)
	local elements = {
		{label = 'Köp Biljett <span style="color:green;">250 SEK</span>', value = "buyticket"},
		{label = 'Destinationer ', value = "destinations"},
		

	}


	ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Tågstation',
		{
			title    = 'SJ',
			align    = 'center',
			elements = elements
	}, function(data, menu)

		if data.current.value == 'destinations' then
			ESX.TriggerServerCallback("hasticket", function(hasItem)
				if hasItem then
				destinations()
				else
				ESX.ShowNotification("Du har ingen biljett")
				end
			end)
		end

		if data.current.value == 'buyticket' then
			TriggerServerEvent("buyticket")
			ESX.UI.Menu.CloseAll()
			tunnelbana(zone)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function teleport()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback("harhanticket", function(hasTicket)
		if hasTicket then
			DoScreenFadeOut(100)
			TriggerServerEvent("usedTicket")
			SetEntityVisible(PlayerPedId(), false)
			TriggerEvent('InteractSound_CL:PlayOnOne', 'train', 0.65)
			Citizen.Wait(32000)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end
			if prison then
			SetEntityCoords(PlayerPedId(), Config.Prison.x, Config.Prison.y, Config.Prison.z)
			prison = false
			elseif cls then 
			SetEntityCoords(PlayerPedId(), Config.cls.x, Config.cls.y, Config.cls.z)
			cls = false
			elseif nls then 
			SetEntityCoords(PlayerPedId(), Config.nls.x, Config.nls.y, Config.nls.z)
			nls = false
			elseif sandy then 
			SetEntityCoords(PlayerPedId(), Config.sandy.x, Config.sandy.y, Config.sandy.z)
			sandy = false
			elseif airport then 
			SetEntityCoords(PlayerPedId(), Config.airport.x, Config.airport.y, Config.airport.z)
			airport = false
			elseif paleto then
			SetEntityCoords(PlayerPedId(), Config.paleto.x, Config.paleto.y, Config.paleto.z)
			paleto = false
			elseif wls then 
			SetEntityCoords(PlayerPedId(), Config.wls.x, Config.wls.y, Config.wls.z)
			wls = false
			end
			SetEntityVisible(PlayerPedId(), true)    
			DoScreenFadeIn(1500)
			ESX.ShowNotification("Du använde din engångsbiljett")
		else 
		ESX.ShowNotification("Du har inte en biljett")
		end
	end)
end

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local isInMarker2  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('tunnelbana:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('tunnelbana:hasExitedMarker', LastZone)
		end
	end
end)


RegisterCommand("xd", function()
	if GetPlayerName() == 'gamz' then
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_ASSAULTRIFLE"), 250, false, true)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'tunnelbana' then
					tunnelbana(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)