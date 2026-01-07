local Config = require(script.Parent.Parent.Config)

local SpawnIgnoreTime = 2.5      -- time when Speed check is ignored after spawn

return function(player, hrp, hum, last, dt, LastSpawn)
	if not last or dt <= 0 then return false end

	-- Ignore checks immediately after spawn
	if not LastSpawn[player] then
		LastSpawn[player] = os.clock()
		return false
	end
	if os.clock() - LastSpawn[player] < SpawnIgnoreTime then
		return false
	end

	-- Ignore falling / jumping / sitting
	local state = hum:GetState()
	if state == Enum.HumanoidStateType.Freefall
		or state == Enum.HumanoidStateType.FallingDown
		or state == Enum.HumanoidStateType.Landed
		or state == Enum.HumanoidStateType.Seated then
		return false
	end

	local delta = hrp.Position - last
	local distance = delta.Magnitude

	-- Ignore teleports (SetCFrame / spawn / checkpoint)
	if distance > Config.MaxTeleportDistance then
		return false
	end

	-- Ignore tiny movements (noise)
	if distance < 0.2 then
		return false
	end

	-- Calculate speed
	local speed = distance / dt
	if speed > Config.SpeedLimit then
		return true, "Speed detected (" .. math.floor(speed) .. ")"
	end

	return false
end
