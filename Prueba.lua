-- ==========================================
--  Kick A Lucky Block - Native Script
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Eliminar ejecuciones previas
if CoreGui:FindFirstChild("KickLuckyBlockUI") then
    CoreGui.KickLuckyBlockUI:Destroy()
end

-- Variables de Estado
local AutoKick = false
local FastSpeed = false

-- Buscar Evento de Kick (ajusta la ruta si el juego cambia el Remote)
local function getKickEvent()
    return ReplicatedStorage:FindFirstChild("ref_KickEvent", true) 
        or ReplicatedStorage:FindFirstChild("KickEvent", true) 
        or ReplicatedStorage:FindFirstChild("Kick", true)
end

-- Creación de la Interfaz
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KickLuckyBlockUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.5, -140, 0.35, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Title.Text = "Kick a Lucky Block v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botón Auto Kick
local KickBtn = Instance.new("TextButton")
KickBtn.Size = UDim2.new(0.85, 0, 0, 40)
KickBtn.Position = UDim2.new(0.075, 0, 0.28, 0)
KickBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KickBtn.Text = "Auto Kick: OFF"
KickBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
KickBtn.TextSize = 14
KickBtn.Font = Enum.Font.SourceSans
KickBtn.Parent = MainFrame

local KickCorner = Instance.new("UICorner")
KickCorner.CornerRadius = UDim.new(0, 8)
KickCorner.Parent = KickBtn

-- Botón Velocidad (WalkSpeed)
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.85, 0, 0, 40)
SpeedBtn.Position = UDim2.new(0.075, 0, 0.53, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedBtn.Text = "Super Velocidad: OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedBtn.TextSize = 14
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedBtn

-- Botón Cerrar UI
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.85, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.075, 0, 0.78, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
CloseBtn.Text = "Cerrar GUI"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Funciones y Eventos
KickBtn.MouseButton1Click:Connect(function()
    AutoKick = not AutoKick
    if AutoKick then
        KickBtn.Text = "Auto Kick: ON"
        KickBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        KickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        KickBtn.Text = "Auto Kick: OFF"
        KickBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        KickBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    FastSpeed = not FastSpeed
    if FastSpeed then
        SpeedBtn.Text = "Super Velocidad: ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        SpeedBtn.Text = "Super Velocidad: OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SpeedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    AutoKick = false
    FastSpeed = false
    ScreenGui:Destroy()
end)

-- Bucle Auto Kick
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoKick then
            local event = getKickEvent()
            if event then
                event:FireServer()
            end
        end
    end
end)

-- Bucle Velocidad
RunService.RenderStepped:Connect(function()
    if FastSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    elseif not FastSpeed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
