ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	for i= 1, #Config.vehicleShops, 1 do
		local vehicleShop = Config.vehicleShops[i]
		if Config.BetterBank then
			TriggerEvent("Betterbank:tryToCreateIBANForCompany", vehicleShop.deafultName, vehicleShop.IBAN, 0)
		end
		MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM vehicleshops WHERE jobName = @jobName', {
			['@jobName'] = vehicleShop.jobName,
		}, function(result)
			if result[1].count ~= nil then
				if result[1].count == 0 then
					MySQL.Async.fetchAll("INSERT INTO vehicleshops (jobName, name, IBAN) VALUES(@jobName, @name, @iban)",{
						['@jobName'] = vehicleShop.jobName,
						['@name'] = vehicleShop.deafultName,
						['@iban'] = vehicleShop.IBAN,
					})
				end
			else
				print("error : wiro_vehicleshop")
			end
		end)
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)

end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
	end)
end)

RegisterServerEvent('wiro_vehicleShop:ChangeCompanyName')
AddEventHandler('wiro_vehicleShop:ChangeCompanyName', function (name, job, IBAN)
	MySQL.Async.insert("UPDATE vehicleshops SET name = '"..name.."' WHERE jobName = '"..job.."'")
	if Config.BetterBank then
		MySQL.Async.insert("UPDATE betterbankcompanies SET fullName = '"..name.."' WHERE IBAN = '"..IBAN.."'")
	end
end)

RegisterServerEvent('wiro_vehicleShop:EditEmployee')
AddEventHandler('wiro_vehicleShop:EditEmployee', function (data, job)
	result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '"..job.."'")
	jsonn = json.decode(result[1].employees)
	jsonn[data.identifier][data.name] = data.check
	MySQL.Async.insert("UPDATE vehicleshops SET employees = '"..json.encode(jsonn).."' WHERE jobName = '"..job.."'")
	
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicleShopsData', function (source, cb)
	data = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops")
	cb(data)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:tryToCreateBill', function (source, cb, data, senderIBAN)
	xClient = ESX.GetPlayerFromId(source)
	xTarget = ESX.GetPlayerFromId(data.targetId)
	if xTarget ~= nil then
		dataClient = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = '" .. xClient.identifier .. "'")[1]
		dataTarget = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = '" .. xTarget.identifier .. "'")[1]
		targetName = dataTarget.firstname .. " " .. dataTarget.lastname
		clientName = dataClient.firstname .. " " .. dataClient.lastname
		tomorrowSameTime = os.time(os.date('*t'))
		time = os.date("%Y-%m-%d %H:%M:%S", tomorrowSameTime)
		MySQL.Async.insert("UPDATE vehicleshopcars SET billPayerName = '".. targetName .. "', billDate = '".. time .."', billAmount = ".. data.amount ..", billText = '"..data.label.."', billCreatorName = '"..clientName.."'  WHERE id = '"..data.carId.."'")
		if Config.BetterBank then
			TriggerEvent("Betterbank:createBillWithIBANS", dataTarget.IBAN, senderIBAN, targetName, data.vehicleShopName, data.label, tonumber(data.amount))
		end
		local result = MySQL.Sync.fetchAll('SELECT * FROM vehicleshopcars WHERE id= '..data.carId..'')
		MySQL.Async.insert("UPDATE owned_vehicles SET owner='"..xTarget.identifier.."' WHERE plate = '"..result[1].carPlate.."'")
		
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('wiro_vehicleShop:ReturnPlayersDataa', function (source, cb, players)
	xClient = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users")
	playerDatas = {}
	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		if xPlayer ~= nil and xPlayer.identifier ~= xClient.identifier then
			k = FindKeyWithIdentifier(result, xPlayer.identifier)
			table.insert(playerDatas, {id=players[i], identifier = xPlayer.identifier, fullName = result[k].firstname .. " " .. result[k].lastname})
		end
	end
	cb(playerDatas)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:tryToHire', function (source, cb, player, jobName)
	xTarget = ESX.GetPlayerFromId(player)
	if xTarget ~= nil then
		xTarget.setJob(jobName, 0)
		local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '"..jobName.."'")
		employees = json.decode(result[1].employees)
		player = MySQL.Sync.fetchAll("SELECT firstname,lastname FROM users WHERE identifier = '".. xTarget.identifier.."'")
		employees[xTarget.identifier] = {name=player[1].firstname .. " " .. player[1].lastname,VD=false,VP=false,AC=false,SV=false}
		MySQL.Async.insert("UPDATE vehicleshops SET employees = '"..json.encode(employees).."' WHERE jobName = '"..jobName.."'")
		cb({identifier = xTarget.identifier, fullName = player[1].firstname .. " " .. player[1].lastname})
	else 
		cb(false)
	end	
end)

RegisterServerEvent('wiro_vehicleShop:tryToFire')
AddEventHandler('wiro_vehicleShop:tryToFire', function (identifier, jobName)
	xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if xTarget ~= nil then
		xTarget.setJob("unemployed", 0)
	else 
		MySQL.Async.insert("UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = '"..identifier.."'")
	end	
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '"..jobName.."'")
	employees = json.decode(result[1].employees)
	employees[identifier] = nil
	MySQL.Async.insert("UPDATE vehicleshops SET employees = '"..json.encode(employees).."' WHERE jobName = '"..jobName.."'")	
end)

RegisterServerEvent('wiro_vehicleShop:resellVehicleShop')
AddEventHandler('wiro_vehicleShop:resellVehicleShop', function ()
	_source = source
	local vehicleShopDeafult = {}
	xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #Config.vehicleShops, 1 do
		if Config.vehicleShops[i].jobName == xPlayer.getJob().name then	
			vehicleShopDeafult = Config.vehicleShops[i]
			break
		end
	end
	xPlayer.setJob("unemployed", 0)
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '"..vehicleShopDeafult.jobName.."'")
	MySQL.Async.insert("UPDATE vehicleshops SET name = '".. vehicleShopDeafult.deafultName .."', ownerIdentifier = '', employees = '{}' WHERE jobName = '"..vehicleShopDeafult.jobName.."'")
	MySQL.Async.insert("DELETE FROM vehicleshopcars WHERE vehicleShopId="..result[1].id.."")
	xPlayer.addAccountMoney('bank', vehicleShopDeafult.resellPrice)
end)

RegisterServerEvent('wiro_vehicleShop:createOwnedVehicle')
AddEventHandler('wiro_vehicleShop:createOwnedVehicle', function (plate, vehicle)
	_source = source 
	xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES(@a, @b, @c)",{
		['@a'] = xPlayer.identifier,
		['@b'] = plate,
		['@c'] = vehicle
	})
end)

function FindKeyWithIdentifier( t, value )
	for k,v in pairs(t) do
	  if v.identifier==value then return k end
	end
	return nil
  end

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function (source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if xPlayer.getMoney() >= vehicleData.price then
		xPlayer.removeMoney(vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:returnDatas', function (source, cb)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '"..xPlayer.job.name.."'")
	local datas = {name = "", employees = {}, cars = {}}
	datas.name = result[1].name
	datas.employees = json.decode(result[1].employees)
	result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshopcars WHERE vehicleShopId = "..result[1].id.." ORDER BY billDate DESC")
	for i=1, #result, 1 do
		local value = result[i]
		if IsTakeable(value.carTakeableDate) then
			result[i].canTake = 1
		else
			result[i].canTake = 0
		end
		if value.isCarTaken == 1 then
			result[i].canTake = 2
		end
		if value.billPayerName ~= nil then
			result[i].canTake = 3
		end
		result[i].colorName = Config.ColorNames[result[i].carColor]
		if value.billDate ~= nil then
			time = os.date("%Y-%m-%d %H:%M:%S", tostring(value.billDate):sub(1, 10))
			result[i].billDate = time
		end
	end
	datas.cars = result
	cb(datas)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:fullName', function (source, cb)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = '" .. xPlayer.identifier .. "'")
	cb(result[1].firstname .. " " .. result[1].lastname)
end)

function GetPlayerDatas(source)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	for i= 1, #Config.vehicleShops, 1 do
		local vehicleShop = Config.vehicleShops[i]
		if vehicleShop.jobName == xPlayer.job.name then
			if xPlayer.job.grade == 1 then
				return "boss"
			else
				local result = MySQL.Sync.fetchAll('SELECT * FROM vehicleshops')
				for i=1, #result, 1 do
					employees = json.decode(result[i].employees)
					if employees[xPlayer.identifier] ~= nil then
						return employees[xPlayer.identifier]
					end
				end
			end	
		end
	end
	return "no"
end

ESX.RegisterServerCallback('wiro_vehicleShop:getPlayerDatasServer', function (source, cb)
	cb(GetPlayerDatas(source))
end)

ESX.RegisterServerCallback('wiro_vehicleShop:returnBuyableVehicleShops', function (source, cb)
	_source = source
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE ownerIdentifier = ''")
	cb(result)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:tryToBuyVehicle', function (source, cb, vehicleModel, vehiclePrice, IBAN, plate, color, color2)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	job = xPlayer.job.name
	if Config.BetterBank then
		companyBalance = GetCompanyBalance(IBAN)
	else
		companyBalance = xPlayer.getAccount('bank').money
	end
	stock = GetVehicleStock(vehicleModel)
	
	if stock > 0 then
		if vehiclePrice <= companyBalance then
			--buy
			DeleteOneStock(vehicleModel)

			if Config.BetterBank then
				SetCompanyBalance(IBAN, companyBalance - vehiclePrice)
			else
				xPlayer.removeAccountMoney('bank', vehiclePrice)
			end
			
			tomorrowSameTime = os.time(os.date('*t')) + (math.random(Config.minCarFactoryHour, Config.maxCarFactoryHour) * 3600)
			time = os.date("%Y-%m-%d %H:%M:%S", tomorrowSameTime)
			
			local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '" .. job .. "'")
			MySQL.Async.fetchAll("INSERT INTO vehicleshopcars (vehicleShopId, carName, carPlate, carColor, carColor2, carTakeableDate, factoryPrice) VALUES(@a, @b, @c, @d, @e, @f, @g)",{
				['@a'] = result[1].id,
				['@b'] = vehicleModel,
				['@c'] = plate,
				['@d'] = color,
				['@e'] = color2,
				['@f'] = time,
				['@g'] = vehiclePrice
			})
			cb("buyed")
		else	
			if Config.BetterBank then
				cb("companyMoney")
			else
				cb("userMoney")
			end
		end
	else
		cb("noStock")
	end
	
end)

ESX.RegisterServerCallback('wiro_vehicleShop:tryToBuyVehicleShop', function (source, cb, id)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshops WHERE jobName = '".. Config.vehicleShops[id].jobName .."'")
	if result[1].ownerIdentifier == "" and xPlayer.getAccount('bank').money >= Config.vehicleShops[id].buyPrice then
		xPlayer.removeAccountMoney('bank', Config.vehicleShops[id].buyPrice)
		MySQL.Async.insert("UPDATE vehicleshops SET ownerIdentifier = @identifier, employees = '{}' WHERE jobName = @name", { 
			['@identifier'] = xPlayer.identifier,
			['@name'] =  Config.vehicleShops[id].jobName
		})
		xPlayer.setJob(Config.vehicleShops[id].jobName, 1)
		cb("yes")
	end
	cb("no")
end)

ESX.RegisterServerCallback('wiro_vehicleShop:getTakeableVehicles', function (source, cb)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshopcars WHERE isCarTaken = 0 AND vehicleShopId = " .. getVehicleShopIdFromJob(xPlayer.job.name))
	data = {}
	for k,v in pairs(result) do
		if IsTakeable(v.carTakeableDate) then
			table.insert(data, {label = v.carName .. " - " .. v.carPlate .. " - " .. Config.ColorNames[v.carColor], value="car", value2 = v.carName, value3 = v.carColor, value4 = v.id, value5 = v.carPlate, value6 = v.carColor2})
		end
	end
	cb(data)
end)

ESX.RegisterServerCallback('wiro_vehicleShop:tryToGetVehicleFromFactory', function (source, cb, id)
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicleshopcars WHERE id = " .. id)
	if result[1].isCarTaken == 0 then
		MySQL.Async.insert("UPDATE vehicleshopcars SET isCarTaken = 1 WHERE id = " .. id)
		cb("yes")
	else	
		cb("no")
	end
end)

function GetVehicleStock(model) 
	local result = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE model = '" .. model .. "'")
	return result[1].stock
end

function DeleteOneStock(model)
	newStock = GetVehicleStock(model) - 1
	MySQL.Async.insert("UPDATE vehicles SET stock = @stock WHERE model = @model", { 
		['@stock'] = newStock,
		['@model'] = model
	})
end

function GetCompanyBalance(IBAN)
	local result = MySQL.Sync.fetchAll('SELECT moneyAmount FROM betterbankcompanies WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	})
	return result[1].moneyAmount
end

function SetCompanyBalance(IBAN, amount)
	MySQL.Async.insert("UPDATE betterbankcompanies SET moneyAmount = @M WHERE IBAN = @IBAN", { 
		['@IBAN'] = IBAN,
		['@M'] = amount
	})
end

function IsTakeable(date)
	x = date - os.time(os.date('*t')) * 1000
	if x <= 0 then
		return true
	else
		return false
	end
end

function getVehicleShopIdFromJob(jobName)
	local result = MySQL.Sync.fetchAll("SELECT id FROM vehicleshops WHERE jobName = '".. jobName .. "'")
	return result[1].id
end