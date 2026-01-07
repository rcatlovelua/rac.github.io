return function(player, hrp, lastPos, dt, config)
	-- Check player's backpack for suspicious tools
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return false end
	
	local suspiciousTools = {}
	
	for _, item in ipairs(backpack:GetChildren()) do
		if item:IsA("HopperBin") then
			table.insert(suspiciousTools, item.Name)
		elseif item:IsA("Tool") then
			-- Check for tools with suspicious names or properties
			if string.lower(item.Name):find("btool") or 
			   string.lower(item.Name):find("build") or
			   string.lower(item.Name):find("delete") or
			   string.lower(item.Name):find("copy") then
				table.insert(suspiciousTools, item.Name)
			end
		end
	end
	
	-- Also check character for equipped tools
	local character = player.Character
	if character then
		for _, item in ipairs(character:GetChildren()) do
			if item:IsA("HopperBin") then
				table.insert(suspiciousTools, item.Name .. " (equipped)")
			end
		end
	end
	
	if #suspiciousTools > 0 then
		return true, "BTools detected: " .. table.concat(suspiciousTools, ", ")
	end
	
	return false
end
