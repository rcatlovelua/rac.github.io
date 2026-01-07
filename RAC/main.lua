local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load configuration
local Config = require(script.Config)

-- Load check modules
local Checks = {}
for _, checkName in pairs(Config.EnabledChecks) do
	local success, checkModule = pcall(require, script.Checks:FindFirstChild(checkName))
	if success then
		Checks[checkName] = checkModule
		print("[RAC] Loaded check:", checkName)
	else
		warn("[RAC] Failed to load check:", checkName)
	end
end

-- Player tracking data
local PlayerData = {}
local LastSpawn = {}

local function isExcluded(player)
	for _, name in pairs(Config.ExcludedPlayers) do
		if player.Name == name then
			return true
		end
	end
	return false
end

local function setupPlayer(player)
	if isExcluded(player) then
		print("[RAC] Player excluded from anti-cheat:", player.Name)
		return
	end

	player.CharacterAdded:Connect(function(character)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		local humanoid = character:WaitForChild("Humanoid")
		
		-- Wait for character to be fully loaded
		task.wait(2)
		
		PlayerData[player] = {
			lastPosition = humanoidRootPart.Position,
			violations = 0,
			lastWarning = 0
		}
		
		LastSpawn[player] = tick()
		
		print("[RAC] Started monitoring player:", player.Name)
		
		local connection
		connection = RunService.Heartbeat:Connect(function(deltaTime)
			if not character.Parent then
				connection:Disconnect()
				return
			end
			
			if deltaTime <= 0 then return end
			
			local data = PlayerData[player]
			if not data then return end
			
			local currentPosition = humanoidRootPart.Position
			
			-- Run all enabled checks
			for checkName, checkFunction in pairs(Checks) do
				local detected, reason = checkFunction(player, humanoidRootPart, humanoid, data.lastPosition, deltaTime, LastSpawn)
				
				if detected then
					data.violations = data.violations + 1
					
					if Config.Debug then
						print("[RAC] VIOLATION - Player:", player.Name, "Check:", checkName, "Reason:", reason)
					end
					
					if _G.RACLogger then
						_G.RACLogger.LogDetection(player, checkName .. ": " .. reason, {
							check = checkName,
							violations = data.violations
						})
					end
					
					-- Handle violations
					if Config.KickOnDetect then
						player:Kick("Anti-cheat violation: " .. reason)
						print("[RAC] Kicked player:", player.Name, "Reason:", reason)
						connection:Disconnect()
						return
					elseif Config.WarnBeforeKick then
						local now = tick()
						if now - data.lastWarning > Config.WarningCooldown then
							data.lastWarning = now
							-- You can add warning GUI here if needed
							print("[RAC] Warning player:", player.Name, "Violations:", data.violations)
						end
						
						if data.violations >= Config.MaxWarnings then
							player:Kick("Too many anti-cheat violations")
							print("[RAC] Kicked player for excessive violations:", player.Name)
							connection:Disconnect()
							return
						end
					end
					
					-- Reset position on violation
					humanoidRootPart.Position = data.lastPosition
					break
				end
			end
			
			data.lastPosition = currentPosition
		end)
	end)
end

-- Setup for existing players
for _, player in pairs(Players:GetPlayers()) do
	setupPlayer(player)
end

-- Setup for new players
Players.PlayerAdded:Connect(setupPlayer)

print("[RAC] Anti-Cheat System Initialized")
print("Enabled checks:", table.concat(Config.EnabledChecks, ", "))
print("Speed limit:", Config.SpeedLimit, "studs/sec")
print("Max air time:", Config.MaxAirTime, "seconds")
