local ChangedRecently = false
local SpeedDivider = nil
if MPH then
SpeedDivider = 2.237
else
SpeedDivider = 3.6
end

Citizen.CreateThread(function()
 while true do
  if IsPedInAnyVehicle(PlayerPedId(),false) then
    local MaxSpeed = 99999.0
    local NeedToChange = false
    local cords = GetEntityCoords(PlayerPedId(),true)
    for _,v in pairs(Zones) do

			local distance = GetDistanceBetweenCoords(cords.x,cords.y,cords.z,v.x,v.y,v.z,v.UseZ)
			
			if distance < v.distance then
			
			NeedToChange = true
			MaxSpeed = v.LimitSpeed/SpeedDivider
			
			
			end
			
    end	
	if NeedToChange then
          SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(),false),MaxSpeed)
	  ChangedRecently = true
        elseif NeedToChange and ChangedRecently then -- Sending Notification Only Once!
        notifyenter(MaxSpeed)
	elseif ChangedRecently then  -- Only Changing The Max Speed When its Needed To Not Interfere With Other Max Speed Limitation Scripts
	  ChangedRecently = false
	  SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(),false),MaxSpeed)
    end	  
  end
 Wait(500)
 end
end)

function notifyenter (speed)
	SetNotificationTextEntry('STRING')
	AddTextComponentString('~b~ You Have Entered ~r~Speed Limit Area ~b~. Your Current Vehicle Speed is Limited To ~r~' .. tostring(speed))
	DrawNotification(0,1)
end
