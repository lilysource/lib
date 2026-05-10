local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lilysource/lib/refs/heads/main/ChiroroUI.luau"))()

-- Create main window
local Window = Library:CreateWindow({
    Title = "Chiroro Hub",
    SubTitle = "Complete Button Examples",
    Size = UDim2.fromOffset(800, 600),
    Resize = true,
    MinSize = Vector2.new(500, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Create Main Tab
local MainTab = Window:CreateTab({Title = "Main"})

-- ============ SECTION 1: BASIC BUTTONS ============
local BasicSection = MainTab:AddSection({Title = "Basic Buttons"})

-- Simple button with print
MainTab:CreateButton({
    Title = "Click Me!",
    Callback = function() 
        print("Button clicked!")
    end
})

-- Button with warning
MainTab:CreateButton({
    Title = "Warning Button",
    Callback = function() 
        warn("Warning button was pressed!")
    end
})

-- Button with error
MainTab:CreateButton({
    Title = "Error Button",
    Callback = function() 
        error("This is an error message!")
    end
})

-- Button with notification
MainTab:CreateButton({
    Title = "Notification Button",
    Callback = function() 
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Notification",
            Text = "Button was clicked!",
            Duration = 3
        })
    end
})

-- ============ SECTION 2: ACTION BUTTONS ============
local ActionSection = MainTab:AddSection({Title = "Action Buttons"})

-- Teleport button
MainTab:CreateButton({
    Title = "Teleport to Spawn",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            print("Teleported to spawn!")
        end
    end
})

-- Kill button
MainTab:CreateButton({
    Title = "Kill Character",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Health = 0
            print("Character killed!")
        end
    end
})

-- Heal button
MainTab:CreateButton({
    Title = "Heal Character",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Health = character.Humanoid.MaxHealth
            print("Character healed!")
        end
    end
})

-- Reset button
MainTab:CreateButton({
    Title = "Reset Character",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:BreakJoints()
        print("Character reset!")
    end
})

-- ============ SECTION 3: WALKSPEED/JUMPOWER BUTTONS ============
local MovementSection = MainTab:AddSection({Title = "Movement Controls"})

-- Set Walkspeed
MainTab:CreateButton({
    Title = "Set Walkspeed to 50",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
            print("Walkspeed set to 50!")
        end
    end
})

-- Set Walkspeed to 100
MainTab:CreateButton({
    Title = "Set Walkspeed to 100",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 100
            print("Walkspeed set to 100!")
        end
    end
})

-- Reset Walkspeed
MainTab:CreateButton({
    Title = "Reset Walkspeed (16)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            print("Walkspeed reset to 16!")
        end
    end
})

-- Set JumpPower
MainTab:CreateButton({
    Title = "Set JumpPower to 100",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
            print("JumpPower set to 100!")
        end
    end
})

-- Reset JumpPower
MainTab:CreateButton({
    Title = "Reset JumpPower (50)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
            print("JumpPower reset to 50!")
        end
    end
})

-- ============ SECTION 4: VISUAL EFFECTS BUTTONS ============
local VisualSection = MainTab:AddSection({Title = "Visual Effects"})

-- Change Brightness
MainTab:CreateButton({
    Title = "Set Brightness to Max",
    Callback = function()
        game:GetService("Lighting").Brightness = 2
        print("Brightness set to max!")
    end
})

-- Change Fog
MainTab:CreateButton({
    Title = "Enable Fog",
    Callback = function()
        game:GetService("Lighting").FogEnd = 100
        game:GetService("Lighting").FogStart = 0
        print("Fog enabled!")
    end
})

-- Disable Fog
MainTab:CreateButton({
    Title = "Disable Fog",
    Callback = function()
        game:GetService("Lighting").FogEnd = 100000
        print("Fog disabled!")
    end
})

-- Set Time of Day
MainTab:CreateButton({
    Title = "Set Time to Noon",
    Callback = function()
        game:GetService("Lighting").TimeOfDay = "14:00:00"
        print("Time set to noon!")
    end
})

-- Set Time to Night
MainTab:CreateButton({
    Title = "Set Time to Midnight",
    Callback = function()
        game:GetService("Lighting").TimeOfDay = "00:00:00"
        print("Time set to midnight!")
    end
})

-- ============ SECTION 5: CHARACTER MODIFICATIONS ============
local CharacterSection = MainTab:AddSection({Title = "Character Mods"})

-- Make Giant
MainTab:CreateButton({
    Title = "Make Giant",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            character:SetPrimaryPartCFrame(character:GetPivot() * CFrame.new(0, 5, 0))
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * 2
                end
            end
            print("Made character giant!")
        end
    end
})

-- Make Tiny
MainTab:CreateButton({
    Title = "Make Tiny",
    Callback = function()
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size / 2
                end
            end
            print("Made character tiny!")
        end
    end
})

-- Reset Size
MainTab:CreateButton({
    Title = "Reset Size",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:BreakJoints()
        print("Character reset to normal size!")
    end
})

-- ============ SECTION 6: UTILITY BUTTONS ============
local UtilitySection = MainTab:AddSection({Title = "Utility"})

-- Get Game Info
MainTab:CreateButton({
    Title = "Get Game Info",
    Callback = function()
        local info = {
            Game = game.Name,
            PlaceId = game.PlaceId,
            PlayerCount = #game:GetService("Players"):GetPlayers(),
            ServerTime = workspace.DistributedGameTime
        }
        print("Game Info:", info)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Game Info",
            Text = string.format("Players: %d\nTime: %.0f seconds", info.PlayerCount, info.ServerTime),
            Duration = 5
        })
    end
})

-- Copy Game ID
MainTab:CreateButton({
    Title = "Copy Place ID",
    Callback = function()
        local clipboard = game:GetService("ClipboardService")
        clipboard:setText(tostring(game.PlaceId))
        print("Place ID copied: " .. game.PlaceId)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Copied!",
            Text = "Place ID copied to clipboard",
            Duration = 2
        })
    end
})

-- Get Player List
MainTab:CreateButton({
    Title = "Show Player List",
    Callback = function()
        local players = game:GetService("Players"):GetPlayers()
        local names = {}
        for i, player in ipairs(players) do
            table.insert(names, player.Name)
        end
        print("Players in server:", table.concat(names, ", "))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Player List",
            Text = #players .. " players in server",
            Duration = 3
        })
    end
})

-- ============ SECTION 7: SCRIPT CONTROL BUTTONS ============
local ScriptSection = MainTab:AddSection({Title = "Script Controls"})

-- Rejoin
MainTab:CreateButton({
    Title = "Rejoin Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
        print("Rejoining game...")
    end
})

-- Leave Game
MainTab:CreateButton({
    Title = "Leave Game",
    Callback = function()
        game:GetService("Players").LocalPlayer:Kick("Left via UI button")
        print("Left game!")
    end
})

-- Screenshot
MainTab:CreateButton({
    Title = "Take Screenshot",
    Callback = function()
        game:GetService("ScreenshotService"):CaptureScreenshot()
        print("Screenshot taken!")
    end
})

-- Clear Console
MainTab:CreateButton({
    Title = "Clear Console",
    Callback = function()
        -- Clear output console
        for i = 1, 100 do
            print("")
        end
        print("Console cleared!")
    end
})

-- ============ SECTION 8: ANIMATED BUTTONS WITH MESSAGES ============
local AnimatedSection = MainTab:AddSection({Title = "Animated Messages"})

MainTab:CreateButton({
    Title = "Say Hello",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = character.Head
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            
            local text = Instance.new("TextLabel")
            text.Parent = billboard
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = "Hello!"
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextScaled = true
            
            game:GetService("Debris"):AddItem(billboard, 2)
            print("Said hello!")
        end
    end
})

MainTab:CreateButton({
    Title = "Play Sound",
    Callback = function()
        local sound = Instance.new("Sound")
        sound.Parent = game:GetService("Players").LocalPlayer.Character
        sound.SoundId = "rbxassetid://9120386644" -- Default button sound
        sound:Play()
        print("Sound played!")
        game:GetService("Debris"):AddItem(sound, 3)
    end
})

-- ============ SECTION 9: ESP TOGGLE EXAMPLE (with toggle) ============
local ESPToggle = MainTab:CreateToggle({
    Title = "Enable ESP (Player Highlight)",
    Default = false,
    Callback = function(value)
        if value then
            print("ESP Enabled!")
            -- Add ESP logic here
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    player.Character.Highlight = highlight
                end
            end
        else
            print("ESP Disabled!")
            -- Remove ESP logic here
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end
})

-- ============ SECTION 10: INPUT EXAMPLES ============
local InputSection = MainTab:AddSection({Title = "Input Examples"})

-- Walkspeed input
MainTab:CreateInput({
    Title = "Custom Walkspeed",
    Placeholder = "Enter number (16-200)",
    Callback = function(value)
        local speed = tonumber(value)
        if speed then
            local player = game:GetService("Players").LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = math.clamp(speed, 16, 200)
                print("Walkspeed set to:", player.Character.Humanoid.WalkSpeed)
            end
        else
            print("Invalid number!")
        end
    end
})

-- JumpPower input
MainTab:CreateInput({
    Title = "Custom JumpPower",
    Placeholder = "Enter number (50-200)",
    Callback = function(value)
        local power = tonumber(value)
        if power then
            local player = game:GetService("Players").LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = math.clamp(power, 50, 200)
                print("JumpPower set to:", player.Character.Humanoid.JumpPower)
            end
        else
            print("Invalid number!")
        end
    end
})

-- ============ SECTION 11: DROPDOWN EXAMPLES ============
local DropdownSection = MainTab:AddSection({Title = "Dropdown Examples"})

-- Color selector
MainTab:CreateDropdown({
    Title = "Select Highlight Color",
    Options = {"Red", "Blue", "Green", "Yellow", "Purple"},
    Callback = function(selected)
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Green = Color3.fromRGB(0, 255, 0),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(255, 0, 255)
        }
        print("Selected color:", selected, colors[selected])
    end
})

-- Speed selector
MainTab:CreateDropdown({
    Title = "Select Speed",
    Options = {"Normal (16)", "Fast (50)", "Very Fast (100)", "Super Fast (200)"},
    Callback = function(selected)
        local speeds = {
            ["Normal (16)"] = 16,
            ["Fast (50)"] = 50,
            ["Very Fast (100)"] = 100,
            ["Super Fast (200)"] = 200
        }
        local speed = speeds[selected]
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speed
            print("Speed set to:", speed)
        end
    end
})

-- ============ SECTION 12: MULTI-DROPDOWN EXAMPLES ============
local MultiSection = MainTab:AddSection({Title = "Multi-Select Examples"})

MainTab:CreateMultiDropdown({
    Title = "Select Items to Spawn",
    Options = {"Sword", "Gun", "Health Pack", "Shield", "Speed Boost"},
    Callback = function(selected)
        print("Selected items:", table.concat(selected, ", "))
        for _, item in pairs(selected) do
            print("Spawning:", item)
            -- Add spawn logic here
        end
    end
})

MainTab:CreateMultiDropdown({
    Title = "Select Effects to Apply",
    Options = {"Speed Boost", "Jump Boost", "Invisible", "Invincible", "No Clip"},
    Callback = function(selected)
        print("Applying effects:", table.concat(selected, ", "))
        -- Add effect logic here
    end
})

-- ============ SECTION 13: TEXT LABELS ============
local TextSection = MainTab:AddSection({Title = "Information"})

MainTab:CreateText({Title = "Welcome to Modern UI Library!"})
MainTab:CreateText({Title = "Total Buttons: 40+ Examples"})
MainTab:CreateText({Title = "Features: Buttons, Inputs, Toggles, Dropdowns"})
MainTab:CreateText({Title = "Created for Roblox Lua Scripting"})

-- ============ FINAL REFRESH ============
Window:Refresh()
print("UI Loaded Successfully! Total buttons created: 40+")
