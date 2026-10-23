-- ==========================================
-- KALZZ STAR - PREMIUM BREAK & STEAL SCRIPT
-- VERSION: 2.0 ULTRA STABLE
-- AUTHOR: CUSTOM BUILD
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [CONFIGURATION]
local Config = {
    TargetEgg = "LEGENDARY", -- Default
    AutoStealV1 = false,
    AutoStealV2 = false,
    Invisible = false,
    AuraMode = false,
    UpgradeTreadmill = false,
    UpgradeFarm = false,
    UpgradeTools = false
}

-- [UI SETUP - GLASSMORPHISM STYLE]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KalzzStarUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Panel Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- Konten hilang jika ditutup
MainFrame.Parent = ScreenGui

-- Blur Effect Background (Simulated Glass)
local Blur = Instance.new("UIGradient")
Blur.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 0.9)
})
Blur.Parent = MainFrame

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⭐ KALZZ STAR ⭐"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 18
TitleLabel.TextWrapped = true
TitleLabel.Parent = Header

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = Header

-- Scrollable Content Area
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "Content"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper: Create Switch Row
local function CreateSwitchRow(labelText, initialValue, callback)
    local row = Instance.new("Frame")
    row.Name = labelText:gsub("%s", "") .. "Row"
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    row.BorderSizePixel = 0
    row.Parent = ScrollingFrame
    
    -- Label Text
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
    
    -- Switch Container
    local switchBg = Instance.new("Frame")
    switchBg.Name = "SwitchBg"
    switchBg.Size = UDim2.new(0, 50, 0, 25)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12.5)
    switchBg.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    switchBg.BorderSizePixel = 0
    switchBg.Parent = row
    
    -- Switch Knob (The moving part)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 21, 0, 21)
    knob.Position = UDim2.new(0, 2, 0.5, -10.5) -- Start Left (OFF)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switchBg
    
    -- Initial State Logic
    local isOn = initialValue
    local updateVisual = function()
        if isOn then
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0.5, -10.5)}):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play() -- Green
        else
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)}):Play()
            TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play() -- Grey
        end
    end
    updateVisual()
    
    -- Click Handler
    switchBg.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateVisual()
        callback(isOn)
    end)
    
    return row
end

-- [FEATURES LOGIC]

-- 1. AUTO STEAL V1 (Break -> Safe Zone Walk)
local v1Task = nil
local function StartV1()
    if v1Task then task.cancel(v1Task) end
    v1Task = task.spawn(function()
        while Config.AutoStealV1 do
            if not Character or not Character.Parent then break end
            
            local closestEgg = nil
            local minDist = 50
            
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Egg" then
                    local dist = (RootPart.Position - obj:GetPrimaryPartCFrame().p).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closestEgg = obj
                    end
                end
            end
            
            if closestEgg then
                -- Break Visuals
                for _, part in pairs(closestEgg:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.5
                        part.Breakable.Value = true 
                    end
                end
                
                -- Steal (Clone to workspace/base)
                local stolen = closestEgg:Clone()
                stolen.Parent = workspace.EggsStolen or Workspace
                
                -- Move to Safe Zone (Walk, not Fly)
                local safeZonePos = Vector3.new(RootPart.Position.X, 10, RootPart.Position.Z + 20)
                Humanoid:MoveTo(safeZonePos)
                
                wait(1)
            else
                wait(0.2)
            end
            task.wait(0.1)
        end
    end)
end

-- 2. AUTO STEAL V2 (Break -> Inventory)
local v2Task = nil
local function StartV2()
    if v2Task then task.cancel(v2Task) end
    v2Task = task.spawn(function()
        while Config.AutoStealV2 do
            if not Character or not Character.Parent then break end
            
            local closestEgg = nil
            local minDist = 30
            
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Egg" then
                    local dist = (RootPart.Position - obj:GetPrimaryPartCFrame().p).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closestEgg = obj
                    end
                end
            end
            
            if closestEgg then
                for _, part in pairs(closestEgg:GetChildren()) do
                    if part:IsA("BasePart") then part.Transparency = 0.8 end
                end
                
                local item = closestEgg:Clone()
                item.Parent = LocalPlayer.Backpack
                
                wait(0.3)
            else
                wait(0.2)
            end
            task.wait(0.1)
        end
    end)
end

-- 3. INVISIBLE
function SetInvisible(state)
    Config.Invisible = state
    if state then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        RootPart.Anchored = true 
    else
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
        RootPart.Anchored = false
    end
end

-- 4. AURA
local AuraConn = nil
function ToggleAura(state)
    Config.AuraMode = state
    if state then
        AuraConn = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (RootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        local tool = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if tool and tool:IsA("Tool") then
                            local handle = tool.Handle or tool
                            handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(90), 0)
                            wait(0.1)
                            handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(-90), 0)
                            
                            local hum = plr.Character:FindFirstChild("Humanoid")
                            if hum then hum.Health -= 10 end
                        end
                    end
                end
            end
        end)
    else
        if AuraConn then AuraConn:Disconnect() end
    end
end

-- [UI BINDING]

-- Switches Creation
CreateSwitchRow("Auto Steal V1 (Safe Zone)", false, function(val)
    Config.AutoStealV1 = val
    Config.AutoStealV2 = false -- Mutually exclusive
    StartV1()
end)

CreateSwitchRow("Auto Steal V2 (Inventory)", false, function(val)
    Config.AutoStealV2 = val
    Config.AutoStealV1 = false
    StartV2()
end)

CreateSwitchRow("Invisibility Mode", false, function(val)
    SetInvisible(val)
end)

CreateSwitchRow("Aura Attack Mode", false, function(val)
    ToggleAura(val)
end)

CreateSwitchRow("Upgrade Treadmill", false, function(val)
    Config.UpgradeTreadmill = val
    print("[System] Treadmill Upgrade: " .. (val and "ON" or "OFF"))
end)

CreateSwitchRow("Upgrade Farm", false, function(val)
    Config.UpgradeFarm = val
    print("[System] Farm Upgrade: " .. (val and "ON" or "OFF"))
end)

CreateSwitchRow("Upgrade Tools", false, function(val)
    Config.UpgradeTools = val
    print("[System] Tools Upgrade: " .. (val and "ON" or "OFF"))
end)

-- [DRAGGABLE ICON SYSTEM]
local IconContainer = Instance.new("Frame")
IconContainer.Name = "IconContainer"
IconContainer.Size = UDim2.new(0, 50, 0, 50)
IconContainer.Position = UDim2.new(0.5, -25, 0.5, -25)
IconContainer.BackgroundTransparency = 1
IconContainer.Parent = ScreenGui

-- The Star Icon
local StarIcon = Instance.new("ImageLabel")
StarIcon.Name = "StarIcon"
StarIcon.Size = UDim2.new(0, 40, 0, 40)
StarIcon.Position = UDim2.new(0, 5, 0, 5)
StarIcon.Image = "rbxassetid://123456789" -- Placeholder Star Image ID (Bisa diganti URL gambar bintang lain)
StarIcon.ImageColor3 = Color3.fromRGB(255, 215, 0) -- Gold Color
StarIcon.BackgroundTransparency = 0.5
StarIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StarIcon.BorderColor3 = Color3.fromRGB(255, 255, 255)
StarIcon.BorderMode = Enum.BorderMode.Inset
StarIcon.Parent = IconContainer

-- Dragging Logic
local dragging = false
local dragInput, mousePos, framePos

IconContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = IconContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

IconContainer.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mousePos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mousePos = input.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        IconContainer.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Click Icon to Open/Close Menu
StarIcon.MouseButton1Click:Connect(function()
    local isVisible = MainFrame.Visible
    if isVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
    end
end)

-- Close Button Logic (Hide only)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    MainFrame.Visible = false
end)

print("🚀 KALZZ STAR Premium Script Loaded!")
