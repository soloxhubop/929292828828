--[[
    APPLE HUB ðŸŽ - FINAL MINI EDITION
    Mniejsze UI + BiaÅ‚e napisy ESP + Spam Nearest Fix
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer

-- --- KONFIGURACJA POZYCJI ---
local pos1 = Vector3.new(-352.98, -7, 74.30)
local pos2 = Vector3.new(-352.98, -6.49, 45.76)
local spot1_sequence = {
    CFrame.new(-370.8, -7, 41.2),
    CFrame.new(-336.3, -5.1, 17.2)
}
local spot2_sequence = {
    CFrame.new(-354.7, -7, 92.8),
    CFrame.new(-336.9, -5.1, 99.3)
}

-- --- ZMIENNE STANU ---
local _G = getgenv and getgenv() or _G
_G.SemiTPEnabled = false
_G.AutoPotion = false
_G.SpeedAfterSteal = false
_G.SpeedBoost = 28
_G.SpeedConnection = nil
_G.IsHolding = false

-- --- UI SETUP ---
if CoreGui:FindFirstChild("AppleHubMini") then
    CoreGui.AppleHubMini:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AppleHubMini"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local BackgroundEffect = Instance.new("Frame")
local EffectGradient = Instance.new("UIGradient")
local TitleLabel = Instance.new("TextLabel")
local ContentContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")

-- 1. GÅÃ“WNA RAMKA (MNIEJSZA)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 0, 0) -- Ciemna czerwieÅ„
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -125) -- WyÅ›rodkowanie
MainFrame.Size = UDim2.new(0, 180, 0, 250) -- MAÅE ROZMIARY
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 2. EFEKT TÅA (ZIndex 1 - Na samym dole)
BackgroundEffect.Name = "Shine"
BackgroundEffect.Parent = MainFrame
BackgroundEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BackgroundEffect.BackgroundTransparency = 0.92
BackgroundEffect.Size = UDim2.new(2, 0, 2, 0)
BackgroundEffect.Position = UDim2.new(-0.5, 0, -0.5, 0)
BackgroundEffect.ZIndex = 1
BackgroundEffect.Active = false

EffectGradient.Parent = BackgroundEffect
EffectGradient.Rotation = 45
EffectGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

task.spawn(function()
    local rot = 0
    while MainFrame.Parent do
        rot = rot + 1
        EffectGradient.Rotation = rot
        task.wait(0.03)
    end
end)

-- 3. TYTUÅ (ZIndex 5)
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 20)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "APPLE HUB ðŸŽ"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.ZIndex = 5

-- 4. KONTENER NA PRZYCISKI (ZIndex 10 - NA WIERZCHU)
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 30)
ContentContainer.Size = UDim2.new(1, 0, 1, -50)
ContentContainer.ScrollBarThickness = 2
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ZIndex = 10

UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

UIPadding.Parent = ContentContainer
UIPadding.PaddingTop = UDim.new(0, 2)

-- 5. STOPKA
local FooterLabel = Instance.new("TextLabel")
FooterLabel.Parent = MainFrame
FooterLabel.BackgroundTransparency = 1
FooterLabel.Position = UDim2.new(0, 0, 1, -15)
FooterLabel.Size = UDim2.new(1, 0, 0, 15)
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.Text = "discord.gg/VNAh8n9Pk"
FooterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FooterLabel.TextSize = 8
FooterLabel.ZIndex = 5

-- --- FUNKCJE TWORZENIA PRZYCISKÃ“W ---

local function createToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ContentContainer
    frame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(0.9, 0, 0, 25)
    frame.ZIndex = 11
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Position = UDim2.new(1, -25, 0.5, -8)
    btn.Size = UDim2.new(0, 20, 0, 16)
    btn.Text = ""
    btn.ZIndex = 13
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
        callback(active)
    end)
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentContainer
    btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    btn.BackgroundTransparency = 0.2
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.ZIndex = 11
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 0)}):Play()
        callback()
    end)
end

-- --- LOGIKA (SILENT HUB REDUCED) ---

local function executeTP(sequence)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if root and hum and backpack then
        local carpet = backpack:FindFirstChild("Flying Carpet")
        if carpet then 
            hum:EquipTool(carpet)
            task.wait(0.1)
        end
        if sequence[1] then root.CFrame = sequence[1] end
        task.wait(0.1)
        if sequence[2] then root.CFrame = sequence[2] end
    end
end

-- --- TWORZENIE PRZYCISKÃ“W ---

createToggle("Half TP (Hold E)", function(val) 
    _G.SemiTPEnabled = val 
end)

createToggle("Auto Potion", function(val) 
    _G.AutoPotion = val 
end)

createToggle("Speed After Steal", function(val)
    _G.SpeedAfterSteal = val
    if not val and _G.SpeedConnection then
        _G.SpeedConnection:Disconnect()
        _G.SpeedConnection = nil
    end
end)

createButton("TP TO SPOT 1", function()
    executeTP(spot1_sequence)
end)

createButton("TP TO SPOT 2", function()
    executeTP(spot2_sequence)
end)

createButton("Spam Nearest", function() -- Zmiana nazwy tutaj
    local char = LocalPlayer.Character
    if not char then return end
    
    local nearest, dist = nil, 9999
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then dist = mag nearest = p end
        end
    end
    
    if nearest and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if ch then
            ch:SendAsync(";jumpscare " .. nearest.Name)
            task.wait(0.1)
            ch:SendAsync("tiny " .. nearest.Name)
        end
    end
end)

-- --- LISTENERS ---

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
    if plr ~= LocalPlayer or not _G.SemiTPEnabled then return end
    _G.IsHolding = true
    
    task.spawn(function()
        task.wait(0.5)
        if _G.IsHolding and _G.SemiTPEnabled then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                local carpet = backpack:FindFirstChild("Flying Carpet")
                if carpet and LocalPlayer.Character then
                    LocalPlayer.Character.Humanoid:EquipTool(carpet)
                end
            end
        end
    end)
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function()
    _G.IsHolding = false
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, plr)
    if plr ~= LocalPlayer or not _G.SemiTPEnabled then return end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local d1 = (root.Position - pos1).Magnitude
        local d2 = (root.Position - pos2).Magnitude
        local target = (d1 < d2) and pos1 or pos2
        
        if _G.AutoPotion then
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp and bp:FindFirstChild("Giant Potion") then
                char.Humanoid:EquipTool(bp["Giant Potion"])
                task.wait(0.1)
                pcall(function() char["Giant Potion"]:Activate() end)
            end
        end

        root.CFrame = CFrame.new(target)
        
        if _G.SpeedAfterSteal then
            if _G.SpeedConnection then _G.SpeedConnection:Disconnect() end
            _G.SpeedConnection = RunService.Heartbeat:Connect(function()
                if not _G.SpeedAfterSteal or not root.Parent then return end
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    local dir = char.Humanoid.MoveDirection.Unit
                    root.AssemblyLinearVelocity = Vector3.new(dir.X * _G.SpeedBoost, root.AssemblyLinearVelocity.Y, dir.Z * _G.SpeedBoost)
                end
            end)
        end
    end
    _G.IsHolding = false
end)

-- --- ESP (POPRAWIONA WERSJA) ---
local function esp(pos, name)
    local p = Instance.new("Part", workspace)
    p.Name = "ESP_" .. name
    p.Position = pos
    p.Anchored = true
    p.CanCollide = false
    p.Transparency = 1
    
    local bb = Instance.new("BillboardGui", p)
    bb.Size = UDim2.new(0,150,0,50)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 2, 0)
    
    local tl = Instance.new("TextLabel", bb)
    tl.Size = UDim2.new(1,0,1,0)
    tl.BackgroundTransparency = 1
    tl.Text = name
    
    -- STYL NAPISU: BIAÅY, GRUBY, Z OBRAMOWANIEM
    tl.TextColor3 = Color3.fromRGB(255, 255, 255) -- BiaÅ‚y
    tl.Font = Enum.Font.GothamBlack -- Gruba czcionka
    tl.TextSize = 20
    tl.TextStrokeTransparency = 0 -- Widoczna obwÃ³dka
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Czarna obwÃ³dka
end

esp(pos1, "Spot L")
esp(pos2, "Spot R")

print("APPLE HUB MINI: Loaded!")
