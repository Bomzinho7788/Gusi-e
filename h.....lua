local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local window = OrionLib:MakeWindow({Name = "Bom_Hub_Aim", HidePremium = false, SaveConfig = true, IntroText = "Bom_Hub_Aim"})

-- Tabelas do hub
local tab1 = window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://4483345998"})
local tab2 = window:MakeTab({Name = "Esp", Icon = "rbxassetid://4483345998"})
local tab3 = window:MakeTab({Name = "Others", Icon = "rbxassetid://4483345998"})

-- Configurações e variáveis do FOV
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local aimPart = "Head"
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Transparency = 0.5
fovCircle.Visible = false
local fovRadius = 50
local fovEnabled = false
local aimbotEnabled = false
local wallcheckEnabled = false
local espEnabled = false -- Nova variável para controle do ESP

-- Função para atualizar a posição do círculo da FOV
local function updateFovCircle()
    if fovEnabled then
        local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        fovCircle.Position = mousePos
        fovCircle.Radius = fovRadius
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end
end

RunService.RenderStepped:Connect(updateFovCircle)

-- Função para encontrar o jogador mais próximo no FOV
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(aimPart) then
            local head = targetPlayer.Character[aimPart]
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = head
                end
            end
        end
    end

    return closestPlayer
end

-- Ajusta a mira automaticamente
local function silentAimAtClosestPlayer()
    if aimbotEnabled then
        local targetHead = getClosestPlayerInFOV()

        if targetHead then
            if not wallcheckEnabled or isPlayerVisible(targetHead) then
                local aimPosition = targetHead.Position + Vector3.new(0, 0.5, 0)
                camera.CFrame = CFrame.new(camera.CFrame.Position, aimPosition)
            end
        end
    end
end

RunService.RenderStepped:Connect(silentAimAtClosestPlayer)

-- Função de regeneração de HP
local function regenerateHP()
    while wait(0) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
        end
    end
end

-- Função do ESP (Desenha uma caixa ao redor do jogador)
local function drawESP(targetPlayer)
    local espBox = Drawing.new("Square")
    espBox.Thickness = 2
    espBox.Color = Color3.fromRGB(255, 0, 0) -- Cor da caixa do ESP
    espBox.Filled = false
    espBox.Transparency = 1
    espBox.Visible = false -- Começa invisível

    -- Função para atualizar a caixa ao redor do jogador
    RunService.RenderStepped:Connect(function()
        if espEnabled and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = targetPlayer.Character.HumanoidRootPart
            local head = targetPlayer.Character:FindFirstChild("Head")

            if humanoidRootPart and head then
                local rootPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                local headPos, _ = camera:WorldToViewportPoint(head.Position)
                local distance = (headPos - rootPos).magnitude

                if onScreen then
                    espBox.Size = Vector2.new(distance * 2, distance * 3) -- Ajusta o tamanho da caixa
                    espBox.Position = Vector2.new(rootPos.X - espBox.Size.X / 2, rootPos.Y - espBox.Size.Y / 2)
                    espBox.Visible = true
                else
                    espBox.Visible = false
                end
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end)
end

-- Função para adicionar o ESP aos jogadores
local function addESPToPlayer(player)
    if player.Character then
        drawESP(player)
    end
    player.CharacterAdded:Connect(function()
        drawESP(player)
    end)
end

for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= LocalPlayer then
        addESPToPlayer(targetPlayer)
    end
end

Players.PlayerAdded:Connect(addESPToPlayer)

-- Controles do hub com Orion Lib
tab1:AddToggle({
    Name = "Ativar FOV",
    Default = fovEnabled,
    Callback = function(state)
        fovEnabled = state
    end
})

tab1:AddToggle({
    Name = "Ativar Aimbot",
    Default = aimbotEnabled,
    Callback = function(state)
        aimbotEnabled = state
    end
})

tab1:AddTextbox({
    Name = "Tamanho do FOV (0-100)",
    Default = tostring(fovRadius),
    TextDisappear = false,
    Callback = function(input)
        local value = tonumber(input)
        if value and value >= 0 and value <= 100 then
            fovRadius = value
        else
            print("Por favor, insira um valor entre 0 e 100.")
        end
    end
})

-- Adiciona o toggle de regeneração de HP na aba "Others"
tab3:AddToggle({
    Name = "Regenerar HP",
    Default = false,
    Callback = function(state)
        if state then
            spawn(regenerateHP)
        end
    end
})

-- Adiciona toggle para ativar/desativar o ESP na aba "Esp"
tab2:AddToggle({
    Name = "Ativar ESP Box",
    Default = espEnabled,
    Callback = function(state)
        espEnabled = state
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addESPToPlayer(player)
            end
        end
    end
})

-- Botões da aba "Others"
tab3:AddButton({
    Name = "Fechar Hub",
    Callback = function()
        OrionLib:Destroy()
    end
})

tab3:AddButton({
    Name = "Salvar Configurações",
    Callback = function()
        OrionLib:Save()
        print("Configurações salvas!")
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espLineEnabled = false -- Variável para controlar o estado do ESP Line
local lines = {} -- Armazena as linhas de ESP

local function createESPLine(player)
    local Line = Drawing.new("Line")
    Line.Color = Color3.new(1, 0, 0) -- Vermelho
    Line.Thickness = 1 -- Linhas mais finas
    Line.Transparency = 1
    Line.Visible = false -- Inicialmente invisível

    lines[player] = Line -- Armazena a linha para o jogador

    RunService.RenderStepped:Connect(function()
        if espLineEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Parte de cima da tela (meio)
                Line.To = Vector2.new(screenPos.X, screenPos.Y)
                Line.Visible = true
            else
                Line.Visible = false
            end
        else
            Line.Visible = false -- Esconde a linha se não estiver ativada
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(0.5) -- Pequeno atraso para garantir que o personagem tenha carregado
            createESPLine(player)
        end)
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createESPLine(player)
        player.CharacterAdded:Connect(function()
            wait(0.5)
            createESPLine(player)
        end)
    end
end

-- Adiciona o toggle para o ESP Line na aba 2
tab2:AddToggle({
    Name = "Esp Line",
    Default = espLineEnabled,  -- Estado inicial do toggle
    Callback = function(state)
        espLineEnabled = state -- Atualiza a variável com o estado do toggle
        for _, line in pairs(lines) do
            line.Visible = state -- Atualiza a visibilidade de todas as linhas com base no estado do toggle
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local chamsEnabled = false
local chamsLoop

-- Função para aplicar chams com Highlight
local function applyChams(player)
    if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("Chams") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Chams"
        highlight.FillColor = Color3.new(1, 0, 0) -- Vermelho
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 1
        highlight.Parent = player.Character
    end
end

-- Função para ligar e desligar o chams
local function toggleChams(state)
    if state then
        -- Ativa o loop para aplicar chams
        chamsLoop = coroutine.wrap(function()
            while chamsEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    applyChams(player)
                end
                wait(0.25)
            end
        end)
        chamsLoop()
    else
        -- Desativa o chams removendo os highlights
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Chams") then
                player.Character.Chams:Destroy()
            end
        end
    end
end

-- Toggle para ativar/desativar o chams na aba 2
tab2:AddToggle({
    Name = "Chams",
    Default = chamsEnabled,
    Callback = function(state)
        chamsEnabled = state
        toggleChams(state)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local skeletonEnabled = false -- Variável para controlar se o Skeleton ESP está ativado

-- Função para criar o esqueleto
local function createSkeleton(character)
    local parts = {
        Head = character:FindFirstChild("Head"),
        Torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"),
        LeftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm"),
        RightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm"),
        LeftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg"),
        RightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
    }

    local lines = {}
    for i = 1, 7 do
        local line = Drawing.new("Line")
        line.Color = Color3.new(1, 0, 0) -- Preto
        line.Thickness = 1
        line.Transparency = 1
        lines[i] = line
    end

    local function updateSkeleton()
        if skeletonEnabled and character.Parent and parts.Head and parts.Torso and parts.LeftArm and parts.RightArm and parts.LeftLeg and parts.RightLeg then
            local headPos, headVis = Camera:WorldToViewportPoint(parts.Head.Position)
            local torsoPos, torsoVis = Camera:WorldToViewportPoint(parts.Torso.Position)
            local leftArmPos, leftArmVis = Camera:WorldToViewportPoint(parts.LeftArm.Position)
            local rightArmPos, rightArmVis = Camera:WorldToViewportPoint(parts.RightArm.Position)
            local leftLegPos, leftLegVis = Camera:WorldToViewportPoint(parts.LeftLeg.Position)
            local rightLegPos, rightLegVis = Camera:WorldToViewportPoint(parts.RightLeg.Position)

            if headVis and torsoVis and leftArmVis and rightArmVis and leftLegVis and rightLegVis then
                lines[1].From, lines[1].To = Vector2.new(headPos.X, headPos.Y), Vector2.new(torsoPos.X, torsoPos.Y)
                lines[2].From, lines[2].To = Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(leftArmPos.X, leftArmPos.Y)
                lines[3].From, lines[3].To = Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(rightArmPos.X, rightArmPos.Y)
                lines[4].From, lines[4].To = Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(leftLegPos.X, leftLegPos.Y)
                lines[5].From, lines[5].To = Vector2.new(torsoPos.X, torsoPos.Y), Vector2.new(rightLegPos.X, rightLegPos.Y)
                lines[6].From, lines[6].To = Vector2.new(leftArmPos.X, leftArmPos.Y), Vector2.new(leftLegPos.X, leftLegPos.Y)
                lines[7].From, lines[7].To = Vector2.new(rightArmPos.X, rightArmPos.Y), Vector2.new(rightLegPos.X, rightLegPos.Y)
                for _, line in pairs(lines) do line.Visible = true end
            else
                for _, line in pairs(lines) do line.Visible = false end
            end
        else
            for _, line in pairs(lines) do line.Visible = false end
        end
    end

    RunService.RenderStepped:Connect(updateSkeleton)
end

-- Função para lidar com novos jogadores
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            wait(0.5)
            createSkeleton(character)
        end)
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createSkeleton(player.Character)
        player.CharacterAdded:Connect(function(character)
            wait(0.5)
            createSkeleton(character)
        end)
    end
end

-- Adicionando o Toggle na aba 2 existente
tab2:AddToggle({
    Name = "Ativar Skeleton ESP",
    Default = false,
    Callback = function(value)
        skeletonEnabled = value -- Atualiza a variável quando o toggle é ativado/desativado
    end,
})

tab3:AddToggle({
    Name = "Gun Grounds FFA",
    Default = false,
    Callback = function(value)
        -- Hi don't look at the code it is trash just use it :)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RunService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local plr = players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()

--> [< Variables >] <--

local hue = 0
local rainbowFov = false
local rainbowSpeed = 0.005

local aimFov = 100
local aiming = false
local predictionStrength = 0.065

local gmEnabled = false

local fireRate = 0.3
local pelletAmount = 1
local reloadTime = 0
local damageDropOff = 0
local isAuto = true
local delayedShell = false
local recoilEnabled = false
local Recoil = Vector3.new(0, 0, 0)
local viewmodelEnabled = false
local viewModelOffset = Vector3.new(0.1, -1.7, 0)

local hitEffectEnabled = false
local aimbotEnabled = false

local hitEffect = "Gib_F"

local e = false

--> [< Variables >] <--

local Window = Rayfield:CreateWindow({
	Name = "▶ Gun Grounds FFA ◀",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "by Bomzinho 🥵",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "GunGroundsFFA",
		FileName = "byBomzinho"
	},
})

local Main = Window:CreateTab("Gun Mods 🔫")
local Aimbot = Window:CreateTab("Aimbot 🎯")
local ViewModel = Window:CreateTab("Viewmodel 👀")

--> [< Gun Mods >] <--

local forcereset = Main:CreateKeybind({
	Name = "Force Reset",
	CurrentKeybind = "T",
	HoldToInteract = false,
	Flag = "ForceReset",
	Callback = function(Keybind)
        if plr.Character then
            plr.Character.Humanoid:TakeDamage(plr.Character.Humanoid.Health)
            Rayfield:Notify({
                Title = "Force Reset",
                Content = "Done!",
                Duration = 1,
                Image = 4483362458,
            })
        end
	end,
})

local gunmods = Main:CreateToggle({
    Name = "Gun Mods Enabled",
    CurrentValue = false,
    Flag = "GunModsEnabled",
    Callback = function(Value)
        gmEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Gun Mod",
                Content = "Reset to enable!",
                Duration = 1,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Gun Mod",
                Content = "Reset to disable!",
                Duration = 1,
                Image = 4483362458,
            })
        end
        while gmEnabled do
            if plr.Character then
                local folder = plr.Character:FindFirstChildWhichIsA("Tool")
                
                if folder and folder:FindFirstChild("Configuration") then
                    for _, v in ipairs(folder.Configuration:GetChildren()) do
                        if v.Name == "FireRate" and not e then
                            e = true
                            v.Value = v.Value * fireRate
                        end
                        if v.Name == "reloadTime" then
                            v.Value = reloadTime
                        end
                        if v.Name == "DamageDropoff" then
                            v.Value = damageDropOff
                        end
                        if v.Name == "isAuto" then
                            v.Value = isAuto
                        end
                        if v.Name == "DelayedShell" then
                            v.Value = delayedShell
                        end
                        if v.Name == "Recoil" then
                            if recoilEnabled then
                                v.Value = Recoil
                            end
                        end
                    end
                    if hitEffectEnabled then
                        local heffect = folder.Configuration:FindFirstChild("HitEffect")
                        if heffect then
                            heffect.Value = hitEffect
                        else
                            heffect = Instance.new("StringValue")
                            heffect.Name = "HitEffect"
                            heffect.Value = hitEffect
                            heffect.Parent = folder.Configuration
                        end
                    end
                else
                    e = false
                end
            end
            wait()
        end 
    end
})

local firerate = Main:CreateSlider({
	Name = "Fire Rate",
	Range = {0, 1},
	Increment = 0.1,
	CurrentValue = 0.3,
	Flag = "FireRate",
	Callback = function(Value)
        fireRate = Value
        Rayfield:Notify({
            Title = "Fire Rate",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local reloadtime = Main:CreateSlider({
	Name = "Reload Time",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 0,
	Flag = "ReloadTime",
	Callback = function(Value)
        reloadTime = Value
        Rayfield:Notify({
            Title = "Reload Time",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local dmgdropoff = Main:CreateSlider({
	Name = "Damage Drop Off",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 0,
	Flag = "DamageDropOff",
	Callback = function(Value)
        damageDropOff = Value
        Rayfield:Notify({
            Title = "Damage Drop Off",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local forceauto = Main:CreateToggle({
    Name = "Force Auto",
    CurrentValue = true,
    Flag = "ForceAuto",
    Callback = function(Value)
        isAuto = Value
        Rayfield:Notify({
            Title = "Force Auto",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
    end
})

local rapidshotguns = Main:CreateToggle({
    Name = "Rapid Shotguns",
    CurrentValue = true,
    Flag = "RapidShotguns",
    Callback = function(Value)
        delayedShell = not Value
        Rayfield:Notify({
            Title = "Rapid Shotguns",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
    end
})

local recoilmodifier = Main:CreateToggle({
    Name = "Recoil Modifier",
    CurrentValue = false,
    Flag = "RecoilModifier",
    Callback = function(Value)
        recoilEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Recoil Modifier",
                Content = "Reset to enable!",
                Duration = 1,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Recoil Modifier",
                Content = "Reset to disable!",
                Duration = 1,
                Image = 4483362458,
            })
        end
    end
})

local recoilx = Main:CreateSlider({
	Name = "Recoil X",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 0,
	Flag = "RecoilX",
	Callback = function(Value)
        Recoil = Vector3.new(Value, Recoil.Y, Recoil.Z)
        Rayfield:Notify({
            Title = "Recoil X",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local recoily = Main:CreateSlider({
	Name = "Recoil Y",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 0,
	Flag = "RecoilY",
	Callback = function(Value)
        Recoil = Vector3.new(Recoil.X, Value, Recoil.Z)
        Rayfield:Notify({
            Title = "Recoil Y",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local recoilz = Main:CreateSlider({
	Name = "Recoil Z",
	Range = {0, 100},
	Increment = 1,
	CurrentValue = 0,
	Flag = "RecoilZ",
	Callback = function(Value)
        Recoil = Vector3.new(Recoil.X, Recoil.Y, Value)
        Rayfield:Notify({
            Title = "Recoil Z",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local hiteffectE = Main:CreateToggle({
    Name = "Hit Effect [FE]",
    CurrentValue = false,
    Flag = "HitEffectEnabled",
    Callback = function(Value)
        hitEffectEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Hit Effect",
                Content = "Reset to enable!",
                Duration = 1,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Hit Effect",
                Content = "Reset to disable!",
                Duration = 1,
                Image = 4483362458,
            })
        end
    end
})

local hiteffect = Main:CreateDropdown({
	Name = "Select Hit Effect",
	Options = {"Gib_W", "Gib_G", "Gib_H", "Gib_T", "Gib_F"},
	CurrentOption = "Gib_F",
	Flag = "HitEffect",
	Callback = function(Option)
        if type(Option) == "table" then
            hitEffect = Option[1]
        else
            hitEffect = Option
        end
        Rayfield:Notify({
            Title = "Hit Effect",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

--> [< Gun Mods >] <--

--> [< Aimbot >] <--

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 12
fovCircle.Radius = aimFov
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Visible = false

local currentTarget = nil

local function isWallBetween(targetCharacter)
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return true end

    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin).unit * (targetHead.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {plr.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestCursorDistance = aimFov
    local shortestPlayerDistance = math.huge
    local cameraPos = camera.CFrame.Position

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local headPos = camera:WorldToViewportPoint(head.Position)
            local screenPos = Vector2.new(headPos.X, headPos.Y)
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local cursorDistance = (screenPos - mousePos).Magnitude
            local playerDistance = (head.Position - cameraPos).Magnitude

            if cursorDistance < shortestCursorDistance and headPos.Z > 0 then
                if not isWallBetween(player.Character) then
                    if playerDistance < shortestPlayerDistance then
                        shortestPlayerDistance = playerDistance
                        shortestCursorDistance = cursorDistance
                        nearestPlayer = player
                    end
                end
            end
        end
    end

    return nearestPlayer
end

local function predictPlayerPosition(player)
    if player and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
        local head = player.Character.Head
        local hrp = player.Character.HumanoidRootPart
        local velocity = hrp.Velocity
        local predictedPosition = head.Position + (velocity * predictionStrength)
        return predictedPosition
    end
    return nil
end

local function aimAtPlayer(player)
    local predictedPosition = predictPlayerPosition(player)
    if predictedPosition then
        camera.CFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local offset = 50
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + offset)

        if rainbowFov then
            hue = hue + rainbowSpeed
            if hue > 1 then hue = 0 end
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        end

        if aiming then
            if currentTarget and isWallBetween(currentTarget.Character) then
                currentTarget = nil
            end

            if not currentTarget then
                currentTarget = getNearestPlayer()
            end

            if currentTarget then
                aimAtPlayer(currentTarget)
            end
        else
            currentTarget = nil
        end
    end
end)

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        aiming = true
    end
end)

mouse.Button2Up:Connect(function()
    if aimbotEnabled then
        aiming = false
    end
end)

local aimbot = Aimbot:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        fovCircle.Visible = Value
    end
})

local aimbotfov = Aimbot:CreateSlider({
	Name = "Aimbot Fov",
	Range = {0, 360},
	Increment = 1,
	CurrentValue = 100,
	Flag = "AimbotFov",
	Callback = function(Value)
        aimFov = Value
        fovCircle.Radius = aimFov
	end,
})

local circlecolor = Aimbot:CreateColorPicker({
    Name = "Fov Color",
    Color = fovCircle.Color,
    Callback = function(Color)
        fovCircle.Color = Color
    end
})

local circlerainbow = Aimbot:CreateToggle({
    Name = "Rainbow Fov",
    CurrentValue = false,
    Flag = "RainbowFov",
    Callback = function(Value)
        rainbowFov = Value
    end
})

local rainbowspeed = Aimbot:CreateSlider({
	Name = "Rainbow Speed",
	Range = {1, 10},
	Increment = 1,
	CurrentValue = 5,
	Flag = "RainbowSpeed",
	Callback = function(Value)
        rainbowSpeed = Value * 0.001
	end,
})

local predictionstrength = Aimbot:CreateSlider({
	Name = "Prediction Strength",
	Range = {0, 20},
	Increment = 0.1,
	CurrentValue = 6.5,
	Flag = "AimbotStrength",
	Callback = function(Value)
        predictionStrength = Value * 0.001
	end,
})

--> [< Aimbot >] <--

--> [< View Model Offset >] <--

local viewmodeleditor = ViewModel:CreateToggle({
    Name = "View Model Editor",
    CurrentValue = false,
    Flag = "RecoilModifier",
    Callback = function(Value)
        viewmodelEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "View Model Editor",
                Content = "Reset to enable!",
                Duration = 1,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "View Model Editor",
                Content = "Reset to disable!",
                Duration = 1,
                Image = 4483362458,
            })
        end
        while viewmodelEnabled do
            if plr.Character then
                local folder = plr.Character:FindFirstChildWhichIsA("Tool")
                
                if folder and folder:FindFirstChild("Configuration") then
                    for _, v in ipairs(folder.Configuration:GetChildren()) do
                        if v.Name == "ViewModelOffset" then
                            if viewmodelEnabled then
                                v.Value = viewModelOffset
                            end
                        end
                    end
                end
            end
            wait()
        end
    end
})

local viewmodelz = ViewModel:CreateSlider({
	Name = "View Model X",
	Range = {-10, 10},
	Increment = 1,
	CurrentValue = 0,
	Flag = "ViewModelX",
	Callback = function(Value)
        viewModelOffset = Vector3.new(Value, viewModelOffset.Y, viewModelOffset.Z)
        Rayfield:Notify({
            Title = "View Model X",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local viewmodely = ViewModel:CreateSlider({
	Name = "View Model Y",
	Range = {-10, 10},
	Increment = 1,
	CurrentValue = -4,
	Flag = "ViewModelY",
	Callback = function(Value)
        viewModelOffset = Vector3.new(viewModelOffset.X, Value, viewModelOffset.Z)
        Rayfield:Notify({
            Title = "View Model Y",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

local viewmodelz = ViewModel:CreateSlider({
	Name = "View Model Z",
	Range = {-10, 10},
	Increment = 1,
	CurrentValue = 0,
	Flag = "ViewModelZ",
	Callback = function(Value)
        viewModelOffset = Vector3.new(viewModelOffset.X, viewModelOffset.Y, Value)
        Rayfield:Notify({
            Title = "View Model Z",
            Content = "Reset to update!",
            Duration = 1,
            Image = 4483362458,
        })
	end,
})

--> [< View Model Offset >] <-- -- Atualiza a variável quando o toggle é ativado/desativado
    end,
})

Tab3:AddLabel("Por Bomzinho")

-- Inicializa o hub
OrionLib:Init()