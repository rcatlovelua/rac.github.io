--Module script
return {
	Enabled = true,
	Debug = true,
	LogToFile = true,

	-- Detection thresholds
	SpeedLimit = 70, -- studs/sec (increased for legitimate gameplay)
	MaxTeleportDistance = 100, -- studs (more reasonable)
	MaxAirTime = 3, -- seconds
	GroundCheckDistance = 10,
	RaycastDistance = 2,

	-- Actions
	KickOnDetect = true,
	WarnBeforeKick = true,
	MaxWarnings = 3,
	WarningCooldown = 30, -- seconds

	-- Exclusions
	ExcludedPlayers = {
		"rcat_legend",
		"tankruru"
	},

	-- Whitelisted tools (if any)
	AllowedTools = {},

	-- Detection modules to enable
	EnabledChecks = {
		"Speed",
		"Fly", 
		"Teleport",
		"NoClip",
		"BTools"
	}
}
