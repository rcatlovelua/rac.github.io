local Config = require(script.Parent.Parent.Config)

return function(player, hrp, hum, last, dt, LastSpawn)
	if not last then return false end

	-- Ignore checks immediately after spawn
	if not LastSpawn or not LastSpawn[player] then return false end
	if tick() - LastSpawn[player] < 2 then return false end

	-- Check if player is in the air
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	raycastParams.IgnoreWater = true
	
	local downRay = workspace:Raycast(hrp.Position, Vector3.new(0, -Config.GroundCheckDistance, 0), raycastParams)
	
	if not downRay then
		-- Player is in the air
		if not player._lastGroundedTime then
			player._lastGroundedTime = tick()
		end
		
		local airTime = tick() - player._lastGroundedTime
		
		-- Check if player is in the air for too long
		if airTime > Config.MaxAirTime then
			-- Additional check - is player moving upward
			local verticalVelocity = (hrp.Position.Y - last.Y) / dt
			
			-- Block only if player is moving upward or in the air for very long
			if verticalVelocity > 2 or airTime > Config.MaxAirTime + 2 then
				return true, "Fly detected (air time: " .. math.floor(airTime) .. "s, velocity: " .. math.floor(verticalVelocity) .. ")"
			end
		end
	else
		-- Player is on ground, reset timer
		player._lastGroundedTime = tick()
	end

	return false
end
