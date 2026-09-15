-- Buscamos dónde poner la GUI (Delta usa gethui() para ocultarla de los anti-cheats)
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")

-- Si ya existe una versión anterior, la borramos para no duplicarla
if guiParent:FindFirstChild("JoseAngel_Menu") then
    guiParent.JoseAngel_Menu:Destroy()
end

-- Servicios
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Character, Humanoid, RootPart

-- Actualizar personaje
local function actualizarPersonaje()
    Character = Player.Character
    if Character then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
    end
end
actualizarPersonaje()
Player.CharacterAdded:Connect(actualizarPersonaje)

-- ─── CREAR GUI ───
local gui = Instance.new("ScreenGui")
gui.Name = "JoseAngel_Menu"
gui.Parent = guiParent
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 480)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "JoseAngel_Blox x2"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Parent = mainFrame

local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 255, 100)
glow.Transparency = 0.5
glow.Thickness = 1.5
glow.Parent = title

-- ─── FUNCIÓN PARA CREAR BOTONES ───
local botones = {}
local function crearBoton(nombre, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 42)
    btn.Position = UDim2.new(0.5, -105, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    btn.Text = nombre .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoLocalize = false
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local estado = false
    botones[nombre] = btn

    btn.MouseButton1Click:Connect(function()
        estado = not estado
        btn.Text = nombre .. ": " .. (estado and "ON" or "OFF")
        btn.BackgroundColor3 = estado and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
        callback(estado)
    end)
end

-- ─── OBTENER REMOTE SEGURO ───
local function getRemote()
    return ReplicatedStorage:FindFirstChild("Shared", true)
        and ReplicatedStorage.Shared:FindFirstChild("Packages", true)
        and ReplicatedStorage.Shared.Packages:FindFirstChild("Network", true)
        and ReplicatedStorage.Shared.Packages.Network:FindFirstChild("rev_TaviMishkal", true)
end

-- ─── TELETRANSPORTAR A ZONA ───
local function irAKickReady()
    if not RootPart then actualizarPersonaje() end
    local zona = workspace:FindFirstChild("KickReady")
    if zona and RootPart then
        local pos = zona:FindFirstChild("Position") or zona
        RootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 3, 0))
    end
end

-- ─── BOTÓN 1: MULTIPLICADOR x2 ───
crearBoton("🔥 Multiplicador x2", 65, function(activado)
    task.spawn(function()
        while activado do
            local remote = getRemote()
            if remote then pcall(function() remote:FireServer() end) end
            task.wait(0.2)
        end
    end)
end)

-- ─── BOTÓN 2: AUTO FARM ───
crearBoton("🚀 Auto Farm", 125, function(activado)
    task.spawn(function()
        while activado do
            -- Patea y luego va a KickReady
            local remote = getRemote()
            if remote then pcall(function() remote:FireServer() end) end
            task.wait(0.3)
            irAKickReady()
            task.wait(0.4)
        end
    end)
end)

-- ─── BOTÓN 3: AUTO COLLECT CASH ───
crearBoton("💰 Auto Collect Cash", 185, function(activado)
    task.spawn(function()
        while activado do
            actualizarPersonaje()
            if not RootPart then task.wait(0.5) continue end
            
            -- Recorre todos los Slots del 1 al 29
            for i = 1, 29 do
                if not activado then break end -- Se detiene si apagas el botón
                local slot = workspace:FindFirstChild("Slot" .. i)
                if slot then
                    pcall(function()
                        RootPart.CFrame = CFrame.new(slot.Position + Vector3.new(0, 5, 0))
                    end)
                end
                task.wait(0.15) -- Tiempo en cada slot para recoger
            end
            task.wait(0.5) -- Descanso antes de repetir
        end
    end)
end)
