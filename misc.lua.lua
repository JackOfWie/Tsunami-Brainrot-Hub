local Misc = {}

function Misc:Initialize(Window, Rayfield, Config)
    local Tab = Window:CreateTab("🛠️ Misc", nil)
    local Section = Tab:CreateSection("Utilities")
    
    -- Rejoin
    Tab:CreateButton({
        Name = "🔄 Rejoin Server",
        Callback = function()
            local ts = game:GetService("TeleportService")
            local plr = game:GetService("Players").LocalPlayer
            ts:Teleport(game.PlaceId, plr)
        end
    })
    
    -- Server Hop
    Tab:CreateButton({
        Name = "🌐 Server Hop",
        Callback = function()
            self:ServerHop()
        end
    })
    
    -- Anti Afk
    Tab:CreateToggle({
        Name = "Anti AFK",
        CurrentValue = false,
        Flag = "ToggleAntiAfk",
        Callback = function(Value)
            if Value then
                self:EnableAntiAfk()
            end
        end
    })
    
    -- FPS Booster
    Tab:CreateToggle({
        Name = "FPS Booster",
        CurrentValue = false,
        Flag = "ToggleFPS",
        Callback = function(Value)
            if Value then
                settings().Rendering.QualityLevel = 1
                game.Lighting.GlobalShadows = false
            else
                settings().Rendering.QualityLevel = 21
                game.Lighting.GlobalShadows = true
            end
        end
    })
    
    -- Unlock FPS
    Tab:CreateToggle({
        Name = "Unlock FPS",
        CurrentValue = false,
        Flag = "ToggleUnlockFPS",
        Callback = function(Value)
            setfpscap(Value and 999 or 60)
        end
    })
    
    -- Clear Trash
    Tab:CreateButton({
        Name = "🧹 Clear Trash (Boost FPS)",
        Callback = function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Trash" or v.Name == "Debris" then
                    v:Destroy()
                end
            end
        end
    })
    
    -- Copy Coordinates
    Tab:CreateButton({
        Name = "📋 Copy Current Position",
        Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                setclipboard(string.format("Vector3.new(%f, %f, %f)", pos.X, pos.Y, pos.Z))
                
                Rayfield:Notify({
                    Title = "Copied!",
                    Content = "Position copied to clipboard",
                    Duration = 2
                })
            end
        end
    })
end

function Misc:ServerHop()
    local ts = game:GetService("TeleportService")
    local plr = game:GetService("Players").LocalPlayer
    local placeId = game.PlaceId
    
    local function hop()
        local servers = {}
        local req = request or http_request or (syn and syn.request)
        
        if not req then
            Rayfield:Notify({
                Title = "Error",
                Content = "Executor doesn't support HTTP requests",
                Duration = 3
            })
            return
        end
        
        local response = req({
            Url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100",
            Method = "GET"
        })
        
        if response and response.StatusCode == 200 then
            local data = game:GetService("HttpService"):JSONDecode(response.Body)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
        
        if #servers > 0 then
            ts:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], plr)
        else
            Rayfield:Notify({
                Title = "Server Hop",
                Content = "No other servers available",
                Duration = 3
            })
        end
    end
    
    pcall(hop)
end

function Misc:EnableAntiAfk()
    local vu = game:GetService("VirtualUser")
    local player = game:GetService("Players").LocalPlayer
    
    player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

return Misc