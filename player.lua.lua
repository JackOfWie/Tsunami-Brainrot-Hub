local Player = {}
local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false
}

function Player:Initialize(Window, Rayfield, Config)
    Settings.WalkSpeed = Config.DefaultWalkSpeed
    Settings.JumpPower = Config.DefaultJumpPower
    
    local Tab = Window:CreateTab("⚡ Player", nil)
    local Section = Tab:CreateSection("Character Stats")
    
    -- Walk Speed
    Tab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, Config.MaxWalkSpeed},
        Increment = 1,
        Suffix = "speed",
        CurrentValue = Settings.WalkSpeed,
        Flag = "SliderWalkSpeed",
        Callback = function(Value)
            Settings.WalkSpeed = Value
            self:UpdateCharacter()
        end
    })
    
    -- Jump Power
    Tab:CreateSlider({
        Name = "Jump Power",
        Range = {50, Config.MaxJumpPower},
        Increment = 1,
        Suffix = "power",
        CurrentValue = Settings.JumpPower,
        Flag = "SliderJumpPower",
        Callback = function(Value)
            Settings.JumpPower = Value
            self:UpdateCharacter()
        end
    })
    
    -- Noclip
    Tab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Flag = "ToggleNoclip",
        Callback = function(Value)
            Settings.Noclip = Value
            if Value then
                self:StartNoclip()
            end
        end
    })
end

function Player:UpdateCharacter()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = Settings.WalkSpeed
        humanoid.JumpPower = Settings.JumpPower
    end
end

function Player:StartNoclip()
    spawn(function()
        while Settings.Noclip do
            task.wait()
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end

return Player