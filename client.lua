------------ This script is wrote by TRASHLORD. Generally is writen for my server "LionSquadRP", but you still can use it if you like it. Also its open sourced. ---------------------
-- When you start this script, start it after pNotify script, because it can glitch or don't show safezones. --
-- in server.cfg should look like this : --
-- start pNotify --
-- start safezones --

-- Change the coords here down for your zones
local zones = {
	{ ['x'] = -1037.54, ['y'] = -2737.27, ['z'] = 20.17 }, -- spawnpoint(airport)
	{ ['x'] = -265.0, ['y'] = -963.59, ['z'] = 31.22 }, -- job center
	{ ['x'] = 309.89, ['y'] = -592.94, ['z'] = 43.29 }, -- hospital
	{ ['x'] = 230.78, ['y'] = -795.92, ['z'] = 30.74 }, -- central garage location (for jb_eden_garage)
	{ ['x'] = -40.7, ['y'] = -1095.44, ['z'] = 26.42 }, -- car dealer
	{ ['x'] = 13.38, ['y'] = -1094.4, ['z'] = 29.8 }, -- ammunation near to car dealer
	{ ['x'] = 890.85, ['y'] = -167.69, ['z'] = 74.7 }, -- taxi job location
	{ ['x'] = -339.66, ['y'] = -136.59, ['z'] = 39.01 } -- los santos mechanic
}

local notifIn = false
local notifOut = false
local closestZone = 1


----------------   Getting your distance from any one of the locations  --------------------------------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

---------   The notify when you enter the zone / currently using other script "pNotify"   -----------------

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 30.0 then -- how much to be the radius
			if not notifIn then
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#1E90FF'>Ти си в Синя Зона</b>",
					type = "success",
					timeout = (3000),
					layout = "bottomcenter",
					queue = "global"
				})
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				notifOut = true
				notifIn = false
		end
		if notifIn then
			end
		end
		-- This DrawMarker is for debug, to see where is your zone located, if you want to use it, just remove "--" down here.
	 	if DoesEntityExist(player) then		-- Keep in mind to change also 60.0 and 60.0 to more if you change your distance (dist) at line 55. Example if you put 50.0 in if dist, then you need to put 100.0 100.0. Just replace it.
	 		DrawMarker(1, zones[closestZone].x, zones[closestZone].y, zones[closestZone].z-1.0001, 0, 0, 0, 0, 0, 0, 60.0, 60.0, 2.0, 13, 232, 255, 155, 0, 0, 2, 0, 0, 0, 0)
	 	end
	end
end)