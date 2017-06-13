local shop = {
	opened = false,
	title = "Item store",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{title = "Vehicle", name = "Vehicle", description = ""},
				{title = "Food", name = "Food", description = ""},
				{title = "Health", name = "Health", description = ""},
			}
		},
		["Vehicle"] = {
			title = "Vehicle",
			name = "Vehicle",
			buttons = {
				{title = "Repair kit", name = "Repair kit", costs = 5000, description = {}, model = 1},
				{title = "Fire extinguisher", name = "Fire extinguisher", costs = 10000, description = {}, model = 2},
				{title = "Tyre repair kit", name = "Tyre repair kit", costs = 10000, description = {}, model = 3},
			}
		},
		["Food"] = {
			title = "Food",
			name = "Food",
			buttons = {
				{title = "Apple", name = "Apple", costs = 500, description = {}, model = 20},
				{title = "Banana", name = "Banana", costs = 7000, description = {}, model = 21},
				{title = "Pizza", name = "Pizza", costs = 1000, description = {}, model = 22},
				{title = "Cereal", name = "Cereal", costs = 2000, description = {}, model = 23},
			}
		},
		["Health"] = {
			title = "Health",
			name = "Health",
			buttons = {
				{title = "Bandage", name = "Bandage", costs = 2000, description = {}, model = 30},
				{title = "Adrenaline", name = "Adrenaline", costs = 10500, description = {}, model = 31},
				{title = "Medkit", name = "MedKit", costs = 15000, description = {}, model = 32},
			}
		},
	}
}

local fakeitem = ''
local shop_locations = {
{entering = {-709.17022705078,-904.21722412109,19.215591430664}, inside = {-709.17022705078,-904.21722412109,19.215591430664}, outside = {-709.17022705078,-904.21722412109,19.215591430664}},
{entering = {28.463,-1353.033,9.340}, inside = {28.463,-1353.033,9.340}, outside = {28.463,-1353.033,9.340}},
{entering = {-54.937,-1759.108,29.005}, inside = {-54.937,-1759.108,29.005}, outside = {-54.937,-1759.108,29.005}},
{entering = {1143.813,-980.601,46.2171}, inside = {1136.84,-981.026,46.4158}, outside = {1143.813,-980.601,46.2171}},
{entering = {1695.284,4932.052,42.078}, inside = {1695.284,4932.052,42.078}, outside = {1695.284,4932.052,42.078}},
{entering = {2686.051,3281.089,55.241}, inside = {2686.051,3281.089,55.241}, outside = {2686.051,3281.089,55.241}},
{entering = {2563.86,386.072,108.463}, inside = {2557.84,382.94,108.623}, outside = {2563.86,386.072,108.463}},
}


local shop_blips ={}
local inrangeofshop = false
local currentlocation = nil
local boughtItem = false

local function LocalPed()
return GetPlayerPed(-1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfshop()
return inrangeofshop
end

function ShowShopBlips(bool)
	if bool and #shop_blips == 0 then
		for station,pos in pairs(shop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			SetBlipSprite(blip, 52)
			SetBlipColour(blip, 24)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Item Shop')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip, true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(shop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #shop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(shop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and shop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 10 then
						DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						drawTxt('Press ~g~ENTER~s~ to purchase ~b~items',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofshop = inrange
			end
		end)
	elseif bool == false and #shop_blips > 0 then
		for i,b in ipairs(shop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		shop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function LocalPed()
	return GetPlayerPed(-1)
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

--local veh = nil
function OpenCreator()
	boughtItem = false
	local ped = GetPlayerPed(-1)
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	shop.currentmenu = "main"
	shop.opened = true
	shop.selectedbutton = 0
end

function CloseCreator()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		if not boughtItem then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
			shop.opened = false
			shop.menu.from = 1
			shop.menu.to = 10
		else
			local pos = currentlocation.pos.entering
		end
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = shop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.title)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = shop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawMenuRight(txt,x,y,selected)
	local menu = shop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
local menu = shop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and IsPlayerInRangeOfshop() then
			if shop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if shop.opened then
			local ped = LocalPed()
			local menu = shop.menu[shop.currentmenu]
			drawTxt(shop.title,1,1,shop.menu.x,shop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, shop.menu.x,shop.menu.y + 0.08)
			drawTxt(shop.selectedbutton.."/"..tablelength(menu.buttons),0,0,shop.menu.x + shop.menu.width/2 - 0.0385,shop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = shop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= shop.menu.from and i <= shop.menu.to then

					if i == shop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,shop.menu.x,y,selected)
					if button.costs ~= nil then
						--DoesPlayerHaveWeapon(button.model,button,y,selected,ped)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end
		end
		if shop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if shop.selectedbutton > 1 then
					shop.selectedbutton = shop.selectedbutton -1
					if buttoncount > 10 and shop.selectedbutton < shop.menu.from then
						shop.menu.from = shop.menu.from -1
						shop.menu.to = shop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if shop.selectedbutton < buttoncount then
					shop.selectedbutton = shop.selectedbutton +1
					if buttoncount > 10 and shop.selectedbutton > shop.menu.to then
						shop.menu.to = shop.menu.to + 1
						shop.menu.from = shop.menu.from + 1
					end
				end
			end
		end

	end
end)

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = shop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicle" then
			OpenMenu('Vehicle')
		elseif btn == "Food" then
			OpenMenu('Food')
		elseif btn == "Health" then
			OpenMenu('Health')
		end
	else
		fakeItem = button.model
		TriggerServerEvent('CheckMoneyForItem',button.name,button.costs,button.model)
	end
end

RegisterNetEvent('shopNotify')
AddEventHandler('shopNotify', function(alert)
            Notify(alert)
end)

RegisterNetEvent('FinishMoneyCheckForItem')
AddEventHandler('FinishMoneyCheckForItem', function()
	boughtItem = true
	CloseCreator()
end)

RegisterNetEvent('ToManyItems')
AddEventHandler('ToManyItems', function()
	boughtItem = false
	CloseCreator()
end)

function OpenMenu(menu)
	shop.lastmenu = shop.currentmenu
	shop.menu.from = 1
	shop.menu.to = 10
	shop.selectedbutton = 0
	shop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if shop.currentmenu == "main" then
		boughtItem = false
		CloseCreator()
	else
		OpenMenu(shop.lastmenu)
	end

end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local playerSpawned = true
local firstspawn = 0
local playerSpawning = false
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	ShowShopBlips(true)
	firstspawn = 1
end
--TriggerServerEvent("shop:playerSpawned", spawn)
end)

