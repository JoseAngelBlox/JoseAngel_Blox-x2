-- Buscamos dónde poner la GUI (Delta usa gethui() para ocultarla de los anti-cheats)
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")

-- Si ya existe una versión anterior, la borramos para no duplicarla
if guiParent:FindFirstChild("JoseAngel_Menu") then
    guiParent.JoseAngel_Menu:Destroy()
end

-- Creamos la Interfaz (ScreenGui)
local gui = Instance.new("ScreenGui")
gui.Name = "JoseAngel_Menu"
gui.Parent = guiParent

-- Creamos el cuadrado principal (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 280)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Gris oscuro/Negro
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

-- Redondeamos las esquinas del cuadrado principal
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "JoseAngel_Blox x2"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dorado
title.Parent = mainFrame

-- Efecto de brillo
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 255, 100)
glow.Transparency = 0.5
glow.Thickness = 1.5
glow.Parent = title

-- Función para crear botones
local function createToggle(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = UDim2.new(0.5, -80, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Rojo
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

local btnMultiplicador = createToggle("Multiplicador x2", 60)
local btnAutoFarm = createToggle("Auto Farm", 115)
local btnAutoCollect = createToggle("Auto Collect", 170)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local isMultiplicadorOn = false
local isAutoFarmOn = false
local isAutoCollectOn = false


-- ==========================================
-- Lógica: Multiplicador x2
-- ==========================================
btnMultiplicador.MouseButton1Click:Connect(function()
    isMultiplicadorOn = not isMultiplicadorOn
    if isMultiplicadorOn then
        btnMultiplicador.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        btnMultiplicador.Text = "Multiplicador x2: ON"
        task.spawn(function()
            while isMultiplicadorOn do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_TaviMishkal"):FireServer()
                end)
                task.wait(0.2) 
            end
        end)
    else
        btnMultiplicador.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        btnMultiplicador.Text = "Multiplicador x2: OFF"
    end
end)


-- ==========================================
-- Lógica: Auto Farm (Correr hacia KickReady)
-- ==========================================
btnAutoFarm.MouseButton1Click:Connect(function()
    isAutoFarmOn = not isAutoFarmOn
    if isAutoFarmOn then
        btnAutoFarm.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        btnAutoFarm.Text = "Auto Farm: ON"
        task.spawn(function()
            while isAutoFarmOn do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local kickReady = game.Workspace:FindFirstChild("KickReady", true) 
                        if kickReady and kickReady:IsA("BasePart") then
                            char.Humanoid:MoveTo(kickReady.Position)
                        end
                    end
                end)
                task.wait(0.5) 
            end
        end)
    else
        btnAutoFarm.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        btnAutoFarm.Text = "Auto Farm: OFF"
    end
end)


-- ==========================================
-- Lógica: Auto Collect (Simular Toque sin TP)
-- ==========================================
local miBase = nil 

btnAutoCollect.MouseButton1Click:Connect(function()
    isAutoCollectOn = not isAutoCollectOn
    
    if isAutoCollectOn then
        btnAutoCollect.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        btnAutoCollect.Text = "Auto Collect: ON"
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- Buscamos el Slot1 más cercano para registrar TU base
            local distanciaMasCorta = math.huge
            local slot1MasCercano = nil
            
            for _, objeto in pairs(game.Workspace:GetDescendants()) do
                if objeto:IsA("BasePart") and objeto.Name == "Slot1" then
                    local distancia = (objeto.Position - char.HumanoidRootPart.Position).Magnitude
                    if distancia < distanciaMasCorta then
                        distanciaMasCorta = distancia
                        slot1MasCercano = objeto
                    end
                end
            end
            
            if slot1MasCercano then
                miBase = slot1MasCercano.Parent
            else
                miBase = game.Workspace
            end
        end
        
        -- Iniciar recolección "Fantasma" (Sin moverse)
        task.spawn(function()
            while isAutoCollectOn do
                pcall(function()
                    local char = LocalPlayer.Character
                    -- Necesitamos la HumanoidRootPart para simular que esa parte tocó el dinero
                    if char and char:FindFirstChild("HumanoidRootPart") and miBase then
                        local rootPart = char.HumanoidRootPart
                        
                        for i = 1, 29 do
                            if not isAutoCollectOn then break end 
                            
                            local slotName = "Slot" .. tostring(i)
                            local slot = miBase:FindFirstChild(slotName, true)
                            
                            if slot and slot:IsA("BasePart") then
                                -- Magia: Simulamos que tocamos el slot (0) y lo soltamos (1)
                                firetouchinterest(rootPart, slot, 0)
                                task.wait(0.05) -- Pausa super corta
                                firetouchinterest(rootPart, slot, 1)
                            end
                        end
                        
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        btnAutoCollect.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        btnAutoCollect.Text = "Auto Collect: OFF"
        miBase = nil 
        end
end)
