-- Script para Kick a Lucky Block
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local autoFarmActive = false
local autoCollectActive = false

-- Interface gráfica (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuckyBlockHub"
screenGui.Parent = (CoreGui:FindFirstChild("RobloxGui") or CoreGui)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 160)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "Lucky Block Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0.9, 0, 0, 40)
farmBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
farmBtn.Text = "Auto Farm: OFF"
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.Font = Enum.Font.SourceSans
farmBtn.TextSize = 14
farmBtn.Parent = mainFrame

local collectBtn = Instance.new("TextButton")
collectBtn.Size = UDim2.new(0.9, 0, 0, 40)
collectBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
collectBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
collectBtn.Text = "Auto Collect Cash: OFF"
collectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collectBtn.Font = Enum.Font.SourceSans
collectBtn.TextSize = 14
collectBtn.Parent = mainFrame

-- Función para Mover a la Safe Zone
local function tpToSafeZone()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    local safeZone = workspace:FindFirstChild("KickReady", true)
    if hrp and safeZone then
        if safeZone:IsA("BasePart") then
            hrp.CFrame = safeZone.CFrame + Vector3.new(0, 3, 0)
        elseif safeZone:IsA("Model") then
            hrp.CFrame = safeZone:GetPivot() + Vector3.new(0, 3, 0)
        end
    end
end

-- Lógica Auto Farm
farmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        farmBtn.Text = "Auto Farm: ON"
        farmBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        tpToSafeZone()
    else
        farmBtn.Text = "Auto Farm: OFF"
        farmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoFarmActive then
            local char = LocalPlayer.Character
            if char then
                -- Intenta presionar/patear bloques en el área automáticamente
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") and obj.Parent then
                        firetouchinterest(char.PrimaryPart, obj.Parent, 0)
                        firetouchinterest(char.PrimaryPart, obj.Parent, 1)
                    end
                end
            end
        end
    end
end)

-- Lógica Auto Collect Cash (Slot1 a Slot29)
collectBtn.MouseButton1Click:Connect(function()
    autoCollectActive = not autoCollectActive
    if autoCollectActive then
        collectBtn.Text = "Auto Collect: ON"
        collectBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        collectBtn.Text = "Auto Collect: OFF"
        collectBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if autoCollectActive then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for i = 1, 29 do
                    if not autoCollectActive then break end
                    local slotName = "Slot" .. i
                    local slot = workspace:FindFirstChild(slotName, true)
                    
                    if slot then
                        local targetCFrame = slot:IsA("BasePart") and slot.CFrame or slot:GetPivot()
                        hrp.CFrame = targetCFrame + Vector3.new(0, 2, 0)
                        task.wait(0.12) -- Velocidad de recorrido por slot
                    end
                end
            end
        end
    end
end)
