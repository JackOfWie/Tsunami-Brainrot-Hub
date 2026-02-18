local AutoFarm = {}
local Settings = {
    Enabled = false,
    FarmDelay = 0.5
}

function AutoFarm:Initialize(Window, Rayfield, Config)
    Settings.FarmDelay = Config.FarmDelay
    
    local Tab = Window:CreateTab("🌾 Auto Farm", nil)
    local Section = Tab:CreateSection("Brainrot Collector")
    
    -- Main Toggle
    Tab:CreateToggle({
        Name = "Enable Auto Farm",
        CurrentValue = false,
        Flag = "ToggleAutoFarm",
        Callback = function(Value)
            Settings.Enabled = Value
            if Value then
                self:StartFarming(Rayfield)
            end
        end
    })
    
    -- Farm Delay Slider
    Tab:CreateSlider({
        Name = "Farm Delay",
        Range = {0.1, 2},
        Increment = 0.1,
        Suffix = "seconds",
        CurrentValue = Settings.FarmDelay,
        Flag = "SliderFarmDelay",
        Callback = function(Value)
            Settings.FarmDelay = Value
        end
    })
    
    -- Filter Options
    Tab:CreateDropdown({
        Name = "Brainrot Filter",
        Options = {"All", "Common", "Rare", "Epic", "Legendary"},
        CurrentOption = "All",
        Flag = "DropdownFilter",
        Callback = function(Option)
            Settings.Filter = Option
        end
    })
end

function AutoFarm:StartFarming(Rayfield)
    spawn(function()
        while Settings.Enabled do
            task.wait(Settings.FarmDelay)
            
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character then continue end
            
            -- Cari brainrot terdekat
            local nearestBrainrot = self:FindNearestBrainrot(character)
            
            if nearestBrainrot then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = nearestBrainrot.CFrame * CFrame.new(0, 2, 0)
                end
            end
        end
    end)
end

function AutoFarm:FindNearestBrainrot(character)
    local closest = nil
    local closestDist = math.huge
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and (v.Name:find("Brainrot") or v.Name:find("Brain")) then
            local dist = (character.HumanoidRootPart.Position - v.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = v
            end
        end
    end
    
    return closest
end

return AutoFarm