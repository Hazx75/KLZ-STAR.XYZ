-- ==========================================
-- BREAK AND STEAL AN EGG - PREMIUM CUSTOM SCRIPT
-- AUTHOR: YOUR NAME / CUSTOM BUILD
-- VERSION: 1.0 STABLE
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [CONFIGURATION & STATE]
local Config = {
    TargetEgg = "LEGENDARY", -- Default target
    AutoStealV1 = false,
    AutoStealV2 = false,
    Invisible = false,
    AuraMode = false,
    AntiCheatEnabled = true,
    SpeedLimit = 0.5 -- Deteksi spam cepat
}

-- [UI PANEL BUILDER (PURE CODE - NO LIBRARY)]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumEggPanel"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Header
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🥚 Break & Steal Pro"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scrollable Frame for Buttons
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "Content"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper Function to Create Buttons
local function CreateButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Name = text:gsub("%s", "") .. "Btn"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yPos * 50) -- Simple layout logic
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = ScrollingFrame
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Hover Effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = color or Color3.fromRGB(60, 60, 70)}):Play()
    end)
    
    return btn
end

-- [FEATURES LOGIC]

-- 1. AUTO STEAL V1 (Break -> Teleport Safe Zone)
local function RunAutoStealV1()
    while Config.AutoStealV1 do
        if not Character or not Character.Parent then break end
        
        -- Cari telur terdekat
        local closestEgg = nil
        local minDist = 50
        
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Egg" then -- Sesuaikan nama class egg di game
                local dist = (RootPart.Position - obj:GetPrimaryPartCFrame().p).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestEgg = obj
                end
            end
        end
        
        if closestEgg then
            -- Hancurkan Egg (Simulasi)
            for _, part in pairs(closestEgg:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5
                    part.Breakable.Value = true -- Jika ada value Breakable
                end
            end
            
            -- Ambil Egg (Clone ke inventory/base)
            local stolen = closestEgg:Clone()
            stolen.Parent = workspace.EggsStolen -- Folder sementara
            
            -- Teleport ke Safe Zone (Jalan kaki/Tanah)
            -- Kita gunakan MoveTo agar karakter berjalan normal, bukan fly
            local safeZonePos = Vector3.new(RootPart.Position.X, 10, RootPart.Position.Z + 20) -- Ganti koordinat ini sesuai Base Aman
            Humanoid:MoveTo(safeZonePos)
            
            wait(1) -- Tunggu sampai jalan
        else
            wait(0.2)
        end
        
        -- Anti Lag Check
        task.wait(0.1)
    end
end

-- 2. AUTO STEAL V2 (Break -> Direct Inventory)
local function RunAutoStealV2()
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
            -- Hancurkan
            for _, part in pairs(closestEgg:GetChildren()) do
                if part:IsA("BasePart") then part.Transparency = 0.8 end
            end
            
            -- Masukkan ke Inventory Player
            local item = closestEgg:Clone()
            item.Parent = LocalPlayer.Backpack
            
            wait(0.3)
        else
            wait(0.2)
        end
        task.wait(0.1)
    end
end

-- 3. INVISIBLE SYSTEM
function SetInvisible(state)
    Config.Invisible = state
    if state then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        -- Cegah jatuh saat invisible
        RootPart.Anchored = true 
    else
        for _, part in pairs(Character:GetChildren()) do
            if part:Is(A "BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
        RootPart.Anchored = false
    end
end

-- 4. AURA SYSTEM
local AuraConn = nil
function ToggleAura(state)
    Config.AuraMode = state
    if state then
        AuraConn = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (RootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        -- Animasi Pukul
                        local tool = LocalPlayer.Backpack:FindFirstChild("Bat") or LocalPlayer.Character:FindFirstChild("Bat")
                        if tool and tool:IsA("Tool") then
                            local handle = tool.Handle or tool
                            handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(90), 0)
                            wait(0.1)
                            handle.CFrame = handle.CFrame * CFrame.Angles(0, math.rad(-90), 0)
                            
                            -- Damage
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

-- 5. UPGRADE SYSTEM
function UpgradeItem(type)
    print("[System] Upgrading " .. type .. "...")
    -- Logic upgrade spesifik bisa ditambahkan di sini
    -- Contoh: memanggil RemoteEvent game
    -- remote:FireServer("Upgrade", type)
end

-- [UI BINDING]

-- Main Features
CreateButton("AUTO STEAL V1\n(Break -> Safe Zone)", 1, function()
    Config.AutoStealV1 = not Config.AutoStealV1
    Config.AutoStealV2 = false
    spawn(RunAutoStealV1)
    print(Config.AutoStealV1 and "✅ V1 ON" or "❌ V1 OFF")
end, Color3.fromRGB(0, 120, 255))

CreateButton("AUTO STEAL V2\n(Break -> Inventory)", 2, function()
    Config.AutoStealV2 = not Config.AutoStealV2
    Config.AutoStealV1 = false
    spawn(RunAutoStealV2)
    print(Config.AutoStealV2 and "✅ V2 ON" or "❌ V2 OFF")
end, Color3.fromRGB(255, 165, 0))

CreateButton("TARGET EGG: " .. Config.TargetEgg, 3, function()
    -- Cycle through eggs
    local eggs = {"SECRET", "DIVINE", "LEGENDARY", "MYTHIC", "COMMON"}
    local idx = table.find(eggs, Config.TargetEgg)
    idx = (idx % #eggs) + 1
    Config.TargetEgg = eggs[idx]
    -- Update button text (simple way)
    -- In real scenario, you'd update the label directly
end, Color3.fromRGB(100, 100, 100))

-- Settings
CreateButton("INVISIBLE: " .. tostring(Config.Invisible), 4, function()
    SetInvisible(not Config.Invisible)
end, Color3.fromRGB(150, 150, 150))

CreateButton("AURA MODE: " .. tostring(Config.AuraMode), 5, function()
    ToggleAura(not Config.AuraMode)
end, Color3.fromRGB(200, 50, 50))

CreateButton("UPGRADE TREADMILL", 6, function()
    UpgradeItem("Treadmill")
end, Color3.fromRGB(50, 200, 50))

CreateButton("UPGRADE FARM", 7, function()
    UpgradeItem("Farm")
end, Color3.fromRGB(50, 200, 50))

CreateButton("UPGRADE TOOLS", 8, function()
    UpgradeItem("Tools")
end, Color3.fromRGB(50, 200, 50))

CreateButton("ANTI-CHEAT: " .. tostring(Config.AntiCheatEnabled), 9, function()
    Config.AntiCheatEnabled = not Config.AntiCheatEnabled
end, Color3.fromRGB(100, 100, 100))

print("🚀 Custom Premium Script Loaded Successfully!")
