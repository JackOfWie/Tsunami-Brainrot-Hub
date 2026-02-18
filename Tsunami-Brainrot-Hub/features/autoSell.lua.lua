local AutoSell = {}
local Settings = {
    Enabled = false,
    SellDelay = 5
}

function AutoSell:Initialize(Window, Rayfield, Config)
    Settings.SellDelay = Config.SellDelay
    
    local Tab = Window:CreateTab("💰 Auto Sell", nil)
    local Section = Tab:CreateSection("Brainrot Seller")
    
    Tab:CreateToggle({
        Name = "Enable Auto Sell",
        CurrentValue = false,
        Flag = "ToggleAutoSell",
        Callback = function(Value)
            Settings.Enabled = Value
            if Value then
                self:StartSelling(Rayfield)
            end
        end
    })
    
    Tab:CreateSlider({
        Name = "Sell Delay",
        Range = {1, 10},
        Increment = 0.5,
        Suffix = "seconds",
        CurrentValue = Settings.SellDelay,
        Flag = "SliderSellDelay",
        Callback = function(Value)
            Settings.SellDelay = Value
        end
    })
end

function AutoSell:StartSelling(Rayfield)
    spawn(function()
        while Settings.Enabled do
            task.wait(Settings.SellDelay)
            
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character then continue end
            
            -- Cari area jual
            local sellArea = self:FindSellArea()
            
            if sellArea then
                character.HumanoidRootPart.CFrame = sellArea.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.5)
                
                -- Klik detector jika ada
                local detector = sellArea:FindFirstChildOfClass("ClickDetector")
                if detector then
                    fireclickdetector(detector)
                end
            end
        end
    end)
end

function AutoSell:FindSellArea()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and (v.Name:find("Sell") or v.Name:find("Shop") or v.Name:find("Selling")) then
            return v
        end
    end
    return nil
end

return AutoSell