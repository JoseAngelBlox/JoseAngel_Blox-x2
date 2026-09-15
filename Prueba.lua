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
mainFrame.Size = UDim2.new(0, 220, 0, 280) -- Ampliado para los 3 botones
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Gris oscuro/Negro
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Hace que lo puedas mover por la pantalla
mainFrame.Parent = gui

-- Redondeamos las esquinas del cuadrado principal
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Título actualizado: JoseAngel_Blox x2
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "JoseAngel_Blox x2"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dorado
title.Parent = mainFrame

-- Efecto de brillo para las letras doradas
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 255, 100) -- Amarillo brillante
glow.Transparency = 0.5
glow.Thickness = 1.5
glow.Parent = title

-- Función para crear botones y ahorrar líneas de código
local function createToggle(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = UDim2.new(0.5, -80, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Rojo (Apagado)
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

-- Creamos los 3 botones en distintas posiciones (Y)
local btnMultiplicador = createToggle("Multiplicador x2", 60)
local btnAutoFarm = createToggle("Auto Farm", 115)
local btnAutoCollect = createToggle("Auto Collect", 170)

-- Variables de juego
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Estados de los botones
local isMultiplicadorOn = false
local isAutoFarmOn = false
local isAutoCollectOn = false


-- ==========================================
-- Lógica: Multiplicador x2
-- ==========================================
btnMultiplicador.MouseButton1Click:Connect(function()
    isMultiplicadorOn = not isMultiplicadorOn
    
    if isMultiplicadorOn then
        btnMultiplicador.BackgroundColor3 = Color3.fromRGB(40, 200, 40) -- Verde
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
        btnMultiplicador.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Rojo
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
                        -- Buscamos el objeto KickReady en cualquier lugar del Workspace
                        local kickReady = game.Workspace:FindFirstChild("KickReady", true) 
                        if kickReady and kickReady:IsA("BasePart") then
                            -- Hace que el personaje camine hacia esa posición
                            char.Humanoid:MoveTo(kickReady.Position)
                        end
                    end
                end)
                task.wait(0.5) -- Actualiza la posición cada medio segundo
            end
        end)
    else
        btnAutoFarm.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        btnAutoFarm.Text = "Auto Farm: OFF"
    end
end)


-- ==========================================
-- Lógica: Auto Collect (TP a los Slots 1-29)
-- ==========================================
btnAutoCollect.MouseButton1Click:Connect(function()
    isAutoCollectOn = not isAutoCollectOn
    
    if isAutoCollectOn then
        btnAutoCollect.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        btnAutoCollect.Text = "Auto Collect: ON"
        
        task.spawn(function()
            while isAutoCollectOn do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        
                        -- Bucle del 1 al 29
                        for i = 1, 29 do
                            if not isAutoCollectOn then break end -- Si lo apagas a la mitad, se detiene de golpe
                            
                            local slotName = "Slot" .. tostring(i)
                            local slot = game.Workspace:FindFirstChild(slotName, true)
                            
                            if slot and slot:IsA("BasePart") then
                                -- Teletransporta al jugador
                                char.HumanoidRootPart.CFrame = slot.CFrame
                                
                                -- IMPORTANTE: Una pequeña pausa de 0.1s para que el juego registre que tocaste el dinero
                                task.wait(0.1) 
                            end
                        end
                        
                    end
                end)
                task.wait(0.5) -- Pausa corta antes de volver a empezar desde el Slot1
            end
        end)
    else
        btnAutoCollect.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        btnAutoCollect.Text = "Auto Collect: OFF"
    end
end)
