--Readme from the roblox file

-----------------------------------------------Content-------------------------------------------------
--[[
RAC - Rcat's Anti-Cheat System
================================

OVERVIEW:
--------
RAC is a comprehensive server-side anti-cheat system designed to detect and prevent
common exploits in Roblox games. It uses modular detection checks and provides
detailed logging and warning systems.

FEATURES:
---------
• Speed Hack Detection - Detects abnormal movement speeds
• Fly Hack Detection - Detects unauthorized flying
• Teleport Detection - Detects instant position changes
• NoClip Detection - Detects wall clipping
• BTools Detection - Detects building tools
• Warning System - Visual warnings before kicks
• Detailed Logging - Comprehensive detection logging
• Admin Exclusions - Whitelist system for administrators

CONFIGURATION:
-------------
Edit ServerScriptService.RAC.main.Config to customize:

• Enabled: Enable/disable the entire system
• SpeedLimit: Maximum allowed speed (studs/sec)
• MaxTeleportDistance: Maximum teleport distance
• MaxAirTime: Maximum time allowed in air
• KickOnDetect: Auto-kick on detection
• WarnBeforeKick: Issue warnings before kicking
• MaxWarnings: Number of warnings before kick
• ExcludedPlayers: List of admin usernames

ADMIN COMMANDS:
---------------
Admins (listed in ExcludedPlayers) can use:
• /racstats - View anti-cheat statistics

DETECTION MODULES:
------------------
Each detection type is a separate module in Checks folder:
• Speed - Movement speed monitoring
• Fly - Flight detection using raycasting
• Teleport - Position change monitoring
• NoClip - Wall clipping detection
• BTools - Building tool detection

TROUBLESHOOTING:
---------------
• False Positives: Adjust thresholds in Config
• Performance: Disable unused checks in EnabledChecks
• Logging: Check console output for detection details
• Warnings: Ensure RACWarningGUI is in StarterPlayerScripts

SECURITY NOTES:
--------------
• This is server-side only (more secure than client-side)
• Client-side anti-cheats can be bypassed
• Regular updates recommended for new exploit methods
• Monitor logs for new cheat patterns

UPDATING:
--------------
If you see an icon on the file? Place your mouse over it and if you see "Package update available" click RIGHT MOUSE and find "Get Latest Package"
and click "Get Latest"

VERSION: 1.0
AUTHOR: rcc stu
LAST UPDATED: 2026-01-06

For support, check the detection logs and adjust configuration as needed.

Documentation:
https://rcatlovelua.github.io/rac.github.io/
Source Code:
https://github.com/rcatlovelua/rac.github.io

btw this and on github and in toolbox
]]
