local Movement = {}
local Settings = {
    InfiniteJump = false,
    Fly = false,
    SpeedMultiplier = 1
}

function Movement:Initialize(Window, Rayfield, Config)
    local Tab = Window:CreateTab("🦋 Movement", nil)
    local Section = Tab:CreateSection("Movement Hacks")
    
    -- Infinite Jump
    Tab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Flag = "ToggleInfJump",
        Callback = function(Value)
            Settings.InfiniteJump = Value
            if Value then
                self:EnableInfiniteJump()
            end
        end
    })
    
    -- Fly Mode
    Tab:CreateToggle({
        Name = "Fly Mode",
        CurrentValue = false,
        Flag = "ToggleFly",
        Callback = function(Value)
            Settings.Fly = Value
            if Value then
                self:EnableFly()
            else
                self:DisableFly()
            end
        end
    })
    
    -- Speed Multiplier
    Tab:CreateSlider({
        Name = "Speed Multiplier",
        Range = {1, 5},
        Increment = 0.1,
        Suffix = "x",
        CurrentValue = 1,
        Flag = "SliderSpeedMult",
        Callback = function(Value)
            Settings.SpeedMultiplier = Value
        end
    })
end

function Movement:EnableInfiniteJump()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    mouse.KeyDown:Connect(function(key)
        if Settings.InfiniteJump and key == " " then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState("Jumping")
            end
        end
    end)
end

function Movement:EnableFly()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        humanoid.PlatformStand = true
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyVelocity.Parent = root
        
        self.FlyParts = {bodyGyro, bodyVelocity}
    end
end

function Movement:DisableFly()
    if self.FlyParts then
        for _, part in pairs(self.FlyParts) do
            part:Destroy()
        end
        self.FlyParts = nil
    end
    
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
    end
end

return Movement