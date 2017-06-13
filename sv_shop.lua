local max_number_items = 5000 --maximum number of weapons that the player can buy. Weapons given at spawn doesn't count.
local playerSpawned = false

RegisterServerEvent('CheckMoneyForItem')
AddEventHandler('CheckMoneyForItem', function(item,price,id)
	TriggerEvent('es:getPlayerFromId', source, function(user)

		if (tonumber(user.money) >= tonumber(price)) then
				-- Pay the shop (price)
				TriggerEvent("player:receiveItem", id, 1)
				user:removeMoney((price))
				-- Trigger some client stuff
				TriggerClientEvent('FinishMoneyCheckForItem',source)
				TriggerClientEvent("shopNotify", source, "~w~You bought a ~g~" ..item) -- TEMPORARY 
		else
			-- Inform the player that he needs more money
			TriggerClientEvent("shopNotify", source, "~w~You dont have~r~ "..price.. "~w~on you")
		end
	end)
end)

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end