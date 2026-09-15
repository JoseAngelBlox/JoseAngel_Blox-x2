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
glow.Color = Color3.fromRGB(255, 255, 100)
glow.Transparency = 0.5
glow.Thickness = 1.5
glow.Parent = title

-- Función para crear botones
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

-- Creamos los 3 botones
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
-- Lógica: Auto Collect (Búsqueda por Usuario de Roblox)
-- ==========================================
local miBase = nil 

btnAutoCollect.MouseButton1Click:Connect(function()
    isAutoCollectOn = not isAutoCollectOn
    
    if isAutoCollectOn then
        btnAutoCollect.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        btnAutoCollect.Text = "Auto Collect: ON"
        
        miBase = nil 
        local miUsuario = LocalPlayer.Name -- Obtenemos tu usuario exacto de Roblox
        
        -- ESTRATEGIA 1: Buscar si la carpeta principal de la base tiene tu nombre de usuario
        for _, obj in pairs(game.Workspace:GetChildren()) do
            if obj.Name == miUsuario and obj:FindFirstChild("Slot1", true) then
                miBase = obj
                break
            end
        end
        
        -- ESTRATEGIA 2: Buscar una etiqueta con tu nombre y subir por las carpetas
        if not miBase then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if (obj:IsA("StringValue") and obj.Value == miUsuario) or (obj:IsA("ObjectValue") and obj.Value == LocalPlayer) then
                    -- Si encontramos tu nombre, subimos por los "Parent" hasta dar con la base que tiene los Slots
                    local padre = obj.Parent
                    while padre and padre ~= game.Workspace do
                        if padre:FindFirstChild("Slot1", true) then
                            miBase = padre
                            break
                        end
                        padre = padre.Parent -- Sube un nivel en la carpeta
                    end
                end
                if miBase then break end -- Si ya la encontró, detiene la búsqueda
            end
        end
        
        -- ESTRATEGIA 3 (Emergencia): Si el juego no guarda tu nombre en ninguna parte
        if not miBase then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
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
                    -- Vuelve a subir por las carpetas para asegurar que es toda la base
                    local padre = slot1MasCercano.Parent
                    while padre and padre ~= game.Workspace do
                        if padre:FindFirstChild("Slot2", true) then
                            miBase = padre
                            break
                        end
                        padre = padre.Parent
                    end
                    if not miBase then miBase = slot1MasCercano.Parent end
                end
            end
        end
        
        -- INICIA EL BUCLE SÓLO EN LA BASE ENCONTRADA
        task.spawn(function()
            while isAutoCollectOn do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and miBase then
                        
                        for i = 1, 29 do
                            if not isAutoCollectOn then break end 
                            
                            local slotName = "Slot" .. tostring(i)
                            local slot = miBase:FindFirstChild(slotName, true)
                            
                            if slot and slot:IsA("BasePart") then
                                char.HumanoidRootPart.CFrame = slot.CFrame
                                task.wait(0.1) 
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
