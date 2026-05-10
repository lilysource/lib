local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lilysource/lib/refs/heads/main/ChiroroUI.luau"))()
local Window = Library:CreateWindow({
    Title = "Chiroro Hub",
    SubTitle = "v1.0",
    Size = UDim2.fromOffset(800, 600),
    Acrylic = true
})

local MainTab = Window:CreateTab({Title = "Main"})
MainTab:CreateButton({
    Title = "Click",
    Callback = function() print("Clicked!") end
})
