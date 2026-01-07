local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Config = require(script.Parent.main:WaitForChild("Config"))

-- Create logging system
local DetectionLog = {}
local SessionStats = {
	TotalDetections = 0,
	PlayersKicked = 0,
	StartTime = os.time()
}

local function formatTimestamp(timestamp)
	return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

local function logToFile(data)
	-- In production, you might send this to a DataStore or external service
	print("[RAC LOG]", HttpService:JSONEncode(data))
end

local function createDetectionReport()
	local report = {
		SessionStats = SessionStats,
		RecentDetections = table.move(DetectionLog, 1, math.min(10, #DetectionLog), 1, {}),
		Timestamp = os.time()
	}
	
	return report
end

-- Expose logging functions globally for other scripts
_G.RACLogger = {
	LogDetection = function(player, reason, details)
		local entry = {
			timestamp = os.time(),
			player = player.Name,
			userId = player.UserId,
			reason = reason,
			details = details or {}
		}
		
		table.insert(DetectionLog, entry)
		SessionStats.TotalDetections = SessionStats.TotalDetections + 1
		
		-- Keep only last 100 entries to prevent memory issues
		if #DetectionLog > 100 then
			table.remove(DetectionLog, 1)
		end
		
		logToFile(entry)
	end,
	
	LogKick = function(player, reason)
		SessionStats.PlayersKicked = SessionStats.PlayersKicked + 1
		_G.RACLogger.LogDetection(player, "KICKED: " .. reason, {action = "kick"})
	end,
	
	GetReport = createDetectionReport,
	
	PrintStats = function()
		print("=== RAC Session Statistics ===")
		print("Session Duration:", math.floor((os.time() - SessionStats.StartTime) / 60), "minutes")
		print("Total Detections:", SessionStats.TotalDetections)
		print("Players Kicked:", SessionStats.PlayersKicked)
		print("Current Players:", #Players:GetPlayers())
		print("==============================")
	end
}

-- Auto-print stats every 5 minutes
spawn(function()
	while wait(300) do -- 5 minutes
		_G.RACLogger.PrintStats()
	end
end)

print("[RAC] Logger initialized")

-- Admin command to view stats
game.Players.PlayerAdded:Connect(function(player)
	for _, adminName in ipairs(Config.ExcludedPlayers) do
		if player.Name == adminName then
			player.Chatted:Connect(function(message)
				if message:lower() == "/racstats" then
					local report = _G.RACLogger.GetReport()
					print("[RAC] Stats requested by", player.Name)
					_G.RACLogger.PrintStats()
				end
			end)
			break
		end
	end
end)

return "RAC Logger initialized"
