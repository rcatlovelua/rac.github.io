return function(player, hrp, lastPos, dt, config)
	if not lastPos or dt <= 0 then return false end

	local dist = (hrp.Position - lastPos).Magnitude
	local maxDist = config.MaxTeleportDistance
	
	-- Allow larger distances when falling (realistic physics)
	local humanoid = hrp.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		maxDist = maxDist * 2
	end
	
	-- Check if teleportation is too fast
	if dist > maxDist and dt < 0.5 then
		return true, "Teleport Hack (" .. math.floor(dist) .. " studs)"
	end

	return false
end
