Config = {}

Config.Debug = true -- Enable debug mode

Config.Framework = "QB" -- ESX or QB

Config.DefconRanks = { -- Rank required to access the /defcon command
    ["police"] = {3, 4}, -- Define the required ranks for police
    ["sheriff"] = {3, 4}, -- Define the required ranks for sheriff
}

Config.DefconColors = { -- Colors associated with each DEFCON
    [1] = "rgba(0, 255, 0, 0.8)", -- Green for DEFCON 1 (The mildest)
    [2] = "rgba(255, 255, 0, 0.8)", -- Yellow for DEFCON 2
    [3] = "rgba(255, 165, 0, 0.8)", -- Orange for DEFCON 3
    [4] = "rgba(255, 69, 0, 0.8)", -- Red for DEFCON 4
    [5] = "rgba(255, 0, 0, 0.8)", -- More intense red for DEFCON 5 (The most dangerous)
}

Config.Messages = {
    NoPermission = "You do not have permission to use this command.",
    NoPermissionChange = "You do not have permission to change the DEFCON.",
    NoPermissionClear = "You do not have permission to clear the DEFCON.",
    NoActiveDEFCON = "There is no active DEFCON. Are you a bit slow?",
    DEFCONDeactivated = "Police Announcement: DEFCON has been deactivated. The streets return to normal.",
    DEFCONActivated = "Police Announcement: DEFCON ",
    BeCareful = " has been set. Be very careful on the streets."
}

Config.MenuTitle = "Set DEFCON"
Config.MenuHeaders = {
    DEFCON1 = "🟢 DEFCON 1 (The mildest)",
    DEFCON2 = "🟡 DEFCON 2",
    DEFCON3 = "🔶 DEFCON 3",
    DEFCON4 = "🔴 DEFCON 4",
    DEFCON5 = "⚠️ DEFCON 5 (The most dangerous)",
    RemoveDEFCON = "❌ Remove DEFCON"
}