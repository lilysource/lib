-- [[ UI Library for Roblox with Discord Integration ]] --
-- Place this in a LocalScript inside StarterPlayerScripts

local UILibrary = {}
UILibrary.__index = UILibrary

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local Config = {
    DiscordWebhook = "YOUR_WEBHOOK_URL_HERE", -- Replace with your Discord webhook
    HWIDResetWebhook = "YOUR_HWID_WEBHOOK_URL", -- Separate webhook for HWID requests
    GameName = "Your Game Name",
    MaxResetsPerWeek = 1,
    MaxTotalResets = 5,
    ResetCooldownDays = 7,
}

-- Data Storage
local UserData = {}
local UIConfig = {
    Theme = "Dark",
    WindowSize = UDim2.new(0, 600, 0, 400),
    WindowPosition = UDim2.new(0.5, -300, 0.5, -200),
    AcrylicEnabled = true,
    Resizable = true,
}

-- Utility Functions
local function SendWebhook(webhook, data)
    local success, err = pcall(function()
        HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
    if not success then
        warn("Webhook failed: " .. tostring(err))
    end
end

local function GetHWID()
    -- Generate a unique HWID based on player's UserId and various device properties
    local player = Players.LocalPlayer
    local userId = player.UserId
    local graphicsCard = game:GetService("GraphicsSettings"):GetSurfaceIds()
    return HttpService:GenerateGUID(false) .. tostring(userId)
end

local function LoadUserData()
    local dataStore = game:GetService("DataStoreService"):GetDataStore("UI_Library_Data")
    local player = Players.LocalPlayer
    local success, data = pcall(function()
        return dataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and data then
        UserData = data
    else
        UserData = {
            HWID = GetHWID(),
            ResetsUsed = 0,
            LastResetDate = os.time(),
            ResetHistory = {},
            Banned = false,
            BanReason = "",
            ResetRequests = {},
            Theme = "Dark"
        }
    end
end

local function SaveUserData()
    local dataStore = game:GetService("DataStoreService"):GetDataStore("UI_Library_Data")
    local player = Players.LocalPlayer
    pcall(function()
        dataStore:SetAsync(tostring(player.UserId), UserData)
    end)
end

-- HWID Reset System
local function CanRequestReset()
    if UserData.Banned then return false, "You are banned from requesting resets." end
    if UserData.ResetsUsed >= Config.MaxTotalResets then 
        return false, "You have reached the maximum number of resets (5)." 
    end
    
    local timeSinceLastReset = os.difftime(os.time(), UserData.LastResetDate)
    local daysSinceLastReset = timeSinceLastReset / 86400
    
    if daysSinceLastReset < Config.ResetCooldownDays then
        local daysLeft = math.ceil(Config.ResetCooldownDays - daysSinceLastReset)
        return false, string.format("You must wait %d more day(s) before requesting another reset.", daysLeft)
    end
    
    return true
end

local function RequestHWIDReset(reason)
    local canReset, message = CanRequestReset()
    if not canReset then
        return false, message
    end
    
    local player = Players.LocalPlayer
    local requestId = HttpService:GenerateGUID(false)
    
    local requestData = {
        RequestId = requestId,
        UserId = player.UserId,
        Username = player.Name,
        HWID = UserData.HWID,
        Reason = reason,
        Timestamp = os.time(),
        Status = "Pending"
    }
    
    table.insert(UserData.ResetRequests, requestData)
    
    -- Send to Discord for admin approval
    local embed = {
        {
            title = "🔄 New HWID Reset Request",
            color = 0x00ff00,
            fields = {
                {name = "User", value = player.Name, inline = true},
                {name = "User ID", value = tostring(player.UserId), inline = true},
                {name = "Request ID", value = requestId, inline = false},
                {name = "Reason", value = reason or "No reason provided", inline = false},
                {name = "Resets Used", value = tostring(UserData.ResetsUsed) .. "/" .. tostring(Config.MaxTotalResets), inline = true},
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
        }
    }
    
    local webhookData = {
        content = "@everyone New HWID reset request!",
        embeds = embed,
        components = {
            {
                type = 1,
                components = {
                    {type = 2, style = 3, label = "✅ Approve", custom_id = "approve_" .. requestId},
                    {type = 2, style = 4, label = "❌ Deny", custom_id = "deny_" .. requestId},
                }
            }
        }
    }
    
    SendWebhook(Config.HWIDResetWebhook, webhookData)
    
    -- Log the request
    local logEmbed = {
        {
            title = "📝 HWID Reset Request Logged",
            color = 0x3498db,
            fields = {
                {name = "User", value = player.Name, inline = true},
                {name = "Request ID", value = requestId, inline = true},
            }
        }
    }
    SendWebhook(Config.DiscordWebhook, {embeds = logEmbed})
    
    SaveUserData()
    return true, "Reset request submitted for admin approval. You will be notified via DM."
end

-- UI Class
local UI = {}
UI.__index = UI

-- Animation Functions
local function AnimateButton(button, scale)
    local originalSize = button.Size
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset * scale)
    local tween = TweenService:Create(button, tweenInfo, {Size = targetSize})
    tween:Play()
    tween.Completed:Connect(function()
        local revertTween = TweenService:Create(button, tweenInfo, {Size = originalSize})
        revertTween:Play()
    end)
end

-- Create Main Window
function UI.new(title)
    local self = setmetatable({}, UI)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = CoreGui
    
    -- Main Frame (Window)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UIConfig.WindowSize
    self.MainFrame.Position = UIConfig.WindowPosition
    self.MainFrame.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(240, 240, 245)
    self.MainFrame.BackgroundTransparency = UIConfig.AcrylicEnabled and 0.3 or 0
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Acrylic Blur Effect
    if UIConfig.AcrylicEnabled then
        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "AcrylicBlur"
        blurEffect.Size = 12
        blurEffect.Parent = self.MainFrame
        
        local blurBackground = Instance.new("Frame")
        blurBackground.Name = "BlurBackground"
        blurBackground.Size = UDim2.new(1, 0, 1, 0)
        blurBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        blurBackground.BackgroundTransparency = 0.7
        blurBackground.Parent = self.MainFrame
    end
    
    -- Window Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(220, 220, 230)
    self.TitleBar.BackgroundTransparency = 0.1
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Logo
    self.Logo = Instance.new("ImageLabel")
    self.Logo.Size = UDim2.new(0, 24, 0, 24)
    self.Logo.Position = UDim2.new(0, 10, 0, 8)
    self.Logo.BackgroundTransparency = 1
    self.Logo.Image = "rbxassetid://1234567890" -- Replace with your logo asset ID
    self.Logo.Parent = self.TitleBar
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Size = UDim2.new(0, 200, 1, 0)
    self.TitleText.Position = UDim2.new(0, 40, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = title or "UI Library"
    self.TitleText.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamSemibold
    self.TitleText.TextSize = 14
    self.TitleText.Parent = self.TitleBar
    
    -- Window Control Buttons
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0, 120, 1, 0)
    controlFrame.Position = UDim2.new(1, -120, 0, 0)
    controlFrame.BackgroundTransparency = 1
    controlFrame.Parent = self.TitleBar
    
    -- Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Size = UDim2.new(0, 40, 1, 0)
    self.MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    self.MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MinimizeBtn.BackgroundTransparency = 0.9
    self.MinimizeBtn.Text = "─"
    self.MinimizeBtn.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    self.MinimizeBtn.Font = Enum.Font.GothamBold
    self.MinimizeBtn.TextSize = 18
    self.MinimizeBtn.Parent = controlFrame
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
    end)
    
    -- Maximize Button
    self.MaximizeBtn = Instance.new("TextButton")
    self.MaximizeBtn.Size = UDim2.new(0, 40, 1, 0)
    self.MaximizeBtn.Position = UDim2.new(0, 40, 0, 0)
    self.MaximizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MaximizeBtn.BackgroundTransparency = 0.9
    self.MaximizeBtn.Text = "□"
    self.MaximizeBtn.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    self.MaximizeBtn.Font = Enum.Font.GothamBold
    self.MaximizeBtn.TextSize = 16
    self.MaximizeBtn.Parent = controlFrame
    self.MaximizeBtn.MouseButton1Click:Connect(function()
        if self.MainFrame.Size == UIConfig.WindowSize then
            self.MainFrame.Size = UDim2.new(1, 0, 1, 0)
        else
            self.MainFrame.Size = UIConfig.WindowSize
        end
    end)
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    self.CloseBtn.Position = UDim2.new(0, 80, 0, 0)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    self.CloseBtn.BackgroundTransparency = 0.7
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.TextSize = 14
    self.CloseBtn.Parent = controlFrame
    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Draggable Window
    local dragging = false
    local dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Resizable Window
    if UIConfig.Resizable then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Size = UDim2.new(0, 10, 0, 10)
        resizeHandle.Position = UDim2.new(1, -10, 1, -10)
        resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        resizeHandle.BackgroundTransparency = 0.8
        resizeHandle.Parent = self.MainFrame
        
        local resizing = false
        local resizeStart, startSize
        
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = input.Position
                startSize = self.MainFrame.Size
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - resizeStart
                self.MainFrame.Size = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
    end
    
    -- Tab System
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 160, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(230, 230, 235)
    self.TabContainer.BackgroundTransparency = 0.2
    self.TabContainer.Parent = self.MainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -170, 1, -50)
    self.ContentContainer.Position = UDim2.new(0, 170, 0, 50)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.ScrollBarThickness = 8
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentContainer.Parent = self.MainFrame
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Add Tab
function UI:AddTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 45)
    tabButton.Position = UDim2.new(0, 0, 0, #self.Tabs * 45)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundTransparency = 0.9
    tabButton.Text = "  " .. (icon or "📁") .. "  " .. name
    tabButton.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.Parent = self.TabContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, -20, 0, 0)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.AutomaticSize = Enum.AutomaticSize.Y
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local tabCorner = Instance.new("UIListLayout")
    tabCorner.Padding = UDim.new(0, 10)
    tabCorner.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabCorner.SortOrder = Enum.SortOrder.LayoutOrder
    tabCorner.Parent = tabContent
    
    table.insert(self.Tabs, {Button = tabButton, Content = tabContent})
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundTransparency = 0.9
        end
        tabContent.Visible = true
        tabButton.BackgroundTransparency = 0.5
        self.CurrentTab = name
    end)
    
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return {Content = tabContent, Layout = tabCorner}
end

-- Add Section
function UI:AddSection(tabContent, title)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(45, 45, 50) or Color3.fromRGB(250, 250, 255)
    section.BackgroundTransparency = 0.1
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = tabContent.Content
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 80, 30)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = section
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 40)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = section
    
    return {Layout = contentLayout}
end

-- Add Button with Animation
function UI:AddButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(55, 55, 65) or Color3.fromRGB(220, 220, 230)
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        AnimateButton(button, 0.95)
        callback()
    end)
    
    return button
end

-- Add Toggle
function UI:AddToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = toggleFrame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0, 5)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local state = default
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return function() return state end
end

-- Add Input Box
function UI:AddInputBox(parent, placeholder, callback)
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, 0, 0, 35)
    inputBox.PlaceholderText = placeholder
    inputBox.Text = ""
    inputBox.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
    inputBox.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    inputBox.PlaceholderColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.Parent = parent
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(inputBox.Text)
        end
    end)
    
    return inputBox
end

-- Add Dropdown (Single Select)
function UI:AddDropdown(parent, text, options, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = dropdownFrame
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.Position = UDim2.new(0, 0, 0, 20)
    dropdown.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
    dropdown.Text = options[1]
    dropdown.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 14
    dropdown.Parent = dropdownFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdown
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 0, 50)
    dropdownList.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(230, 230, 235)
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.Parent = dropdownFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = dropdownList
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 4)
    listCorner.Parent = dropdownList
    
    local function updateList()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local totalHeight = 0
        for _, option in pairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, 0, 0, 30)
            optionBtn.BackgroundColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
            optionBtn.Text = option
            optionBtn.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.TextSize = 14
            optionBtn.Parent = dropdownList
            
            optionBtn.MouseButton1Click:Connect(function()
                dropdown.Text = option
                callback(option)
                dropdownList.Visible = false
            end)
            
            totalHeight = totalHeight + 32
        end
        
        dropdownList.Size = UDim2.new(1, 0, 0, totalHeight)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            updateList()
        end
    end)
    
    return dropdown
end

-- Add Text Label
function UI:AddTextLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UIConfig.Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = parent
    
    return label
end

-- Theme Management
function UI:SetTheme(theme)
    UIConfig.Theme = theme
    UserData.Theme = theme
    
    -- Update all UI colors
    local bgColor = theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(240, 240, 245)
    local titleColor = theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(220, 220, 230)
    local textColor = theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    local tabColor = theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(230, 230, 235)
    
    self.MainFrame.BackgroundColor3 = bgColor
    self.TitleBar.BackgroundColor3 = titleColor
    self.TitleText.TextColor3 = textColor
    self.TabContainer.BackgroundColor3 = tabColor
    
    for _, tab in pairs(self.Tabs) do
        tab.Button.TextColor3 = textColor
    end
end

-- Initialize Library
local function Initialize()
    LoadUserData()
    
    local window = UI.new(Config.GameName)
    
    -- Main Tab
    local mainTab = window:AddTab("Main", "🏠")
    local mainSection = window:AddSection(mainTab, "Account Management")
    
    -- HWID Reset Button
    window:AddButton(mainSection.Layout, "Request HWID Reset", function()
        local reason = ""
        -- Create input dialog for reason
        local dialog = Instance.new("ScreenGui")
        dialog.Name = "InputDialog"
        dialog.Parent = CoreGui
        
        local dialogFrame = Instance.new("Frame")
        dialogFrame.Size = UDim2.new(0, 300, 0, 150)
        dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        dialogFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        dialogFrame.Parent = dialog
        
        local reasonInput = Instance.new("TextBox")
        reasonInput.Size = UDim2.new(0.9, 0, 0, 60)
        reasonInput.Position = UDim2.new(0.05, 0, 0.1, 0)
        reasonInput.PlaceholderText = "Reason for reset..."
        reasonInput.TextWrapped = true
        reasonInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        reasonInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        reasonInput.Parent = dialogFrame
        
        local submitBtn = Instance.new("TextButton")
        submitBtn.Size = UDim2.new(0.4, 0, 0, 30)
        submitBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
        submitBtn.Text = "Submit"
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.Parent = dialogFrame
        
        submitBtn.MouseButton1Click:Connect(function()
            local success, message = RequestHWIDReset(reasonInput.Text)
            dialog:Destroy()
            
            -- Show notification
            local notif = Instance.new("TextLabel")
            notif.Size = UDim2.new(0, 300, 0, 50)
            notif.Position = UDim2.new(0.5, -150, 0.1, 0)
            notif.BackgroundColor3 = success and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
            notif.Text = message
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            notif.TextWrapped = true
            notif.Parent = CoreGui
            
            wait(3)
            notif:Destroy()
        end)
    end)
    
    -- Reset Info Label
    local canReset, resetMessage = CanRequestReset()
    window:AddTextLabel(mainSection.Layout, "Reset Status: " .. (canReset and "Available" or resetMessage))
    window:AddTextLabel(mainSection.Layout, "Resets Used: " .. UserData.ResetsUsed .. "/" .. Config.MaxTotalResets)
    
    -- Settings Tab
    local settingsTab = window:AddTab("Settings", "⚙️")
    local themeSection = window:AddSection(settingsTab, "Appearance")
    
    -- Theme Toggle
    window:AddToggle(themeSection.Layout, "Dark Mode", UserData.Theme == "Dark", function(state)
        window:SetTheme(state and "Dark" or "Light")
    end)
    
    -- HWID Info Tab
    local hwidTab = window:AddTab("HWID Info", "🔑")
    local infoSection = window:AddSection(hwidTab, "Hardware Information")
    
    window:AddTextLabel(infoSection.Layout, "HWID: " .. UserData.HWID)
    window:AddTextLabel(infoSection.Layout, "Last Reset: " .. os.date("%Y-%m-%d %H:%M:%S", UserData.LastResetDate))
    
    if UserData.Banned then
        window:AddTextLabel(infoSection.Layout, "⚠️ BANNED: " .. UserData.BanReason)
    end
    
    return window
end

-- Start the library
Initialize()

-- Exports
return UILibrary
