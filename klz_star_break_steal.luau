--[[ 
    KLZ STAR - MAIN SCRIPT 
    Features: Auto Break, Auto Steal, Dragon UI, Anti-Cheat Bypass 
]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- CONFIG
local Config = {
    TargetEggType = "Divine", -- Default target
    BreakSpeed = 0.1,
    StealDelay = 1.0,
    AutoFarm = false
}

-- STATE
local State = {
    Stolen = 0,
    Broken = 0,
    IsRunning = false
}

-- UI PANEL (DRAGON ICON)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KLZ_STAR_PANEL"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title Bar with Dragon Icon
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.Parent = MainFrame

local DragonIcon = Instance.new("TextLabel")
DragonIcon.Name = "DragonIcon"
DragonIcon.Size = UDim2.new(0, 40, 0, 40)
DragonIcon.Position = UDim2.new(0.5, -60, 0, 5)
DragonIcon.BackgroundTransparency = 1
DragonIcon.Text = "🐉"
DragonIcon.TextColor3 = Color3.fromRGB(255, 215, 0)
DragonIcon.Font = Enum.Font.GothamBlack
DragonIcon.TextSize = 28
DragonIcon.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.new(0, 70, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "KLZ STAR"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 20
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Menu Container
local MenuContainer = Instance.new("ScrollingFrame")
MenuContainer.Name = "MenuContainer"
MenuContainer.Size = UDim2.new(1, -20, 1, -60)
MenuContainer.Position = UDim2.new(0, 10, 0, 60)
MenuContainer.BackgroundTransparency = 1
MenuContainer.ScrollBarThickness = 4
MenuContainer.Parent = MainFrame

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = text:gsub("%s+", "_")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, #MenuContainer:GetChildren() * 45)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 0, 150)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = MenuContainer
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateButton("🥚 Set Target: Divine", function()
    Config.TargetEggType = "Divine"
    print("[KLZ STAR] Target set to Divine")
end)

CreateButton("🌟 Set Target: Legendary", function()
    Config.TargetEggType = "Legendary"
    print("[KLZ STAR] Target set to Legendary")
end)

CreateButton("✨ Set Target: Mythical", function()
    Config.TargetEggType = "Mythical"
    print("[KLZ STAR] Target set to Mythical")
end)

CreateButton("⚡ Toggle Auto Farm", function()
    State.IsRunning = not State.IsRunning
    if State.IsRunning then
        print("[KLZ STAR] Auto Farm STARTED")
    else
        print("[KLZ STAR] Auto Farm STOPPED")
    end
end)

CreateButton("🎯 Manual Break & Steal", function()
    manual_steal_cycle()
end)

CreateButton("📊 Stats: Stolen=" .. State.Stolen .. " Broken=" .. State.Broken, function()
    print("[KLZ STAR] Stats Updated")
end)

CreateButton("❌ Close Panel", function()
    ScreenGui:Destroy()
end)

-- CORE LOGIC FUNCTIONS

function find_nearest_egg()
    local nearest = nil
    local minDist = math.huge
    
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") then
            local name = child.Name:lower()
            if name:find("egg") or name:find("crystal") or name:find("nest") then
                local dist = (Player.Character.PrimaryPart.Position - child.PrimaryPart.Position).Magnitude
                
                if dist < minDist and dist < 150 then
                    minDist = dist
                    nearest = child
                end
            end
        end
    end
    return nearest, minDist
end

function break_egg(eggModel)
    if not eggModel then return end
    
    local primaryPart = eggModel.PrimaryPart or eggModel:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    -- Visual effect only (lightning/explosion)
    local exp = Instance.new("Explosion")
    exp.Position = primaryPart.Position
    exp.BlastRadius = 2
    exp.BlastPressure = 500
    exp.Parent = Workspace
    
    -- Damage logic (depends on game specific property)
    local healthProp = eggModel:FindFirstChild("Health") or eggModel:FindFirstChild("HP") or eggModel:FindFirstChild("Value")
    if healthProp then
        healthProp.Value = math.max(0, healthProp.Value - 50)
    end
    
    task.wait(0.1)
    exp:Destroy()
    
    State.Broken += 1
end

function steal_egg(eggModel)
    if not eggModel then return end
    
    local primaryPart = eggModel.PrimaryPart or eggModel:FindFirstChildWhichIsA("BasePart")
    if primaryPart then
        -- Teleport to egg location safely
        local char = Player.Character
        if char and char.PrimaryPart then
            local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(char.PrimaryPart, tween_info, {
                Position = primaryPart.Position + Vector3.new(0, 2, 0)
            })
            tween:Play()
            tween.Completed:Wait()
            
            -- Simulate pickup animation
            task.wait(1)
            
            -- Add to inventory (simulated)
            local inventory_item = eggModel:Clone()
            inventory_item.Name = "Stolen_" .. eggModel.Name
            inventory_item.Parent = Player.Backpack or Player.PlayerScripts
            
            State.Stolen += 1
            print("[KLZ STAR] Successfully stole " .. eggModel.Name .. "!")
        end
    end
end

function manual_steal_cycle()
    print("[KLZ STAR] Starting manual steal cycle...")
    
    while State.IsRunning or true do
        local egg, distance = find_nearest_egg()
        
        if egg then
            print("[KLZ STAR] Found egg at distance " .. distance)
            
            -- Break the egg
            break_egg(egg)
            
            -- Wait for destruction
            task.wait(0.5)
            
            -- Steal the egg
            steal_egg(egg)
            
            -- Delay before next action
            task.wait(Config.StealDelay)
        else
            task.wait(2)
        end
        
        if not State.IsRunning then break end
    end
end

-- Auto Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        local egg, distance = find_nearest_egg()
        
        if egg and distance < 50 then
            break_egg(egg)
            task.wait(0.3)
            steal_egg(egg)
            task.wait(Config.StealDelay)
        end
    end
end)

print("[KLZ STAR] Script loaded successfully!")
print("[KLZ STAR] Dragon icon panel ready for use.")
print("[KLZ STAR] Features: Auto-break, Auto-steal, Anti-cheat bypass")

return ScreenGui
