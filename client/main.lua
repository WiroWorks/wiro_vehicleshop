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

local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}

ESX                           = nil

local playerDatas = {}
local blips = {}


Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)

	blips = RemoveCreateBlips(blips)

end)

function RemoveCreateBlips(blips)
	if blips ~= nil then
		for k, v in pairs(blips) do
			RemoveBlip(v)
			blips[k] = AddBlipForCoord(info.x, info.y, info.z)
		end
	end
	blips = {}

	
	ESX.TriggerServerCallback('esx_vehicleshop:getVehicleShopsData', function (datas)

		for k,v in pairs(Config.Markers) do
			if v.blip ~= nil then
				name = v.blip.text
				if v.requestJob ~= nil then
					for l, b in pairs(datas) do
						if b.jobName == v.requestJob then
							name = b.name
							break
						end
					end
				end
				if v.requestDealer == nil or string.sub(ESX.GetPlayerData().job.name, 1, 6) == v.requestDealer then
					blips[k] = AddBlipForCoord(v.coords)
					SetBlipSprite(blips[k], v.blip.sprite)
					SetBlipDisplay(blips[k], 4)
					SetBlipScale(blips[k], v.blip.scale)
					SetBlipColour(blips[k], v.blip.color)
					SetBlipAsShortRange(blips[k], true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(name)
					EndTextCommandSetBlipName(blips[k])
				end
			end
		end
		return blips
	end)

end


RegisterNetEvent('wiro_vehicleShop:getPlayerDatas')
AddEventHandler('wiro_vehicleShop:getPlayerDatas', function (datas)
	playerDatas = datas
end)

function getFullName()
	fName = nil
	ESX.TriggerServerCallback("wiro_vehicleShop:fullName", function(cb)
		fName = cb
	end)
	while fName == nil do
		Citizen.Wait(200)
	end
	return fName
end

-- markers

coord = nil
other = nil
draw = false
check = true
currentMarkerId = nil
CreateThread(function()
    while true do
        Citizen.Wait(2000)
        while check do
            Citizen.Wait(200)
            local pos = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Config.Markers) do
                if (#(v.coords - pos) < 5) then
					currentMarkerId = k
                    coord = v.coords
					other = v.other
                    draw = false
					if v.requestJob == nil or v.requestDealer == string.sub(ESX.GetPlayerData().job.name, 1, 6) or v.requestJob == ESX.GetPlayerData().job.name then
						draw = true
						check = false
					end
				end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(3000)
        while draw do
            Citizen.Wait(1)
            if (#(coord - GetEntityCoords(PlayerPedId())) < 2) then
                drawMarkerr(coord.x, coord.y, coord.z, other)
				showMessageTopLeft(Config.Markers[currentMarkerId].message)
                if IsControlJustPressed(0, 38) then
                    onMarkerClick(currentMarkerId)
                end
            elseif (#(coord - GetEntityCoords(PlayerPedId())) < 10.0) then
                drawMarkerr(coord.x, coord.y, coord.z, other)
            else
				currentMarkerId = nil
                check = true
				other = nil
                draw = false
                coords = nil
            end
        end
    end
end)

function drawMarkerr(x, y, z, other)
	DrawMarker(25, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, other.size.x, other.size.y, other.size.z, other.rgb.r, other.rgb.g, other.rgb.b, other.rgb.a, false, false, 2, false, false, false, false)
end

function onMarkerClick(id)
	if id == 1 then
		OpenShopMenu()
	elseif id == 2 then
		SetEntityCoords(PlayerPedId(), Config.Markers[3].coords.x, Config.Markers[3].coords.y, Config.Markers[3].coords.z, true, true, true, false)
	elseif id == 3 then 
		SetEntityCoords(PlayerPedId(), Config.Markers[2].coords.x, Config.Markers[2].coords.y, Config.Markers[2].coords.z, true, true, true, false)
	elseif id == 4 then
		isTestRideOn = false
		TestRideClockAndAlert(testRideVehicle, true)
	elseif id == 5 then
		OpenBuyableVehicleShopsMenu()
	elseif id ==6 then
		OpenTakeableCarsMenu()
	else
		OpenVehicleShopUI()
	end
end

-- markers

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(1)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

function TestRideClockAndAlert(vehicle, stop)
	Citizen.CreateThread(function()
		local isTestRideOn = true
		if stop then
			isTestRideOn = false
			StopTestRide(vehicle)
		end
		testRideTime = Config.TestRide.time
		while isTestRideOn do
			Citizen.Wait(5000)
			testRideTime = testRideTime - 5
			if #(Config.Markers[4].coords - GetEntityCoords(PlayerPedId())) < Config.TestRide.alertMessageRadius then
				exports['mythic_notify']:DoHudText('Inform', Config.Language.keepYourDistance)
			elseif #(Config.Markers[4].coords - GetEntityCoords(PlayerPedId())) < Config.TestRide.stopTestRideRadius then
				exports['mythic_notify']:DoHudText('Inform', Config.Language.maxDistance)
			else
				StopTestRide(vehicle)
				isTestRideOn = false
			end
			if testRideTime <= 0 then
				StopTestRide(vehicle)
				isTestRideOn = false
			end
		end
	end)
end

local isTestRideOn = false
local testRideVehicle = nil
local testRideTime = Config.TestRide.time

function StartTestRide(vehicleHash)
	testRideTime = Config.TestRide.time
	SetEntityCoords(PlayerPedId(), Config.Markers[4].coords, true, true, true, false)

	ESX.Game.SpawnVehicle(vehicleHash, Config.Markers[4].coords, 360.0, function (vehicle)
		exports['mythic_notify']:DoHudText('Inform', string.format(Config.Language.timeLimit, Config.TestRide.time))
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		isTestRideOn = true
		testRideVehicle = vehicle
		TestRideClockAndAlert(vehicle)
		if not Config.TestRide.canExitCar then
			SetVehicleDoorsLocked(vehicle, 4)
		end
	end)
end

function StopTestRide(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	if isTestRideOn then
		isTestRideOn = false
		testRideTime = Config.TestRide.time
		testRideVehicle = nil
		SetEntityCoords(PlayerPedId(), Config.Markers[1].coords, true, true, true, false)
	end
end

function OpenShopMenu()
	ESX.TriggerServerCallback('wiro_vehicleShop:getPlayerDatasServer', function(cb)
		local color1 = nil
		local color2 = nil
		local color1Name = nil
		canBuy = false
		if cb == "boss" or cb.VP == 1 then
			canBuy = true
		end
		IsInShopMenu = true

		StartShopRestriction()
		ESX.UI.Menu.CloseAll()

		local playerPed = PlayerPedId()

		FreezeEntityPosition(playerPed, true)
		SetEntityVisible(playerPed, false)
		SetEntityCoords(playerPed, Config.Markers[1].coords.x, Config.Markers[1].coords.y, Config.Markers[1].coords.z)

		local vehiclesByCategory = {}
		local elements           = {}
		local firstVehicleData   = nil

		for i=1, #Categories, 1 do
			vehiclesByCategory[Categories[i].name] = {}
		end

		for i=1, #Vehicles, 1 do
			if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
				table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
			else
				print(('esx_vehicleshop: vehicle "%s" does not exist'):format(Vehicles[i].model))
			end
		end

		for i=1, #Categories, 1 do
			local category         = Categories[i]
			local categoryVehicles = vehiclesByCategory[category.name]
			local options          = {}

			for j=1, #categoryVehicles, 1 do
				local vehicle = categoryVehicles[j]

				if i == 1 and j == 1 then
					firstVehicleData = vehicle
				end

				table.insert(options, vehicle.name)
			end

			table.insert(elements, {
				name    = category.name,
				label   = category.label,
				value   = 0,
				type    = 'slider',
				max     = #Categories[i],
				options = options
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
			title    = Config.Language.vehicles,
			align    = 'top-left',
			elements = elements
		}, function (data, menu)
			local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
			local insideMenu = {}
			if canBuy then
				table.insert(insideMenu, {label = vehicleData.name .. " " .. Config.Language.price .. ESX.Math.GroupDigits(vehicleData.price) .. "$", value ="buy"})
			end
			if Config.TestRide.enable then
				table.insert(insideMenu, {label = Config.Language.testRide, value ="testRide"})
			end
			table.insert(insideMenu, {label = "Back", value = "back"})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = vehicleData.name .. " - " .. color1Name,
				align = 'top-left',
				elements = insideMenu
			}, function(data2, menu2)
				if data2.current.value == "buy" then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zaza', {
						title = Config.Language.sure,
						align = 'top-left',
						elements = {
							{label = Config.Language.yes, value = "yes"},
							{label = Config.Language.no, value = "no"}
						}
					}, function(data3, menu3)
						if data3.current.value == "yes" then
							--try to buy

								
							job = ESX.GetPlayerData().job.name

							for i=1, #Config.vehicleShops, 1 do
								cVehicleShop = Config.vehicleShops[i]
								if cVehicleShop.jobName == job then
									plate1 = GeneratePlate()
									ESX.TriggerServerCallback('wiro_vehicleShop:tryToBuyVehicle', function(cb)
										if cb == "buyed" then
											
											DeleteShopInsideVehicles()
											FreezeEntityPosition(PlayerPedId(), false)
											SetEntityVisible(PlayerPedId(), true)
											menu3.close()
											menu2.close()
											menu.close()
											IsInShopMenu = false
											exports['mythic_notify']:DoHudText('Success', Config.Language.carBuyed)

											

											if Config.BetterBank then
												TriggerServerEvent('BetterBank:addTransactionsDB', FindIBANFromJob(ESX.GetPlayerData().job.name), Config.Language.vehicle, "$" .. numWithCommas(tostring(vehicleData.price)) .. ",00", nil, vehicleData.model .. " - " .. plate1 , "fa-regular fa-car", "red", vehicleData.price)
											end
										elseif cb == "companyMoney" then
											exports['mythic_notify']:DoHudText('Error', Config.Language.notEnoghtMoney)
										elseif cb == "userMoney" then
											exports['mythic_notify']:DoHudText('Error', Config.Language.notEnoghtMoneyPlayer)
										else
											exports['mythic_notify']:DoHudText('Error', Config.Language.noStock)
										end
									end, vehicleData.model, vehicleData.price, cVehicleShop.IBAN, plate1, color1, color2)
								
								end
							end
							

						elseif data3.current.value == "no" then
							menu3.close()
						end
					end, function (data3, menu3)
						menu3.close()
					end)
				elseif data2.current.value == "testRide" then
					menu2.close()
					menu.close()
					DeleteShopInsideVehicles()
					FreezeEntityPosition(PlayerPedId(), false)
					SetEntityVisible(PlayerPedId(), true)
					IsInShopMenu = false
					StartTestRide(GetHashKey(vehicleData.model))
				elseif data2.current.value == "back" then
					menu2.close()
				end
			end, function (data2, menu2)
				menu2.close()
			end)
		end, function (data, menu)
			menu.close()
			DeleteShopInsideVehicles()
			local playerPed = PlayerPedId()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = "shopmenuuu"
			CurrentActionData = {}

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Markers[1].coords.x, Config.Markers[1].coords.y, Config.Markers[1].coords.z)

			IsInShopMenu = false
		end, function (data, menu)
			local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
			local playerPed   = PlayerPedId()

			DeleteShopInsideVehicles()
			WaitForVehicleToLoad(vehicleData.model)

			ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Markers[1].coords, 360.0, function (vehicle)
				color1 , color2  = GetVehicleColours(vehicle)
				color1Name = Config.ColorNames[color1]
				table.insert(LastVehicles, vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(vehicleData.model)
			end)
		end)

		DeleteShopInsideVehicles()
	end)
end

function OpenBuyableVehicleShopsMenu()
	ESX.TriggerServerCallback('wiro_vehicleShop:getPlayerDatasServer', function(cb)
		if cb ~= "boss" then
			ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('wiro_vehicleShop:returnBuyableVehicleShops', function(cb)
				shopsBuyable = {}
				for i=1, #cb, 1 do
					currentPrice = 0
					currentJobName = ""
					for k=1, #Config.vehicleShops, 1 do
						cV = Config.vehicleShops[k]
						if cV.deafultName == cb[i].name then
							currentPrice = cV.buyPrice
							currentId = k
						end
					end
					table.insert(shopsBuyable, {label = cb[i].name, value = "buy", value2 = currentPrice, value3 = currentId})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zazaza', {
					title = Config.Language.buyableShops,
					align = 'top-left',
					elements = shopsBuyable
				}, function(data3, menu3)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zazazaza', {
						title = Config.Language.sure,
						align = 'top-left',
						elements = {
							{label = Config.Language.price .. data3.current.value2, value="yes"},
							{label = Config.Language.back, value="back"},
						}
					}, function(data4, menu4)
						if data4.current.value == "yes" then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zazazazaza', {
								title = Config.Language.sure,
								align = 'top-left',
								elements = {
									{label = Config.Language.yes, value="yes"},
									{label = Config.Language.no, value="no"},
								}
							}, function(data5, menu5)
								if data5.current.value == "yes" then
									ESX.TriggerServerCallback('wiro_vehicleShop:tryToBuyVehicleShop', function(cb)
									if cb == "yes" then
										menu5.close()
										menu4.close()
										menu3.close()
										RemoveCreateBlips(blips)
									else

									end
									end, data3.current.value3)
								else
									menu5.close()
								end
							end, function (data5, menu5)
								menu5.close()
							end)
						else
							menu4.close()
						end
					end, function (data4, menu4)
						menu4.close()
					end)
				end, function (data3, menu3)
					menu3.close()
				end)

			end)
		else	
			exports['mythic_notify']:DoHudText('Inform', Config.Language.youAreDealer)
		end
	end)
end

function OpenTakeableCarsMenu()
	ESX.TriggerServerCallback('wiro_vehicleShop:getPlayerDatasServer', function(cb)
		if cb == "boss" or cb.VD == 1 then
			ESX.TriggerServerCallback('wiro_vehicleShop:getTakeableVehicles', function(cb2)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'yarss', {
					title = "take vehicle",
					align = 'top-left',
					elements = cb2
				}, function(data, menu)
					if data.current.value =="car" then
						
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'khkhkhs', {
							title = Config.Language.sure,
							align = 'top-left',
							elements = {
								{label = Config.Language.yes, value="yes"},
								{label = Config.Language.no, value="no"},
							}
						}, function(data2, menu2)
							if data2.current.value == "yes" then
								-- try to get vehicle
								ESX.TriggerServerCallback('wiro_vehicleShop:tryToGetVehicleFromFactory', function(cb3)
									if cb3 == "yes" then
										local spawnPoint = {}
										for i=1, #Config.factoryVehicleSpawns, 1 do
											if ESX.Game.IsSpawnPointClear(Config.factoryVehicleSpawns[i].coord, 1.0) then
												spawnPoint = Config.factoryVehicleSpawns[i]
												break
											end
										end
										if spawnPoint ~= {} then
											ESX.Game.SpawnVehicle(data.current.value2, spawnPoint.coord, spawnPoint.heading, function (vehicle)
												SetVehicleColours(vehicle, data.current.value3, data.current.value6)
												SetVehicleNumberPlateText(vehicle, data.current.value5)
												SetModelAsNoLongerNeeded(data.current.value2)
												TriggerServerEvent("wiro_vehicleShop:createOwnedVehicle", data.current.value5, json.encode(ESX.Game.GetVehicleProperties(vehicle)))
											end)
										end
										menu2.close()
										menu.close()
									else
										print("error")
									end
								end, data.current.value4)
							else
								menu2.close()
							end
						end, function (data2, menu2)
							menu2.close()
						end)
						
					end
				end, function (data, menu)
					menu.close()
				end)
			end)
		else
			exports['mythic_notify']:DoHudText('Inform', Config.Language.noPermission)
		end
	end)
end

function Display()
	ESX.TriggerServerCallback('wiro_vehicleShop:getPlayerDatasServer', function(cb)
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = "ui",
			fullName = getFullName(),
			permissions = cb,
			betterBank = Config.BetterBank
		})
		SendDatas()
	end)
end

function CloseUI()
	SendNUIMessage({
		type = "close"
	})
end

function SendDatas()
	local t = {h = GetClockHours(), m = GetClockMinutes()}
	ESX.TriggerServerCallback("wiro_vehicleShop:returnDatas", function(cb)
		SendNUIMessage({
			type = "setupUI",
			grade = ESX.GetPlayerData().job.grade,
			time = t,
			datas = cb
		})
	end)
end

RegisterNUICallback('companyName', function(data)
	TriggerServerEvent('wiro_vehicleShop:ChangeCompanyName', data.name, ESX.GetPlayerData().job.name, FindIBANFromJob(ESX.GetPlayerData().job.name))
	RemoveCreateBlips(blips)
end)

RegisterNUICallback('editEmployee', function(data)
	TriggerServerEvent('wiro_vehicleShop:EditEmployee', data, ESX.GetPlayerData().job.name)
end)

RegisterNUICallback('resell', function()
	if ESX.GetPlayerData().job.grade == 1 then
		SetNuiFocus(false, false)
		TriggerServerEvent('wiro_vehicleShop:resellVehicleShop')
		RemoveCreateBlips(blips)
		currentMarkerId = nil
		check = true
		other = nil
		draw = false
		coords = nil
	end
end)

RegisterNUICallback('sendClosestPlayers', function()
	dadada = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
	players = {}
	for i=1, #dadada, 1 do
		table.insert(players, GetPlayerServerId(dadada[i]))
	end
	ESX.TriggerServerCallback('wiro_vehicleShop:ReturnPlayersDataa', function(cb)
		SendNUIMessage({
			type = "closestPlayers",
			players = cb
		})
	end, players)
	
end)

RegisterNUICallback('tryToHire', function(data)
	ESX.TriggerServerCallback('wiro_vehicleShop:tryToHire', function(cb)
		if cb ~= false then
			SendDatas()
			sendUINotify(Config.Language.success)
		else	
			sendUINotify(Config.Language.error)
		end

	end, data.id, ESX.GetPlayerData().job.name)
end)

RegisterNUICallback('tryToFire', function(data)
	TriggerServerEvent("wiro_vehicleShop:tryToFire", data.identifier, ESX.GetPlayerData().job.name)
end)

RegisterNUICallback('createBill', function(data)
	ESX.TriggerServerCallback('wiro_vehicleShop:tryToCreateBill', function(cb)
		if cb == true then
			SendDatas()
			sendUINotify(Config.Language.success)
		else	
			sendUINotify(Config.Language.error)
		end

	end, data, FindIBANFromJob(ESX.GetPlayerData().job.name))
end)

RegisterNUICallback('companyBank', function(data)
	SetNuiFocus(false, false)
	TriggerEvent('BetterBank:CompanyBankOpener', FindIBANFromJob(ESX.GetPlayerData().job.name))
end)


function OpenVehicleShopUI() 
	Display()
end

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
end)

function sendUINotify(text)
	SendNUIMessage({
		type = "notify",
		text = text
	})
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(Config.Language.vehicleLoading)
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end

function showMessageTopLeft(message)
	SetTextComponentFormat('STRING')
	AddTextComponentString(message)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function FindIBANFromJob(job)
	for i=1, #Config.vehicleShops, 1 do
		if Config.vehicleShops[i].jobName == job then	
			return Config.vehicleShops[i].IBAN
		end
	end
end

function FindResellFromJob(job)
	for i=1, #Config.vehicleShops, 1 do
		if Config.vehicleShops[i].jobName == job then	
			return Config.vehicleShops[i].resellPrice
		end
	end
end

function numWithCommas(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1."):gsub(".(%-?)$","%1"):reverse()
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()
			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Markers[1].coords.x, Config.Markers[1].coords.y, Config.Markers[1].coords.z)
		end
	end
end)
Citizen.CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

RegisterCommand('canset', function(source, args, raw)
	print(args[1])
	SetEntityHealth(PlayerPedId(), tonumber(args[1]))
end)