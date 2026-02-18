-- Tsunami Brainrot Hub - Main Loader
-- GitHub: [username]/Tsunami-Brainrot-Hub

-- Load Configuration
local Config = loadstring(game:HttpGet("raw_url_github/features/_config.lua"))()

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Validate Game
if game.PlaceId ~= Config.GamePlaceId then
    Rayfield:Notify({
        Title = "❌ Wrong Game",
        Content = "This script is for Escape Tsunami For Brainrot only!",
        Duration = 5
    })
    return
end

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = Config.HubName,
    Icon = 0,
    LoadingTitle = Config.LoadingTitle,
    LoadingSubtitle = Config.LoadingSubtitle,
    Theme = Config.Theme,
    ToggleUIKeybind = Config.ToggleKey,
    ConfigurationSaving = Config.ConfigSaving
})

-- Load All Features
local Features = {
    autoFarm = loadstring(game:HttpGet("raw_url_github/features/autoFarm.lua"))(),
    autoSell = loadstring(game:HttpGet("raw_url_github/features/autoSell.lua"))(),
    player = loadstring(game:HttpGet("raw_url_github/features/player.lua"))(),
    movement = loadstring(game:HttpGet("raw_url_github/features/movement.lua"))(),
    teleport = loadstring(game:HttpGet("raw_url_github/features/teleport.lua"))(),
    visual = loadstring(game:HttpGet("raw_url_github/features/visual.lua"))(),
    antiTsunami = loadstring(game:HttpGet("raw_url_github/features/antiTsunami.lua"))(),
    misc = loadstring(game:HttpGet("raw_url_github/features/misc.lua"))()
}

-- Initialize Features
for name, feature in pairs(Features) do
    if feature.Initialize then
        feature:Initialize(Window, Rayfield, Config)
    end
end

-- Success Notification
Rayfield:Notify({
    Title = "✅ Loaded",
    Content = "All features loaded successfully!",
    Duration = 3
})
