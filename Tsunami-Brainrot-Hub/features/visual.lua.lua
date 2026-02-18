local Visual = {}
local Settings = {
    ESP = false,
    Fullbright = false,
    ESPColor = Color3.new(1, 0, 0)
}

function Visual:Initialize(Window, Rayfield, Config)
    Settings.ESPColor = Config.ESPColor
    
    local Tab = Window:CreateTab("👁️ Visual", nil)
    local Section = Tab:CreateSection("ESP Settings")
    
    -- Player ESP
    Tab:CreateToggle({
        Name = "Player ESP",
        CurrentValue = false,
        Flag = "ToggleESP",
        Callback = function(Value)
            Settings.ESP = Value
            if Value then
                self:EnableESP()
            else
                self:DisableESP()
            end
        end
    })
    
    -- Item ESP
    Tab:CreateToggle({
        Name = "Item ESP",
        CurrentValue = false,
        Flag = "ToggleItemESP",
        Callback = function(Value)
            Settings.ItemESP = Value
            if Value then
                self:EnableItemESP()
            else
                self:DisableItemESP()
            end
        end
    })
    
    -- ESP Color
    Tab:CreateColorPicker({
        Name = "ESP Color",
        Color = Settings.ESPColor,
        Flag = "ColorPickerESP",
        Callback = function(Color)
            Settings.ESPColor = Color
            self:UpdateESPColor()
        end
    })
    
    -- Fullbright
    Tab:CreateToggle({
        Name = "Fullbright",
        CurrentValue = false,
        Flag = "ToggleFullbright",
        Callback = function(Value)
            Settings.Fullbright = Value
            if Value then
                game.Lighting.Ambient = Color3.new(1, 1, 1)
                game.Lighting.Brightness = 2
            else
                game.Lighting.Ambient = Color3.new(0, 0, 0)
                game.Lighting.Brightness = 1
            end
        end
    })
    
    -- X-Ray
    Tab:CreateToggle({
        Name = "X-Ray Mode",
        CurrentValue = false,
        Flag = "ToggleXRay",
        Callback = function(Value)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:IsA("Player") then
                    v.Transparency = Value and 0.5 or 0
                end
            end
        end
    })
end

function Visual:EnableESP()
    spawn(function()
        while Settings.ESP do
            task.wait(0.1)
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    self:CreateESP(player.Character)
                end
            end
        end
    end)
end

function Visual:CreateESP(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if not root:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Settings.ESPColor
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.Adornee = character
        highlight.Parent = character
    end
end

function Visual:DisableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

function Visual:UpdateESPColor()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChildOfClass("Highlight")
            if highlight then
                highlight.FillColor = Settings.ESPColor
            end
        end
    end
end

function Visual:EnableItemESP()
    spawn(function()
        while Settings.ItemESP do
            task.wait(0.2)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name:find("Brainrot") then
                    if not v:FindFirstChild("BillboardGui") then
                        self:CreateItemTag(v)
                    end
                end
            end
        end
    end)
end

function Visual:CreateItemTag(part)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemTag"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🧠 BRAINROT"
    text.TextColor3 = Settings.ESPColor
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.TextStrokeTransparency = 0.5
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard
end

return Visual