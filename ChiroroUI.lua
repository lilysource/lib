-- [[ COMPLETE WORKING UI LIBRARY ]] --
-- Place this in StarterPlayerScripts as a LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ============ UI LIBRARY CLASS ============
local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary:CreateWindow(config)
    local self = setmetatable({}, UILibrary)
    
    config = config or {}
    self.Title = config.Title or "UI Library"
    self.Size = config.Size or UDim2.new(0, 600, 0, 400)
    self.Theme = config.Theme or "Dark"
    self.Acrylic = config.Acrylic or false
    self.Resizable = config.Resize or false
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(240, 240, 245)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Acrylic Blur
    if self.Acrylic then
        self.MainFrame.BackgroundTransparency = 0.3
        local blur = Instance.new("BlurEffect")
        blur.Size = 12
        blur.Parent = self.MainFrame
    end
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(220, 220, 230)
    self.TitleBar.BackgroundTransparency = 0.1
    self.TitleBar.Parent = self.MainFrame
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Size = UDim2.new(1, -120, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamSemibold
    self.TitleText.TextSize = 14
    self.TitleText.Parent = self.TitleBar
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    self.CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    self.CloseBtn.BackgroundTransparency = 0.3
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.TextSize = 14
    self.CloseBtn.Parent = self.TitleBar
    self.CloseBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
    end)
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 150, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(25, 25, 30) or Color3.fromRGB(230, 230, 235)
    self.TabContainer.BackgroundTransparency = 0.2
    self.TabContainer.Parent = self.MainFrame
    
    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Size = UDim2.new(1, -160, 1, -50)
    self.ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentContainer.Parent = self.MainFrame
    
    self.Tabs = {}
    self.Elements = {}
    
    return self
end

function UILibrary:CreateTab(tabData)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, #self.Tabs * 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundTransparency = 0.9
    tabButton.Text = "  " .. (tabData.Icon or "📁") .. "  " .. tabData.Title
    tabButton.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 13
    tabButton.Parent = self.TabContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.AutomaticSize = Enum.AutomaticSize.Y
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabContent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = tabContent
    
    table.insert(self.Tabs, {Button = tabButton, Content = tabContent, Layout = layout})
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundTransparency = 0.9
        end
        tabContent.Visible = true
        tabButton.BackgroundTransparency = 0.5
    end)
    
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return {
        AddSection = function(_, sectionData)
            return self:AddSection(tabContent, sectionData)
        end
    }
end

function UILibrary:AddSection(parent, sectionData)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(45, 45, 50) or Color3.fromRGB(250, 250, 255)
    section.BackgroundTransparency = 0.1
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = sectionData.Title
    titleLabel.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 80, 30)
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
    
    local sectionAPI = {
        AddButton = function(_, btnData)
            return self:AddButton(section, btnData)
        end,
        AddToggle = function(_, toggleData)
            return self:AddToggle(section, toggleData)
        end,
        AddInput = function(_, inputData)
            return self:AddInput(section, inputData)
        end,
        AddSlider = function(_, sliderData)
            return self:AddSlider(section, sliderData)
        end,
        AddDropdown = function(_, dropdownData)
            return self:AddDropdown(section, dropdownData)
        end,
        AddLabel = function(_, labelData)
            return self:AddLabel(section, labelData)
        end
    }
    
    return sectionAPI
end

function UILibrary:AddButton(parent, btnData)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = btnData.Danger and Color3.fromRGB(200, 50, 50) or (self.Theme == "Dark" and Color3.fromRGB(55, 55, 65) or Color3.fromRGB(220, 220, 230))
    button.BackgroundTransparency = 0.2
    button.Text = btnData.Title
    button.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    -- Animation on click
    button.MouseButton1Click:Connect(function()
        local originalSize = button.Size
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset * 0.95)})
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
        end)
        
        if btnData.Callback then
            btnData.Callback()
        end
    end)
    
    return button
end

function UILibrary:AddToggle(parent, toggleData)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = toggleData.Title
    label.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -55, 0, 5)
    toggleBtn.BackgroundColor3 = (toggleData.Default or false) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggleBtn.Text = (toggleData.Default or false) and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleBtn
    
    local state = toggleData.Default or false
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        toggleBtn.Text = state and "ON" or "OFF"
        if toggleData.Callback then
            toggleData.Callback(state)
        end
    end)
    
    return {
        SetValue = function(_, newState)
            state = newState
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
            toggleBtn.Text = state and "ON" or "OFF"
        end,
        GetValue = function()
            return state
        end
    }
end

function UILibrary:AddInput(parent, inputData)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = inputData.Title
    label.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 0, 35)
    input.Position = UDim2.new(0, 0, 0, 22)
    input.PlaceholderText = inputData.Placeholder or ""
    input.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
    input.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    input.PlaceholderColor3 = self.Theme == "Dark" and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(100, 100, 100)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = input
    
    if inputData.NumbersOnly then
        input:GetPropertyChangedSignal("Text"):Connect(function()
            local text = input.Text
            if not text:match("^%d*$") then
                input.Text = text:gsub("%D", "")
            end
        end)
    end
    
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed and inputData.Callback then
            inputData.Callback(input.Text)
        end
    end)
    
    return input
end

function UILibrary:AddSlider(parent, sliderData)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = sliderData.Title
    label.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(sliderData.Default or 50)
    valueLabel.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 80, 30)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 4)
    slider.Position = UDim2.new(0, 0, 0, 35)
    slider.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(60, 60, 65) or Color3.fromRGB(200, 200, 205)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((sliderData.Default or 50) / (sliderData.Max or 100), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(66, 135, 245)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((sliderData.Default or 50) / (sliderData.Max or 100), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = slider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local dragging = false
    local value = sliderData.Default or 50
    
    local function updateValue(inputPos)
        local relativePos = math.clamp((inputPos.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(relativePos * (sliderData.Max or 100))
        value = math.clamp(value, sliderData.Min or 0, sliderData.Max or 100)
        
        fill.Size = UDim2.new(value / (sliderData.Max or 100), 0, 1, 0)
        knob.Position = UDim2.new(value / (sliderData.Max or 100), -6, 0.5, -6)
        valueLabel.Text = tostring(value)
        
        if sliderData.Callback then
            sliderData.Callback(value)
        end
    end
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateValue(input.Position)
        end
    end)
    
    return {
        SetValue = function(_, newValue)
            value = math.clamp(newValue, sliderData.Min or 0, sliderData.Max or 100)
            fill.Size = UDim2.new(value / (sliderData.Max or 100), 0, 1, 0)
            knob.Position = UDim2.new(value / (sliderData.Max or 100), -6, 0.5, -6)
            valueLabel.Text = tostring(value)
            if sliderData.Callback then
                sliderData.Callback(value)
            end
        end,
        GetValue = function()
            return value
        end
    }
end

function UILibrary:AddDropdown(parent, dropdownData)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = dropdownData.Title
    label.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, 0, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 22)
    dropdownBtn.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
    dropdownBtn.Text = dropdownData.Default or dropdownData.Options[1]
    dropdownBtn.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = dropdownBtn
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 0, 52)
    dropdownList.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(230, 230, 235)
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.ZIndex = 10
    dropdownList.Parent = frame
    
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
        for _, option in pairs(dropdownData.Options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, 0, 0, 30)
            optionBtn.BackgroundColor3 = self.Theme == "Dark" and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(240, 240, 245)
            optionBtn.Text = option
            optionBtn.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.TextSize = 14
            optionBtn.Parent = dropdownList
            
            optionBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                dropdownList.Visible = false
                if dropdownData.Callback then
                    dropdownData.Callback(option)
                end
            end)
            
            totalHeight = totalHeight + 32
        end
        
        dropdownList.Size = UDim2.new(1, 0, 0, totalHeight)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            updateList()
        end
    end)
    
    return dropdownBtn
end

function UILibrary:AddLabel(parent, labelData)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelData.Title
    label.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(80, 80, 80)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.6, 0, 1, 0)
    value.Position = UDim2.new(0.4, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Text = labelData.Description or ""
    value.TextColor3 = self.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Font = Enum.Font.Gotham
    value.TextSize = 12
    value.Parent = frame
    
    if labelData.Color then
        value.TextColor3 = labelData.Color
    end
    
    return {
        SetDescription = function(_, newText)
            value.Text = newText
        end,
        SetColor = function(_, newColor)
            value.TextColor3 = newColor
        end
    }
end
