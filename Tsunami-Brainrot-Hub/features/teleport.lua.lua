local Teleport = {}
local Locations = {}

function Teleport:Initialize(Window, Rayfield, Config)
    local Tab = Window:CreateTab("🌍 Teleport", nil)
    local Section = Tab:CreateSection("Safe Zones")
    
    -- Scan Locations Button
    Tab:CreateButton({
        Name = "🔍 Scan Teleport Locations",
        Callback = function()
            self:ScanLocations()
            Rayfield:Notify({
                Title = "Scan Complete",
                Content = "Found " .. #Locations .. " locations",
                Duration = 3
            })
        end
    })
    
    -- Teleport to Spawn
    Tab:CreateButton({
        Name = "🏠 Spawn Area",
        Callback = function()
            self:TeleportToSpawn()
        end
    })
    
    -- Custom Teleport
    Tab:CreateButton({
        Name = "📍 High Ground",
        Callback = function()
            self:TeleportToHighGround()
        end
    })
    
    -- Dynamic Locations (will be populated after scan)
    Tab:CreateSection("Scanned Locations")
    for i, loc in ipairs(Locations) do
        Tab:CreateButton({
            Name = loc.Name,
            Callback = function()
                self:TeleportToCFrame(loc.CFrame)
            end
        })
    end
end

function Teleport:ScanLocations()
    Locations = {}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:find("Safe") or v.Name:find("Zone") or v.Name:find("Spawn") then
            table.insert(Locations, {
                Name = v.Name,
                CFrame = v.CFrame
            })
        end
    end
end

function Teleport:TeleportToCFrame(cframe)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cframe * CFrame.new(0, 3, 0)
    end
end

function Teleport:TeleportToSpawn()
    local spawns = workspace:FindFirstChild("SpawnLocation")
    if spawns then
        self:TeleportToCFrame(spawns.CFrame)
    end
end

function Teleport:TeleportToHighGround()
    self:TeleportToCFrame(CFrame.new(0, Config.SafeHeight, 0))
end

return Teleport