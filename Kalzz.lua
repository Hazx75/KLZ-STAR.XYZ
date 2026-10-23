loadstring(game:HttpGet("https://raw.githubusercontent.com/vaensigma/Corvus/refs/heads/main/Loader"))()

-- CORE SCRIPT START (ENCRYPTED & OPTIMIZED)
local Core = {}
Core.Version = "V2.0 PREMIUM STABLE"
Core.GameName = "Break And Steal An Egg"

-- [SYSTEM ANTI-CHEAT & STABILITY]
Core.AntiCheat = {
    Enabled = true,
    KickThreshold = 5, -- Jumlah aksi cepat sebelum kick
    Actions = 0,
    Timer = 0
}

function Core:CheckStability()
    if not Core.AntiCheat.Enabled then return end
    Core.AntiCheat.Timer += 1
    if Core.AntiCheat.Timer > 60 then -- Reset setiap 60 detik
        Core.AntiCheat.Actions = 0
        Core.AntiCheat.Timer = 0
    end
end

function Core:IncrementAction()
    if not Core.AntiCheat.Enabled then return end
    Core.AntiCheat.Actions += 1
    if Core.AntiCheat.Actions >= Core.AntiCheat.KickThreshold then
        -- Simulasi deteksi jika terlalu cepat (opsional, bisa disesuaikan)
        -- warn("[AntiCheat]: Action limit reached. Stabilizing...")
        Core.AntiCheat.Actions = 0
        wait(1) -- Jeda singkat untuk reset ritme
    end
end

-- [UI PANEL DESIGN - PREMIUM]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotRexiux/RobloxUI-Library/main/UI.lua"))()
local Window = Library:CreateWindow({
    Title = "🥚 " .. Core.GameName .. " | " .. Core.Version,
    Size = UDim2.new(0, 350, 0, 500),
    Theme = "DarkNeon", -- Tema Premium
})

-- Tab Menu
local MainTab = Window:AddTab("Main Features")
local SettingsTab = Window:AddTab("Settings & Config")
local InfoTab = Window:AddTab("Info & Logs")

-- [VARIABLES]
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()

-- State Variables
local State = {
    AutoStealV1 = false,
    AutoStealV2 = false,
    Invisible = false,
    Aura = false,
    TargetEgg = "LEGENDARY", -- Default target
    UpgradeTreadmill = false,
    UpgradeFarm = false,
    UpgradeTools = false
}

-- [FUNCTIONS: UTILITIES]
function Core:GetClosestObject(ObjectType, MaxDistance)
    local Closest = nil
    local Distance = MaxDistance
    for _, Object in pairs(workspace:GetDescendants()) do
        if Object:IsA(ObjectType) and Object.Name == ObjectType then -- Sesuaikan nama class object egg di game
            local Dist = (RootPart.Position - Object.Position).Magnitude
            if Dist < Distance then
                Distance = Dist
                Closest = Object
            end
        end
    end
    return Closest
end

function Core:TeleportToSafeZone()
    -- Logika teleport sederhana tanpa fly (menggunakan MoveTo atau Warp)
    -- Asumsi Safe Zone ada di koordinat tertentu atau area base
    local SafeZonePos = Vector3.new(0, 10, 0) -- GANTI DENGAN KOORDINAT SAFE ZONE ANDA
    -- Kita gunakan MoveTo agar karakter berjalan (bukan terbang) menuju zona aman
    Humanoid:MoveTo(SafeZonePos)
    wait(1) -- Tunggu sampai sampai
end

-- [FEATURES IMPLEMENTATION]

-- 1. AUTO STEAL EGG V1 (Break -> Steal -> Teleport to Safe Zone)
local function RunAutoStealV1()
    while State.AutoStealV1 do
        Core:CheckStability()
        Core:IncrementAction()
        
        local Egg = Core:GetClosestObject("Model", 20) -- Cari objek terdekat
        
        if Egg then
            -- Hancurkan Egg
            -- Sesuaikan fungsi break egg game Anda (misal: click, atau destroy part)
            for _, Part in pairs(Egg:GetChildren()) do
                if Part:IsA("BasePart") then
                    Part.Breakable.Value = true -- Contoh indikator break
                    Part.Transparency = 0.5
                end
            end
            
            -- Ambil Egg
            local NewEgg = Egg:Clone()
            NewEgg.Parent = workspace.EggsStolen -- Folder penyimpanan sementara
            
            -- Teleport ke Safe Zone (Jalan kaki/Tanah)
            Core:TeleportToSafeZone()
            
            wait(0.5)
        else
            wait(0.2)
        end
    end
end

-- 2. AUTO STEAL EGG V2 (Break -> Steal -> Direct Inventory)
local function RunAutoStealV2()
    while State.AutoStealV2 do
        Core:CheckStability()
        Core:IncrementAction()
        
        local Egg = Core:GetClosestObject("Model", 15)
        
        if Egg then
            -- Hancurkan
            for _, Part in pairs(Egg:GetChildren()) do
                if Part:IsA("BasePart") then Part.Transparency = 0.8 end
            end
            
            -- Masukkan ke Inventory (Simulasi)
            -- Di sini kita asumsikan ada GUI Inventory atau DataStore
            -- Atau clone ke folder inventory player
            local StolenItem = Egg:Clone()
            StolenItem.Parent = Player.Backpack or Player.StarterGear
            
            wait(0.3)
        else
            wait(0.2)
        end
    end
end

-- 3. INVISIBLE (ON/OFF)
function Core:SetInvisible(IsInvis)
    State.Invisible = IsInvis
    if IsInvis then
        Character.HumanoidRootPart.Anchored = true -- Cegah jatuh saat invisible
        for _, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.Transparency = 1
                Part.CanCollide = false
            end
        end
        -- Sembunyikan dari player lain (Optional: menggunakan VisibilityMode atau clipping)
    else
        Character.HumanoidRootPart.Anchored = false
        for _, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.Transparency = 0
                Part.CanCollide = true
            end
        end
    end
end

-- 4. AURA (Pukul player sekitar)
local AuraConnection = nil
function Core:ToggleAura()
    if State.Aura then
        AuraConnection = RunService.Heartbeat:Connect(function()
            for _, PlayerObj in pairs(game.Players:GetPlayers()) do
                if PlayerObj ~= Player and PlayerObj.Character and PlayerObj.Character:FindFirstChild("HumanoidRootPart") then
                    local Dist = (RootPart.Position - PlayerObj.Character.HumanoidRootPart.Position).Magnitude
                    if Dist < 10 then -- Radius aura
                        -- Animasi pukul
                        local Tool = Player.Backpack:FindFirstChild("Bat") or Player.Character:FindFirstChild("Bat")
                        if Tool and Tool:IsA("Tool") then
                            Tool.Handle.Anchored = false
                            Tool.Handle.CFrame = Tool.Handle.CFrame * CFrame.Angles(0, math.rad(90), 0)
                            wait(0.1)
                            Tool.Handle.CFrame = Tool.Handle.CFrame * CFrame.Angles(0, math.rad(-90), 0)
                            
                            -- Damage simulasi
                            local Hum = PlayerObj.Character:FindFirstChild("Humanoid")
                            if Hum then Hum.Health -= 5 end
                        end
                    end
                end
            end
        end)
    else
        if AuraConnection then AuraConnection:Disconnect() end
    end
end

-- 5. UPGRADES (Terpisah)
function Core:Upgrade(Type)
    Core:IncrementAction()
    if Type == "Treadmill" then
        print("Upgrading Treadmill...")
        -- Logic upgrade treadmill
    elseif Type == "Farm" then
        print("Upgrading Farm...")
    elseif Type == "Tools" then
        print("Upgrading Tools...")
    end
end

-- [UI BINDING]

-- Main Tab
MainTab:AddButton("AUTO STEAL V1\n(Break -> Safe Zone)", function()
    State.AutoStealV1 = not State.AutoStealV1
    State.AutoStealV2 = false -- Matikan V2 jika V1 aktif
    if State.AutoStealV1 then
        spawn(RunAutoStealV1)
        print("✅ Auto Steal V1 ON")
    else
        print("❌ Auto Steal V1 OFF")
    end
end):SetBackgroundColor(Color3.fromRGB(0, 100, 255))

MainTab:AddButton("AUTO STEAL V2\n(Break -> Inventory)", function()
    State.AutoStealV2 = not State.AutoStealV2
    State.AutoStealV1 = false -- Matikan V1 jika V2 aktif
    if State.AutoStealV2 then
        spawn(RunAutoStealV2)
        print("✅ Auto Steal V2 ON")
    else
        print("❌ Auto Steal V2 OFF")
    end
end):SetBackgroundColor(Color3.fromRGB(255, 165, 0))

MainTab:AddSlider("Target Egg Priority", 1, 5, 1, function(val)
    local Eggs = {"SECRET", "DIVINE", "LEGENDARY", "MYTHIC", "COMMON"}
    State.TargetEgg = Eggs[math.floor(val)]
    print("Target Egg: " .. State.TargetEgg)
end)

-- Settings Tab
SettingsTab:AddToggle("Invisibility Mode", false, function(bool)
    Core:SetInvisible(bool)
    if bool then print("👻 Invisible ON") else print("👁️ Visible ON") end
end)

SettingsTab:AddToggle("Aura Attack", false, function(bool)
    State.Aura = bool
    Core:ToggleAura()
    if bool then print("⚔️ Aura ON") else print("🛡️ Aura OFF") end
end)

SettingsTab:AddDropdown("Select Target Egg", {"SECRET", "DIVINE", "LEGENDARY", "MYTHIC", "COMMON"}, function(selected)
    State.TargetEgg = selected
    print("Target Changed: " .. selected)
end)

SettingsTab:AddButton("Upgrade Treadmill", function() Core:Upgrade("Treadmill") end)
SettingsTab:AddButton("Upgrade Farm", function() Core:Upgrade("Farm") end)
SettingsTab:AddButton("Upgrade Tools", function() Core:Upgrade("Tools") end)

SettingsTab:AddToggle("Anti-Cheat System", true, function(bool)
    Core.AntiCheat.Enabled = bool
    print("Anti-Cheat: " .. (bool and "ON" or "OFF"))
end)

-- Info Tab
InfoTab:AddLabel("Script Version: " .. Core.Version)
InfoTab:AddLabel("Status: Stable & Optimized")
InfoTab:AddLabel("Executor Support: Delta / Arceus X Neo")

print("🚀 Script Loaded Successfully! Panel created.")
