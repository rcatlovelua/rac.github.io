local Config = require(script.Parent.Parent.Config)

return function(player, hrp, hum, last, dt, LastSpawn)
	if not last or not hrp or not hum then return false end

	-- Ignore checks immediately after spawn
	if not LastSpawn or not LastSpawn[player] then return false end
	if tick() - LastSpawn[player] < 3 then return false end

	-- Ignore if player is dead or not moving
	if hum.Health <= 0 then return false end
	
	local dir = hrp.Position - last
	if dir.Magnitude < 0.5 then
		return false
	end

	-- Create raycast parameters
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { player.Character }
	params.IgnoreWater = true

	-- Main check - if there was a wall between previous and current position
	local result = workspace:Raycast(last, dir, params)
	if result and result.Instance and result.Instance.CanCollide then
		-- Additional check - did the player actually pass through the wall
		local distanceToWall = (result.Position - last).Magnitude
		local totalDistance = dir.Magnitude
		
		-- If wall was in the way and player moved past it
		if distanceToWall < totalDistance * 0.8 then -- Allow some tolerance
			return true, "NoClip detected (passed through wall)"
		end
	end

	-- Additional check - if player is inside a wall
	local checkDistance = 2 -- Increased check distance for better detection
	local rays = {
		workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * checkDistance, params),
		workspace:Raycast(hrp.Position, -hrp.CFrame.LookVector * checkDistance, params),
		workspace:Raycast(hrp.Position, hrp.CFrame.RightVector * checkDistance, params),
		workspace:Raycast(hrp.Position, -hrp.CFrame.RightVector * checkDistance, params),
		workspace:Raycast(hrp.Position, Vector3.new(0, 1, 0) * checkDistance, params),
		workspace:Raycast(hrp.Position, Vector3.new(0, -1, 0) * checkDistance, params)
	}

	local wallCount = 0
	for _, ray in pairs(rays) do
		if ray and ray.Instance and ray.Instance.CanCollide then
			wallCount = wallCount + 1
		end
	end

	-- If player is surrounded by walls (4+ directions for more accuracy)
	if wallCount >= 4 then
		return true, "NoClip detected (inside walls: " .. wallCount .. ")"
	end

	-- Additional check: verify player is on ground when expected
	local groundCheck = workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0), params)
	if not groundCheck and hum.MoveDirection.Magnitude > 0.1 then
		-- Player is in air but moving horizontally - possible flying
		-- This is handled by the Fly check, so we'll be more lenient here
	end

	return false
end
