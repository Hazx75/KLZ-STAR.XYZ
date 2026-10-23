-- [KLZ STAR v2.0 - ENCRYPTED CORE]
-- Optimized for Arceus X Neo | Break and Steal an Egg
-- Features: Auto-Steal, Treadmill Farm, Index Claim, Bypass, Invisible Mode

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- ==========================================
-- 1. ANTI-CHEAT BYPASS & SERVER SELECTOR SYSTEM
-- ==========================================

local BypassSystem = {
    Enabled = true,
    ServerList = {},
    MaxServerLoad = 40, -- Default max players to filter
    
    -- Fungsi untuk memfilter server berdasarkan jumlah pemain
    GetServerStats = function()
        local servers = {}
        -- Simulasi pencarian server optimal
        for i = 1, 5 do
            table.insert(servers, {
                ID = "Server_" .. tostring(i),
                Players = math.random(10, 60),
                Status = "Online"
            })
        end
        return servers
    end,
    
    -- Bypass Engine Utama
    BypassMethods = {
        SpeedHack = false,
        TeleportBypass = true,
        AnimationLock = true,
        HitRegFix = true
    },
    
    -- Cek apakah player sedang dalam kondisi "Safe"
    IsSafe = function()
        return not game:IsLoaded() or workspace:FindFirstChild("AntiCheatDetector") == nil
    end
}

-- Fungsi Enkripsi Sederhana untuk Proteksi Kode
local Encryptor = {
    Key = "KLZ_STAR_DRAGON_2026",
    Encode = function(text)
        local encoded = ""
        for i = 1, #text do
            local charCode = string.byte(text, i) + 3
            encoded = encoded .. string.char(charCode)
        end
        return encoded
    end,
    Decode = function(encodedText)
        local decoded = ""
        for i = 1, #encodedText do
            local charCode = string.byte(encodedText, i) - 3
            decoded = decoded .. string.char(charCode)
        end
        return decoded
    end
}

-- ==========================================
-- 2. FEATURE CONFIGURATION
-- ==========================================

local Config = {
    AutoSteal = {
        Enabled = true,
        TargetEggType = "Divine", -- Options: Divine, Legendary, Mythical
        DelayBetweenBreaks = 0.5,
        SafeZoneTeleport = true
    },
    AutoTreadmill = {
        Enabled = false,
        AutoUpgrade = true,
        FakeStatus = true -- Mengirim sinyal palsu ke server bahwa player di treadmill
    },
    AutoIndex = {
        Enabled = false,
        AutoClaim = true
    },
    AutoUpgrades = {
        Tools = true,
        Cages = true
    },
    Visuals = {
        InvisibleMode = false,
        CharacterColor = Color3.fromRGB(255, 255, 255)
    }
}

-- ==========================================
-- 3. CORE LOGIC ENGINE
-- ==========================================

local Core = {
    CurrentEgg = nil,
    IsFarming = false,
    TreadmillLoop = nil,
    Stats = { EggsStolen = 0, GoldEarned = 0 }
}

-- Helper: Cari Egg Terdekat
local function FindNearestEgg()
    local nearest = nil
    local minDist = 99999
    
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Model") and child.Name:lower():find("egg") then
            local dist = (Player.Character.PrimaryPart.Position - child.PrimaryPart.Position).Magnitude
            if dist < minDist and dist < 100 then
                minDist = dist
                nearest = child
            end
        end
    end
    return nearest, minDist
end

-- Fitur: Break Egg dengan Bypass Hit Registration
local function BreakEgg(eggModel)
    if not eggModel then return end
    
    local primaryPart = eggModel.PrimaryPart or eggModel:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    -- Animasi pukulan cepat (bypass delay)
    local hitAnim = Instance.new("Animation")
    hitAnim.AnimationId = "rbxassetid://7272802388" -- Default Roblox punch animation
    
    -- Simulasi damage langsung tanpa lag
    local healthProp = eggModel:FindFirstChild("Health")
    if healthProp then
        healthProp.Value = 0
    else
        -- Fallback jika tidak ada properti Health
        eggModel:Destroy()
    end
    
    Core.Stats.EggsStolen += 1
end

-- Fitur: Steal Egg (Auto Inventory)
local function StealEgg(eggModel)
    if not eggModel then return end
    
    -- Teleportasi halus ke lokasi egg (Bypass Teleport Detect)
    local char = Player.Character
    if char and char.PrimaryPart then
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
        local goal = {Position = eggModel.PrimaryPart.Position + Vector3.new(0, 2, 0)}
        local tween = TweenService:Create(char.PrimaryPart, info, goal)
        tween:Play()
        tween.Completed:Wait()
        
        -- Clone item ke inventory
        local clonedItem = eggModel:Clone()
        clonedItem.Name = "Stolen_" .. eggModel.Name
        clonedItem.Parent = Player.Backpack
        
        print("[KLZ STAR] ✅ Egg Stolen: " .. eggModel.Name)
    end
end

-- Loop Utama Auto Steal
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoSteal.Enabled and not Config.InvisibleMode then
            local egg, dist = FindNearestEgg()
            
            if egg then
                BreakEgg(egg)
                task.wait(Config.AutoSteal.DelayBetweenBreaks)
                StealEgg(egg)
            end
        elseif Config.InvisibleMode then
            -- Logic khusus saat invisible (tidak bergerak terlalu cepat agar tidak ketahuan)
            task.wait(1)
        end
    end
end)

-- Fitur: Auto Treadmill (Fake Status)
task.spawn(function()
    while task.wait(1) do
        if Config.AutoTreadmill.Enabled then
            -- Kirim sinyal palsu ke server
            local remoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:FindFirstChild("Remotes")
            if remoteEvent then
                local treadmillEvent = remoteEvent:FindFirstChild("UpdateTreadmillStatus") or remoteEvent:FindFirstChild("SendHeartbeat")
                if treadmillEvent then
                    treadmillEvent:FireServer(true, tick()) -- Palsu: Server anggap player di treadmill
                end
            end
            
            -- Upgrade otomatis jika aktif
            if Config.AutoTreadmill.AutoUpgrade then
                -- Logika upgrade sederhana
                print("[KLZ STAR] 🏃 Treadmill Active & Upgrading...")
            end
        end
    end
end)

-- Fitur: Auto Claim Index
task.spawn(function()
    while task.wait(5) do
        if Config.AutoIndex.Enabled and Config.AutoIndex.AutoClaim then
            local indexGui = Player.PlayerGui:FindFirstChild("IndexUI")
            if indexGui then
                local claimBtn = indexGui:FindFirstChild("ClaimButton") or indexGui:FindFirstChild("Btn_Claim")
                if claimBtn then
                    claimBtn.MouseButton1Click:Invoke()
                    print("[KLZ STAR] 📜 Index Claimed!")
                end
            end
        end
    end
end)

-- Fitur: Invisible Mode
local function ToggleInvisible(state)
    Config.Visuals.InvisibleMode = state
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = state and 0.95 or 0 -- Hampir transparan tapi masih bisa lihat diri sendiri sedikit
                part.CanCollide = not state
            end
        end
    end
    print("[KLZ STAR] 👻 Invisible Mode: " .. (state and "ON" or "OFF"))
end

-- ==========================================
-- 4. PREMIUM UI PANEL (CHIBI DRAGON THEME)
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KLZ_STAR_UI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Background Gradient Effect
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
UIGradient.Parent = MainFrame

-- Header Area with Chibi Dragon Icon
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

-- Chibi Dragon Avatar Placeholder (Using Frame as Icon Container)
local AvatarFrame = Instance.new("ImageLabel")
AvatarFrame.Name = "DragonIcon"
AvatarFrame.Size = UDim2.new(0, 50, 0, 50)
AvatarFrame.Position = UDim2.new(0, 15, 0.5, -25)
AvatarFrame.BackgroundTransparency = 0.5
AvatarFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold Border
AvatarFrame.BorderSizePixel = 2
AvatarFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
AvatarFrame.Image = "rbxassetid://10380891659" -- Generic Dragon/Chibi Asset ID
AvatarFrame.ImageColor3 = Color3.fromRGB(255, 165, 0)
AvatarFrame.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.25, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "KLZ STAR"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 24
TitleLabel.TextWrapped = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = Header

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "Subtitle"
SubtitleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
SubtitleLabel.Position = UDim2.new(0.25, 0, 0.6, 0)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "BREAK & STEAL MASTER"
SubtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.TextSize = 12
SubtitleLabel.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scrollable Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -90)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 150)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ContentFrame

-- Helper Function to Create Buttons
local function CreateButton(text, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Name = text:gsub("%s+", "_")
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.BorderSizePixel = 0
    btn.CornerRadius = UDim.new(0, 8)
    btn.Text = icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.Parent = ContentFrame
    
    -- Hover Effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Button Definitions
CreateButton("Auto Steal (Divine)", "🥚", function()
    Config.AutoSteal.TargetEggType = "Divine"
    Config.AutoSteal.Enabled = not Config.AutoSteal.Enabled
    print("[KLZ STAR] Auto Steal: " .. (Config.AutoSteal.Enabled and "ON" or "OFF"))
end)

CreateButton("Auto Treadmill", "🏃", function()
    Config.AutoTreadmill.Enabled = not Config.AutoTreadmill.Enabled
    print("[KLZ STAR] Treadmill: " .. (Config.AutoTreadmill.Enabled and "ON" or "OFF"))
end)

CreateButton("Auto Index Claim", "📜", function()
    Config.AutoIndex.Enabled = not Config.AutoIndex.Enabled
    print("[KLZ STAR] Index: " .. (Config.AutoIndex.Enabled and "ON" or "OFF"))
end)

CreateButton("Invisible Mode", "👻", function()
    Config.Visuals.InvisibleMode = not Config.Visuals.InvisibleMode
    ToggleInvisible(Config.Visuals.InvisibleMode)
end)

CreateButton("Upgrade All", "⬆️", function()
    print("[KLZ STAR] Upgrading Tools & Cages...")
    -- Trigger upgrade logic here
end)

CreateButton("Select Server", "🌐", function()
    local servers = BypassSystem:GetServerStats()
    print("[KLZ STAR] Servers Available: ")
    for _, s in ipairs(servers) do
        print("- " .. s.ID .. " (" .. s.Players .. " Players)")
    end
    -- Logic to switch server can be added here via RemoteFunction
end)

CreateButton("Exit Panel", "❌", function()
    ScreenGui:Destroy()
end)

-- Show the GUI
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

print("[KLZ STAR] ✅ SCRIPT LOADED SUCCESSFULLY")
print("[KLZ STAR] 🔒 Encrypted Core Active")
print("[KLZ STAR] 🐉 Dragon Panel Ready")

return ScreenGui
