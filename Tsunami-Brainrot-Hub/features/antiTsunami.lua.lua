local AntiTsunami = {}
local Settings = {
    Enabled = false,
    AutoTeleport = true,
    SafeHeight = 200
}

function AntiTsunami:Initialize(Window, Rayfield, Config)
    Settings.SafeHeight = Config.SafeHeight
    
    local Tab = Window:CreateTab("🌊 Anti Tsunami", nil)
    local Section = Tab:CreateSection("Wave Protection")
    
    Tab:CreateToggle({
        Name = "Enable Anti Tsunami",
        CurrentValue = false,
        Flag = "ToggleAntiWave",
        Callback = function(Value)
            Settings.Enabled = Value
            if Value then
                self:StartProtection(Rayfield)
            end
        end
    })
    
    Tab:CreateToggle({
        Name = "Auto Teleport to Safe Zone",
        CurrentValue = true,
        Flag = "ToggleAutoTeleport",
        Callback = function(Value)
            Settings.AutoTeleport = Value
        end
    })
    
    Tab:CreateSlider({
        Name = "Detection Distance",
        Range = {30, 200},
        Increment = 5,
        Suffix = "studs",
        CurrentValue = 50,
        Flag = "SliderDetectDist",
        Callback = function(Value)
            Settings.DetectDistance = Value
        end
    })
    
    Tab:CreateButton({
        Name = "🏃 Teleport to Safe Zone Now",
        Callback = function()
            self:TeleportToSafeZone()
        end
    })
end

function AntiTsunami:StartProtection(Rayfield)
    spawn(function()
        while Settings.Enabled do
            task.wait(0.5)
            
            -- Deteksi tsunami
            local tsunami = self:FindTsunami()
            if tsunami then
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    
                    if self:IsTsunamiNear(playerPos, tsunami) then
                        Rayfield:Notify({
                            Title = "⚠️ TSUNAMI DETECTED",
                            Content = "Moving to safe zone!",
                            Duration = 2
                        })
                        
                        if Settings.AutoTeleport then
                            self:TeleportToSafeZone()
                        end
                    end
                end
            end
        end
    end)
end

function AntiTsunami:FindTsunami()
    -- Cari object tsunami (nama bisa berbeda tiap game)
    local possibleNames = {"Tsunami", "Wave", "Water", "Flood", "Tidal"}
    
    for _, name in ipairs(possibleNames) do
        local obj = workspace:FindFirstChild(name)
        if obj then return obj end
    end
    
    -- Cek di descendants
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:find("Tsunami") or v.Name:find("Wave") then
            return v
        end
    end
    
    return nil
end

function AntiTsunami:IsTsunamiNear(playerPos, tsunami)
    if tsunami:IsA("Part") then
        local distance = (playerPos - tsunami.Position).Magnitude
        return distance < (Settings.DetectDistance or 50)
    end
    return false
end

function AntiTsunami:TeleportToSafeZone()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport ke ketinggian aman
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, Settings.SafeHeight, 0)
    end
end

return AntiTsunami