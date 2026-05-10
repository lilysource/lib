-- Modern UI Library for Roblox
local ModernUI = {}
ModernUI.__index = ModernUI

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ClipboardService = game:GetService("ClipboardService")

-- Default Settings
ModernUI.Theme = {
    Background = Color3.fromRGB(30, 30, 35),
    Surface = Color3.fromRGB(40, 40, 45),
    Accent = Color3.fromRGB(0, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Danger = Color3.fromRGB(255, 50, 50),
    Success = Color3.fromRGB(50, 255, 50),
    Warning = Color3.fromRGB(255, 200, 50)
}

-- Create new UI instance
function ModernUI.new(title, size)
    local self = setmetatable({}, ModernUI)
    
    self.Title = title or "Modern UI"
    self.Size = size or UDim2.new(0, 500, 0, 600)
    self.Position = UDim2.new(0.5, -250, 0.5, -300)
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateMainFrame()
    self:CreateUIComponents()
    
    return self
end

-- Create main window
function ModernUI:CreateMainFrame()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUI"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BackgroundTransparency = 0
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    
    -- Shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = self.MainFrame
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.Parent = self.MainFrame
    corner.CornerRadius = UDim.new(0, 8)
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.Parent = shadow
    shadowCorner.CornerRadius = UDim.new(0, 8)
end

-- Create title bar and components
function ModernUI:CreateUIComponents()
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.MainFrame
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    self.TitleBar.BorderSizePixel = 0
    
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.Parent = self.TitleBar
    titleBarCorner.CornerRadius = UDim.new(0, 8)
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Parent = self.TitleBar
    self.TitleText.Size = UDim2.new(1, -100, 1, 0)
    self.TitleText.Position = UDim2.new(0, 15, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Theme.Text
    self.TitleText.TextSize = 18
    self.TitleText.Font = Enum.Font.GothamSemibold
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Logo
    self.Logo = Instance.new("ImageLabel")
    self.Logo.Name = "Logo"
    self.Logo.Parent = self.TitleBar
    self.Logo.Size = UDim2.new(0, 24, 0, 24)
    self.Logo.Position = UDim2.new(0, 10, 0, 8)
    self.Logo.BackgroundTransparency = 1
    self.Logo.Image = "rbxassetid://6031098374" -- Default Roblox logo
    self.Logo.ImageColor3 = self.Theme.Accent
    
    -- Window Control Buttons
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "ButtonsFrame"
    buttonsFrame.Parent = self.TitleBar
    buttonsFrame.Size = UDim2.new(0, 100, 1, 0)
    buttonsFrame.Position = UDim2.new(1, -105, 0, 0)
    buttonsFrame.BackgroundTransparency = 1
    
    -- Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Name = "MinimizeBtn"
    self.MinimizeBtn.Parent = buttonsFrame
    self.MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    self.MinimizeBtn.Position = UDim2.new(0, 5, 0, 0)
    self.MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    self.MinimizeBtn.Text = "−"
    self.MinimizeBtn.TextColor3 = self.Theme.Text
    self.MinimizeBtn.TextSize = 20
    self.MinimizeBtn.Font = Enum.Font.Gotham
    self.MinimizeBtn.BorderSizePixel = 0
    
    local minCorner = Instance.new("UICorner")
    minCorner.Parent = self.MinimizeBtn
    minCorner.CornerRadius = UDim.new(0, 4)
    
    -- Maximize Button
    self.MaximizeBtn = Instance.new("TextButton")
    self.MaximizeBtn.Name = "MaximizeBtn"
    self.MaximizeBtn.Parent = buttonsFrame
    self.MaximizeBtn.Size = UDim2.new(0, 30, 1, 0)
    self.MaximizeBtn.Position = UDim2.new(0, 40, 0, 0)
    self.MaximizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    self.MaximizeBtn.Text = "□"
    self.MaximizeBtn.TextColor3 = self.Theme.Text
    self.MaximizeBtn.TextSize = 16
    self.MaximizeBtn.Font = Enum.Font.Gotham
    self.MaximizeBtn.BorderSizePixel = 0
    
    local maxCorner = Instance.new("UICorner")
    maxCorner.Parent = self.MaximizeBtn
    maxCorner.CornerRadius = UDim.new(0, 4)
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Name = "CloseBtn"
    self.CloseBtn.Parent = buttonsFrame
    self.CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    self.CloseBtn.Position = UDim2.new(0, 75, 0, 0)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = self.Theme.Text
    self.CloseBtn.TextSize = 16
    self.CloseBtn.Font = Enum.Font.Gotham
    self.CloseBtn.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = self.CloseBtn
    closeCorner.CornerRadius = UDim.new(0, 4)
    
    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Accent
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = self.ContentContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    
    self.ListLayout = listLayout
    
    -- Dragging functionality
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
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Button functionality
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)
    
    local isMaximized = false
    local previousSize, previousPosition
    
    self.MaximizeBtn.MouseButton1Click:Connect(function()
        if not isMaximized then
            previousSize = self.MainFrame.Size
            previousPosition = self.MainFrame.Position
            self.MainFrame.Size = UDim2.new(1, 0, 1, 0)
            self.MainFrame.Position = UDim2.new(0, 0, 0, 0)
        else
            self.MainFrame.Size = previousSize
            self.MainFrame.Position = previousPosition
        end
        isMaximized = not isMaximized
    end)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
end

-- Create a section
function ModernUI:AddSection(title, order)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Parent = self.ContentContainer
    section.Size = UDim2.new(1, -20, 0, 40)
    section.BackgroundColor3 = self.Theme.Surface
    section.BackgroundTransparency = 0
    section.BorderSizePixel = 0
    section.LayoutOrder = order or #self.Elements + 1
    
    local corner = Instance.new("UICorner")
    corner.Parent = section
    corner.CornerRadius = UDim.new(0, 6)
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Parent = section
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 15, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title:upper()
    sectionTitle.TextColor3 = self.Theme.Accent
    sectionTitle.TextSize = 14
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    table.insert(self.Elements, section)
    return section
end

-- Create button
function ModernUI:AddButton(text, callback, order)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Parent = self.ContentContainer
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = self.Theme.Surface
    button.Text = text
    button.TextColor3 = self.Theme.Text
    button.TextSize = 16
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.LayoutOrder = order or #self.Elements + 1
    
    local corner = Instance.new("UICorner")
    corner.Parent = button
    corner.CornerRadius = UDim.new(0, 6)
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = button
    uiStroke.Color = self.Theme.Accent
    uiStroke.Thickness = 0
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
        -- Animation
        uiStroke.Thickness = 2
        task.wait(0.1)
        uiStroke.Thickness = 0
    end)
    
    table.insert(self.Elements, button)
    return button
end

-- Create input box
function ModernUI:AddInputBox(placeholder, callback, order)
    local frame = Instance.new("Frame")
    frame.Name = "InputBox_" .. placeholder
    frame.Parent = self.ContentContainer
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundColor3 = self.Theme.Surface
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order or #self.Elements + 1
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)
    
    local input = Instance.new("TextBox")
    input.Parent = frame
    input.Size = UDim2.new(1, -20, 1, -10)
    input.Position = UDim2.new(0, 10, 0, 5)
    input.BackgroundColor3 = self.Theme.Background
    input.Text = ""
    input.PlaceholderText = placeholder
    input.TextColor3 = self.Theme.Text
    input.PlaceholderColor3 = self.Theme.TextSecondary
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.Parent = input
    inputCorner.CornerRadius = UDim.new(0, 4)
    
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(input.Text)
        end
    end)
    
    table.insert(self.Elements, frame)
    return input
end

-- Create toggle
function ModernUI:AddToggle(text, default, callback, order)
    local frame = Instance.new("Frame")
    frame.Name = "Toggle_" .. text
    frame.Parent = self.ContentContainer
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = self.Theme.Surface
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order or #self.Elements + 1
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0, 5)
    toggleBtn.BackgroundColor3 = default and self.Theme.Success or self.Theme.Danger
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = self.Theme.Text
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    local toggled = default or false
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.BackgroundColor3 = toggled and self.Theme.Success or self.Theme.Danger
        toggleBtn.Text = toggled and "ON" or "OFF"
        if callback then callback(toggled) end
    end)
    
    table.insert(self.Elements, frame)
    return {Toggle = toggleBtn, Value = toggled}
end

-- Create text label
function ModernUI:AddText(text, order)
    local label = Instance.new("TextLabel")
    label.Name = "Text_" .. text
    label.Parent = self.ContentContainer
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Theme.TextSecondary
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = order or #self.Elements + 1
    
    table.insert(self.Elements, label)
    return label
end

-- Create dropdown
function ModernUI:AddDropdown(title, options, callback, order)
    local frame = Instance.new("Frame")
    frame.Name = "Dropdown_" .. title
    frame.Parent = self.ContentContainer
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = self.Theme.Surface
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order or #self.Elements + 1
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.5, -15, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = frame
    dropdownBtn.Size = UDim2.new(0.5, -15, 0, 30)
    dropdownBtn.Position = UDim2.new(0.5, 5, 0, 5)
    dropdownBtn.BackgroundColor3 = self.Theme.Background
    dropdownBtn.Text = options[1] or "Select"
    dropdownBtn.TextColor3 = self.Theme.Text
    dropdownBtn.TextSize = 14
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = dropdownBtn
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    local dropdownOpen = false
    local dropdownFrame = nil
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if dropdownOpen then
            if dropdownFrame then dropdownFrame:Destroy() end
            dropdownOpen = false
            return
        end
        
        dropdownOpen = true
        dropdownFrame = Instance.new("Frame")
        dropdownFrame.Parent = frame
        dropdownFrame.Size = UDim2.new(0.5, -15, 0, #options * 30)
        dropdownFrame.Position = UDim2.new(0.5, 5, 0, 40)
        dropdownFrame.BackgroundColor3 = self.Theme.Background
        dropdownFrame.BackgroundTransparency = 0
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ZIndex = 2
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.Parent = dropdownFrame
        frameCorner.CornerRadius = UDim.new(0, 4)
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropdownFrame
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 2)
        
        for i, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Parent = dropdownFrame
            optionBtn.Size = UDim2.new(1, -10, 0, 30)
            optionBtn.Position = UDim2.new(0, 5, 0, 0)
            optionBtn.BackgroundColor3 = self.Theme.Surface
            optionBtn.Text = option
            optionBtn.TextColor3 = self.Theme.Text
            optionBtn.TextSize = 12
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.BorderSizePixel = 0
            optionBtn.LayoutOrder = i
            
            local optCorner = Instance.new("UICorner")
            optCorner.Parent = optionBtn
            optCorner.CornerRadius = UDim.new(0, 3)
            
            optionBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                if callback then callback(option) end
                dropdownFrame:Destroy()
                dropdownOpen = false
            end)
        end
        
        frame.Size = UDim2.new(1, -20, 0, 40 + (#options * 30))
    end)
    
    table.insert(self.Elements, frame)
    return dropdownBtn
end

-- Create multi-dropdown
function ModernUI:AddMultiDropdown(title, options, callback, order)
    local frame = Instance.new("Frame")
    frame.Name = "MultiDropdown_" .. title
    frame.Parent = self.ContentContainer
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.BackgroundColor3 = self.Theme.Surface
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order or #self.Elements + 1
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = self.Theme.Accent
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local selectedValues = {}
    local buttons = {}
    
    for i, option in ipairs(options) do
        local checkBtn = Instance.new("TextButton")
        checkBtn.Parent = frame
        checkBtn.Size = UDim2.new(0, 100, 0, 30)
        checkBtn.Position = UDim2.new(0, 10 + ((i-1) * 105), 0, 25)
        checkBtn.BackgroundColor3 = self.Theme.Background
        checkBtn.Text = option
        checkBtn.TextColor3 = self.Theme.Text
        checkBtn.TextSize = 12
        checkBtn.Font = Enum.Font.Gotham
        checkBtn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = checkBtn
        btnCorner.CornerRadius = UDim.new(0, 4)
        
        checkBtn.MouseButton1Click:Connect(function()
            if selectedValues[option] then
                selectedValues[option] = nil
                checkBtn.BackgroundColor3 = self.Theme.Background
            else
                selectedValues[option] = true
                checkBtn.BackgroundColor3 = self.Theme.Accent
            end
            
            if callback then
                local selected = {}
                for k, v in pairs(selectedValues) do
                    table.insert(selected, k)
                end
                callback(selected)
            end
        end)
        
        table.insert(buttons, checkBtn)
    end
    
    table.insert(self.Elements, frame)
    return buttons
end

-- Update canvas size
function ModernUI:UpdateCanvas()
    task.wait(0.1)
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, self.ListLayout.AbsoluteContentSize.Y)
end

-- Show UI
function ModernUI:Show()
    self.ScreenGui.Enabled = true
end

-- Hide UI
function ModernUI:Hide()
    self.ScreenGui.Enabled = false
end

-- Destroy UI
function ModernUI:Destroy()
    self.ScreenGui:Destroy()
end

-- Example usage
local UI = ModernUI.new("My Awesome UI", UDim2.new(0, 600, 0, 700))

-- Add components
UI:AddSection("Controls", 1)
UI:AddButton("Click Me!", function()
    print("Button clicked!")
end, 2)

UI:AddInputBox("Enter your name...", function(value)
    print("Input:", value)
end, 3)

local toggle = UI:AddToggle("Enable Feature", false, function(value)
    print("Toggle:", value)
end, 4)

UI:AddText("This is a text label", 5)

UI:AddDropdown("Choose Option", {"Option 1", "Option 2", "Option 3"}, function(value)
    print("Selected:", value)
end, 6)

UI:AddMultiDropdown("Select Multiple", {"Item 1", "Item 2", "Item 3", "Item 4"}, function(values)
    print("Selected values:", table.concat(values, ", "))
end, 7)

UI:UpdateCanvas()

-- Return the library
return ModernUI
