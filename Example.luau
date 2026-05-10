local Library = loadstring(game:HttpGet("your-raw-url-here"))()
local Window = Library:CreateWindow({
    Title = "My Script",
    SubTitle = "v1.0",
    Size = UDim2.fromOffset(800, 600),
    Acrylic = true
})

local MainTab = Window:CreateTab({Title = "Main"})
MainTab:CreateButton({
    Title = "Click",
    Callback = function() print("Clicked!") end
})
