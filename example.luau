-- Modern UI Library - Complete Window System
local ModernLibrary = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Create main window creator
function ModernLibrary:CreateWindow(config)
    config = config or {}
    local Window = {}
    
    -- Window Properties
    Window.Title = config.Title or "Modern UI"
    Window.SubTitle = config.SubTitle or "Library"
    Window.Size = config.Size or UDim2.fromOffset(830, 525)
    Window.MinSize = config.MinSize or Vector2.new(470, 380)
    Window.Resize = config.Resize or true
    Window.Theme = config.Theme or "Dark"
    Window.Acrylic = config.Acrylic or false
    Window.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    
    -- Theme Colors
    Window.Colors = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 30),
            Surface = Color3.fromRGB(35, 35, 40),
            Primary = Color3.fromRGB(0, 120, 255),
            Secondary = Color3.fromRGB(60, 60, 65),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 200, 200),
            Danger = Color3.fromRGB(255, 50, 50),
            Success = Color3.fromRGB(50, 255, 50),
            Border = Color3.fromRGB(45, 45, 50)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 245),
            Surface = Color3.fromRGB(255, 255, 255),
            Primary = Color3.fromRGB(0, 120, 255),
            Secondary = Color3.fromRGB(230, 230, 235),
            Text = Color3.fromRGB(0, 0, 0),
            TextSecondary = Color3.fromRGB(100, 100, 100),
            Danger = Color3.fromRGB(255, 50, 50),
            Success = Color3.fromRGB(50, 255, 50),
            Border = Color3.fromRGB(220, 220, 225)
        }
    }
    
    Window.CurrentColors = Window.Colors[Window.Theme]
    
    -- Create GUI
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "ModernLibrary"
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Window Frame
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainFrame"
    Window.MainFrame.Parent = Window.ScreenGui
    Window.MainFrame.Size = Window.Size
    Window.MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    Window.MainFrame.BackgroundColor3 = Window.CurrentColors.Background
    Window.MainFrame.BackgroundTransparency = Window.Acrylic and 0.3 or 0
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.ClipsDescendants = true
    
    -- Acrylic blur effect
    if Window.Acrylic then
        local blur = Instance.new("BlurEffect")
        blur.Name = "AcrylicBlur"
        blur.Parent = Window.ScreenGui
        blur.Size = 12
        
        -- Local script for dynamic blur
        local blurScript = Instance.new("LocalScript")
        blurScript.Parent = Window.ScreenGui
        blurScript.Source = [[
            local blur = script.Parent:FindFirstChild("AcrylicBlur")
            local runService = game:GetService("RunService")
            
            runService.RenderStepped:Connect(function()
                if blur then
                    blur.Enabled = true
                end
            end)
        ]]
    end
    
    -- Corner rounding
    local mainCorner = Instance.new("UICorner")
    mainCorner.Parent = Window.MainFrame
    mainCorner.CornerRadius = UDim.new(0, 10)
    
    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = Window.MainFrame
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.Parent = shadow
    shadowCorner.CornerRadius = UDim.new(0, 12)
    
    -- Title Bar
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Name = "TitleBar"
    Window.TitleBar.Parent = Window.MainFrame
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    Window.TitleBar.BackgroundColor3 = Window.CurrentColors.Surface
    Window.TitleBar.BackgroundTransparency = 0
    Window.TitleBar.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.Parent = Window.TitleBar
    titleCorner.CornerRadius = UDim.new(0, 10)
    
    -- Logo
    Window.Logo = Instance.new("ImageLabel")
    Window.Logo.Name = "Logo"
    Window.Logo.Parent = Window.TitleBar
    Window.Logo.Size = UDim2.new(0, 32, 0, 32)
    Window.Logo.Position = UDim2.new(0, 12, 0, 9)
    Window.Logo.BackgroundTransparency = 1
    Window.Logo.Image = "rbxassetid://6031098374" -- Roblox logo, replace with custom
    Window.Logo.ImageColor3 = Window.CurrentColors.Primary
    
    -- Title Text
    Window.TitleText = Instance.new("TextLabel")
    Window.TitleText.Name = "TitleText"
    Window.TitleText.Parent = Window.TitleBar
    Window.TitleText.Size = UDim2.new(0.5, -50, 1, 0)
    Window.TitleText.Position = UDim2.new(0, 55, 0, 0)
    Window.TitleText.BackgroundTransparency = 1
    Window.TitleText.Text = Window.Title
    Window.TitleText.TextColor3 = Window.CurrentColors.Text
    Window.TitleText.TextSize = 18
    Window.TitleText.Font = Enum.Font.GothamSemibold
    Window.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    Window.TitleText.TextYAlignment = Enum.TextYAlignment.Center
    
    -- Subtitle Text
    Window.SubTitleText = Instance.new("TextLabel")
    Window.SubTitleText.Name = "SubTitleText"
    Window.SubTitleText.Parent = Window.TitleBar
    Window.SubTitleText.Size = UDim2.new(0.5, -50, 1, 0)
    Window.SubTitleText.Position = UDim2.new(0, 55, 0, 20)
    Window.SubTitleText.BackgroundTransparency = 1
    Window.SubTitleText.Text = Window.SubTitle
    Window.SubTitleText.TextColor3 = Window.CurrentColors.TextSecondary
    Window.SubTitleText.TextSize = 11
    Window.SubTitleText.Font = Enum.Font.Gotham
    Window.SubTitleText.TextXAlignment = Enum.TextXAlignment.Left
    Window.SubTitleText.TextYAlignment = Enum.TextYAlignment.Center
    
    -- Window Control Buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Parent = Window.TitleBar
    buttonFrame.Size = UDim2.new(0, 120, 1, 0)
    buttonFrame.Position = UDim2.new(1, -125, 0, 0)
    buttonFrame.BackgroundTransparency = 1
    
    -- Minimize Button
    Window.MinimizeBtn = Instance.new("TextButton")
    Window.MinimizeBtn.Name = "MinimizeBtn"
    Window.MinimizeBtn.Parent = buttonFrame
    Window.MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    Window.MinimizeBtn.Position = UDim2.new(0, 5, 0, 7.5)
    Window.MinimizeBtn.BackgroundColor3 = Window.CurrentColors.Secondary
    Window.MinimizeBtn.Text = "−"
    Window.MinimizeBtn.TextColor3 = Window.CurrentColors.Text
    Window.MinimizeBtn.TextSize = 24
    Window.MinimizeBtn.Font = Enum.Font.Gotham
    Window.MinimizeBtn.BorderSizePixel = 0
    
    local minCorner = Instance.new("UICorner")
    minCorner.Parent = Window.MinimizeBtn
    minCorner.CornerRadius = UDim.new(0, 6)
    
    -- Maximize Button
    Window.MaximizeBtn = Instance.new("TextButton")
    Window.MaximizeBtn.Name = "MaximizeBtn"
    Window.MaximizeBtn.Parent = buttonFrame
    Window.MaximizeBtn.Size = UDim2.new(0, 35, 0, 35)
    Window.MaximizeBtn.Position = UDim2.new(0, 45, 0, 7.5)
    Window.MaximizeBtn.BackgroundColor3 = Window.CurrentColors.Secondary
    Window.MaximizeBtn.Text = "□"
    Window.MaximizeBtn.TextColor3 = Window.CurrentColors.Text
    Window.MaximizeBtn.TextSize = 18
    Window.MaximizeBtn.Font = Enum.Font.Gotham
    Window.MaximizeBtn.BorderSizePixel = 0
    
    local maxCorner = Instance.new("UICorner")
    maxCorner.Parent = Window.MaximizeBtn
    maxCorner.CornerRadius = UDim.new(0, 6)
    
    -- Close Button
    Window.CloseBtn = Instance.new("TextButton")
    Window.CloseBtn.Name = "CloseBtn"
    Window.CloseBtn.Parent = buttonFrame
    Window.CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    Window.CloseBtn.Position = UDim2.new(0, 85, 0, 7.5)
    Window.CloseBtn.BackgroundColor3 = Window.CurrentColors.Danger
    Window.CloseBtn.Text = "✕"
    Window.CloseBtn.TextColor3 = Window.CurrentColors.Text
    Window.CloseBtn.TextSize = 16
    Window.CloseBtn.Font = Enum.Font.Gotham
    Window.CloseBtn.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = Window.CloseBtn
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    -- Tab Container
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Name = "TabContainer"
    Window.TabContainer.Parent = Window.MainFrame
    Window.TabContainer.Size = UDim2.new(1, 0, 0, 40)
    Window.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    Window.TabContainer.BackgroundColor3 = Window.CurrentColors.Surface
    Window.TabContainer.BackgroundTransparency = 0
    Window.TabContainer.BorderSizePixel = 0
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.Parent = Window.TabContainer
    tabCorner.CornerRadius = UDim.new(0, 0)
    
    -- Tab Layout
    Window.TabLayout = Instance.new("UIListLayout")
    Window.TabLayout.Parent = Window.TabContainer
    Window.TabLayout.FillDirection = Enum.FillDirection.Horizontal
    Window.TabLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    Window.Content = Instance.new("ScrollingFrame")
    Window.Content.Name = "Content"
    Window.Content.Parent = Window.MainFrame
    Window.Content.Size = UDim2.new(1, -20, 1, -110)
    Window.Content.Position = UDim2.new(0, 10, 0, 95)
    Window.Content.BackgroundTransparency = 1
    Window.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.Content.ScrollBarThickness = 6
    Window.Content.ScrollBarImageColor3 = Window.CurrentColors.Primary
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = Window.Content
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    
    Window.ContentLayout = contentLayout
    
    -- Tabs storage
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Dragging variables
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    Window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.MainFrame.Position
        end
    end)
    
    Window.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Resizing functionality
    if Window.Resize then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Parent = Window.MainFrame
        resizeHandle.Size = UDim2.new(0, 15, 0, 15)
        resizeHandle.Position = UDim2.new(1, -15, 1, -15)
        resizeHandle.BackgroundColor3 = Window.CurrentColors.Primary
        resizeHandle.BackgroundTransparency = 0.5
        resizeHandle.Cursor = Enum.Cursor.SizeNESW
        
        local resizeCorner = Instance.new("UICorner")
        resizeCorner.Parent = resizeHandle
        resizeCorner.CornerRadius = UDim.new(0, 3)
        
        local resizing = false
        local startSize = nil
        local startMousePos = nil
        
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                startSize = Window.MainFrame.Size
                startMousePos = input.Position
            end
        end)
        
        resizeHandle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startMousePos
                local newSize = UDim2.new(
                    startSize.X.Scale,
                    math.max(Window.MinSize.X, startSize.X.Offset + delta.X),
                    startSize.Y.Scale,
                    math.max(Window.MinSize.Y, startSize.Y.Offset + delta.Y)
                )
                Window.MainFrame.Size = newSize
                Window.Content.CanvasSize = UDim2.new(0, 0, 0, Window.ContentLayout.AbsoluteContentSize.Y)
            end
        end)
    end
    
    -- Window controls
    local isMinimized = false
    local isMaximized = false
    local previousSize = nil
    local previousPosition = nil
    
    Window.MinimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            previousSize = Window.MainFrame.Size
            previousPosition = Window.MainFrame.Position
            Window.MainFrame.Size = UDim2.new(0, 250, 0, 50)
            Window.MainFrame.Position = UDim2.new(1, -260, 0, 10)
            isMinimized = true
        else
            Window.MainFrame.Size = previousSize
            Window.MainFrame.Position = previousPosition
            isMinimized = false
        end
    end)
    
    Window.MaximizeBtn.MouseButton1Click:Connect(function()
        if not isMaximized then
            previousSize = Window.MainFrame.Size
            previousPosition = Window.MainFrame.Position
            Window.MainFrame.Size = UDim2.new(1, 0, 1, 0)
            Window.MainFrame.Position = UDim2.new(0, 0, 0, 0)
            isMaximized = true
        else
            Window.MainFrame.Size = previousSize
            Window.MainFrame.Position = previousPosition
            isMaximized = false
        end
    end)
    
    Window.CloseBtn.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)
    
    -- Keyboard shortcut for minimize
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.MinimizeKey then
            if not isMinimized then
                previousSize = Window.MainFrame.Size
                previousPosition = Window.MainFrame.Position
                Window.MainFrame.Size = UDim2.new(0, 250, 0, 50)
                Window.MainFrame.Position = UDim2.new(1, -260, 0, 10)
                isMinimized = true
            else
                Window.MainFrame.Size = previousSize
                Window.MainFrame.Position = previousPosition
                isMinimized = false
            end
        end
    end)
    
    -- Create Tab function
    function Window:CreateTab(tabConfig)
        local tab = {}
        tab.Title = tabConfig.Title or "Tab"
        tab.Icon = tabConfig.Icon or ""
        
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tab.Title
        tabBtn.Parent = Window.TabContainer
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.BackgroundColor3 = Window.CurrentColors.Surface
        tabBtn.Text = "  " .. tab.Title
        tabBtn.TextColor3 = Window.CurrentColors.Text
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.BorderSizePixel = 0
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.Parent = tabBtn
        tabCorner.CornerRadius = UDim.new(0, 6)
        
        -- Tab content frame
        tab.Content = Instance.new("Frame")
        tab.Content.Name = "Content_" .. tab.Title
        tab.Content.Parent = Window.Content
        tab.Content.Size = UDim2.new(1, 0, 0, 0)
        tab.Content.BackgroundTransparency = 1
        tab.Content.Visible = false
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Parent = tab.Content
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 10)
        
        tab.Elements = {}
        
        -- Tab switching
        tabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                for _, btn in pairs(Window.Tabs) do
                    if btn.Button then
                        btn.Button.BackgroundColor3 = Window.CurrentColors.Surface
                    end
                end
            end
            
            tab.Content.Visible = true
            tabBtn.BackgroundColor3 = Window.CurrentColors.Primary
            Window.CurrentTab = tab
            
            -- Update canvas size
            task.wait()
            Window.Content.CanvasSize = UDim2.new(0, 0, 0, Window.ContentLayout.AbsoluteContentSize.Y)
        end)
        
        -- Store tab
        table.insert(Window.Tabs, {Button = tabBtn, Content = tab.Content, Tab = tab})
        
        -- Create section
        function tab:AddSection(sectionConfig)
            local section = {}
            section.Title = sectionConfig.Title or "Section"
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "Section_" .. section.Title
            sectionFrame.Parent = tab.Content
            sectionFrame.Size = UDim2.new(1, -20, 0, 40)
            sectionFrame.BackgroundColor3 = Window.CurrentColors.Surface
            sectionFrame.BackgroundTransparency = 0
            sectionFrame.BorderSizePixel = 0
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.Parent = sectionFrame
            sectionCorner.CornerRadius = UDim.new(0, 8)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Parent = sectionFrame
            sectionTitle.Size = UDim2.new(1, -20, 1, 0)
            sectionTitle.Position = UDim2.new(0, 15, 0, 0)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = section.Title:upper()
            sectionTitle.TextColor3 = Window.CurrentColors.Primary
            sectionTitle.TextSize = 13
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            section.Container = sectionFrame
            
            table.insert(tab.Elements, sectionFrame)
            
            return section
        end
        
        -- Create button
        function tab:CreateButton(btnConfig)
            local button = {}
            button.Title = btnConfig.Title or "Button"
            button.Callback = btnConfig.Callback or function() end
            
            local btn = Instance.new("TextButton")
            btn.Name = "Button_" .. button.Title
            btn.Parent = tab.Content
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.BackgroundColor3 = Window.CurrentColors.Surface
            btn.Text = button.Title
            btn.TextColor3 = Window.CurrentColors.Text
            btn.TextSize = 15
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.Parent = btn
            btnCorner.CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(function()
                button.Callback()
                -- Animation
                local stroke = Instance.new("UIStroke")
                stroke.Parent = btn
                stroke.Color = Window.CurrentColors.Primary
                stroke.Thickness = 2
                task.wait(0.1)
                stroke:Destroy()
            end)
            
            table.insert(tab.Elements, btn)
            
            return button
        end
        
        -- Create input box
        function tab:CreateInput(inputConfig)
            local input = {}
            input.Title = inputConfig.Title or "Input"
            input.Placeholder = inputConfig.Placeholder or "Enter text..."
            input.Callback = inputConfig.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Name = "Input_" .. input.Title
            frame.Parent = tab.Content
            frame.Size = UDim2.new(1, -20, 0, 50)
            frame.BackgroundColor3 = Window.CurrentColors.Surface
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.Parent = frame
            frameCorner.CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = input.Title
            label.TextColor3 = Window.CurrentColors.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local textBox = Instance.new("TextBox")
            textBox.Parent = frame
            textBox.Size = UDim2.new(1, -20, 0, 25)
            textBox.Position = UDim2.new(0, 10, 0, 20)
            textBox.BackgroundColor3 = Window.CurrentColors.Background
            textBox.Text = ""
            textBox.PlaceholderText = input.Placeholder
            textBox.TextColor3 = Window.CurrentColors.Text
            textBox.PlaceholderColor3 = Window.CurrentColors.TextSecondary
            textBox.TextSize = 14
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.Parent = textBox
            boxCorner.CornerRadius = UDim.new(0, 4)
            
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    input.Callback(textBox.Text)
                end
            end)
            
            table.insert(tab.Elements, frame)
            
            return input
        end
        
        -- Create toggle
        function tab:CreateToggle(toggleConfig)
            local toggle = {}
            toggle.Title = toggleConfig.Title or "Toggle"
            toggle.Default = toggleConfig.Default or false
            toggle.Callback = toggleConfig.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Name = "Toggle_" .. toggle.Title
            frame.Parent = tab.Content
            frame.Size = UDim2.new(1, -20, 0, 40)
            frame.BackgroundColor3 = Window.CurrentColors.Surface
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.Parent = frame
            frameCorner.CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggle.Title
            label.TextColor3 = Window.CurrentColors.Text
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = frame
            toggleBtn.Size = UDim2.new(0, 50, 0, 30)
            toggleBtn.Position = UDim2.new(1, -60, 0, 5)
            toggleBtn.BackgroundColor3 = toggle.Default and Window.CurrentColors.Success or Window.CurrentColors.Danger
            toggleBtn.Text = toggle.Default and "ON" or "OFF"
            toggleBtn.TextColor3 = Window.CurrentColors.Text
            toggleBtn.TextSize = 12
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.BorderSizePixel = 0
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.Parent = toggleBtn
            toggleCorner.CornerRadius = UDim.new(1, 0)
            
            local toggled = toggle.Default
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and Window.CurrentColors.Success or Window.CurrentColors.Danger
                toggleBtn.Text = toggled and "ON" or "OFF"
                toggle.Callback(toggled)
            end)
            
            table.insert(tab.Elements, frame)
            
            return toggle
        end
        
        -- Create dropdown
        function tab:CreateDropdown(dropdownConfig)
            local dropdown = {}
            dropdown.Title = dropdownConfig.Title or "Dropdown"
            dropdown.Options = dropdownConfig.Options or {"Option 1", "Option 2", "Option 3"}
            dropdown.Callback = dropdownConfig.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Name = "Dropdown_" .. dropdown.Title
            frame.Parent = tab.Content
            frame.Size = UDim2.new(1, -20, 0, 50)
            frame.BackgroundColor3 = Window.CurrentColors.Surface
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.Parent = frame
            frameCorner.CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = dropdown.Title
            label.TextColor3 = Window.CurrentColors.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Parent = frame
            dropdownBtn.Size = UDim2.new(1, -20, 0, 30)
            dropdownBtn.Position = UDim2.new(0, 10, 0, 20)
            dropdownBtn.BackgroundColor3 = Window.CurrentColors.Background
            dropdownBtn.Text = dropdown.Options[1]
            dropdownBtn.TextColor3 = Window.CurrentColors.Text
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
                    frame.Size = UDim2.new(1, -20, 0, 50)
                    return
                end
                
                dropdownOpen = true
                dropdownFrame = Instance.new("Frame")
                dropdownFrame.Parent = frame
                dropdownFrame.Size = UDim2.new(1, -20, 0, #dropdown.Options * 35)
                dropdownFrame.Position = UDim2.new(0, 10, 0, 50)
                dropdownFrame.BackgroundColor3 = Window.CurrentColors.Background
                dropdownFrame.BackgroundTransparency = 0
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.ZIndex = 2
                
                local dropCorner = Instance.new("UICorner")
                dropCorner.Parent = dropdownFrame
                dropCorner.CornerRadius = UDim.new(0, 4)
                
                local optionLayout = Instance.new("UIListLayout")
                optionLayout.Parent = dropdownFrame
                optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionLayout.Padding = UDim.new(0, 2)
                
                for i, option in ipairs(dropdown.Options) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Parent = dropdownFrame
                    optionBtn.Size = UDim2.new(1, -10, 0, 30)
                    optionBtn.Position = UDim2.new(0, 5, 0, 0)
                    optionBtn.BackgroundColor3 = Window.CurrentColors.Surface
                    optionBtn.Text = option
                    optionBtn.TextColor3 = Window.CurrentColors.Text
                    optionBtn.TextSize = 13
                    optionBtn.Font = Enum.Font.Gotham
                    optionBtn.BorderSizePixel = 0
                    optionBtn.LayoutOrder = i
                    
                    local optCorner = Instance.new("UICorner")
                    optCorner.Parent = optionBtn
                    optCorner.CornerRadius = UDim.new(0, 3)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = option
                        dropdown.Callback(option)
                        dropdownFrame:Destroy()
                        dropdownOpen = false
                        frame.Size = UDim2.new(1, -20, 0, 50)
                    end)
                end
                
                frame.Size = UDim2.new(1, -20, 0, 50 + (#dropdown.Options * 35))
            end)
            
            table.insert(tab.Elements, frame)
            
            return dropdown
        end
        
        -- Create multi-dropdown
        function tab:CreateMultiDropdown(multidropdownConfig)
            local multidropdown = {}
            multidropdown.Title = multidropdownConfig.Title or "Multi-Select"
            multidropdown.Options = multidropdownConfig.Options or {"Item 1", "Item 2", "Item 3"}
            multidropdown.Callback = multidropdownConfig.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Name = "MultiDropdown_" .. multidropdown.Title
            frame.Parent = tab.Content
            frame.Size = UDim2.new(1, -20, 0, 80)
            frame.BackgroundColor3 = Window.CurrentColors.Surface
            frame.BackgroundTransparency = 0
            frame.BorderSizePixel = 0
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.Parent = frame
            frameCorner.CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = multidropdown.Title
            label.TextColor3 = Window.CurrentColors.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local selectedValues = {}
            local buttons = {}
            
            for i, option in ipairs(multidropdown.Options) do
                local checkBtn = Instance.new("TextButton")
                checkBtn.Parent = frame
                checkBtn.Size = UDim2.new(0, 100, 0, 30)
                checkBtn.Position = UDim2.new(0, 10 + ((i-1) % 4) * 105, 0, 30 + math.floor((i-1)/4) * 35)
                checkBtn.BackgroundColor3 = Window.CurrentColors.Background
                checkBtn.Text = option
                checkBtn.TextColor3 = Window.CurrentColors.Text
                checkBtn.TextSize = 12
                checkBtn.Font = Enum.Font.Gotham
                checkBtn.BorderSizePixel = 0
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.Parent = checkBtn
                btnCorner.CornerRadius = UDim.new(0, 4)
                
                checkBtn.MouseButton1Click:Connect(function()
                    if selectedValues[option] then
                        selectedValues[option] = nil
                        checkBtn.BackgroundColor3 = Window.CurrentColors.Background
                    else
                        selectedValues[option] = true
                        checkBtn.BackgroundColor3 = Window.CurrentColors.Primary
                    end
                    
                    local selected = {}
                    for k, v in pairs(selectedValues) do
                        table.insert(selected, k)
                    end
                    multidropdown.Callback(selected)
                end)
                
                table.insert(buttons, checkBtn)
            end
            
           
