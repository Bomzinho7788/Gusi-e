local camera = workspace.CurrentCamera
local entities = game:GetService("Players")
local LocalPlayer = entities.LocalPlayer
local runservice = game:GetService("RunService")

local function draw6(player, character)
    local skel_head = Drawing.new("Line")
    local skel_torso = Drawing.new("Line")
    local skel_right_lower_arm = Drawing.new("Line")
    local skel_left_lower_arm = Drawing.new("Line")
    local skel_right_lower_leg = Drawing.new("Line")
    local skel_left_lower_leg = Drawing.new("Line")

    local function update6()
        local connection
        connection = runservice.RenderStepped:Connect(function()
            if game.workspace:FindFirstChild(character.Name) and character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").Health > 0 and character.HumanoidRootPart then
                local character_rootpart_3d = character.HumanoidRootPart.Position
                local character_rootpart_2d, rootpart_onscreen = camera:WorldToViewportPoint(character_rootpart_3d)

                if rootpart_onscreen and character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
                    local head_2d = camera:WorldToViewportPoint(character.Head.Position)
                    local torso_upper_2d = camera:WorldToViewportPoint(character.Torso.Position + Vector3.new(0, 0.75, 0))
                    local torso_lower_2d = camera:WorldToViewportPoint(character.Torso.Position + Vector3.new(0, -0.75, 0))

                    local rightarmlower_2d = camera:WorldToViewportPoint(character["Right Arm"].Position + Vector3.new(0, -0.75, 0))
                    local rightarmupper_2d = camera:WorldToViewportPoint(character["Right Arm"].Position + Vector3.new(0, 0.1625, 0))
                    local leftarmupper_2d = camera:WorldToViewportPoint(character["Left Arm"].Position + Vector3.new(0, 0.1625, 0))
                    local leftarmlower_2d = camera:WorldToViewportPoint(character["Left Arm"].Position + Vector3.new(0, -0.75, 0))
                    local rightleglower_2d = camera:WorldToViewportPoint(character["Right Leg"].Position + Vector3.new(0, -1.1, 0))
                    local leftleglower_2d = camera:WorldToViewportPoint(character["Left Leg"].Position + Vector3.new(0, -1.1, 0))

                    skel_head.From = Vector2.new(head_2d.X, head_2d.Y)
                    skel_head.To = Vector2.new(torso_upper_2d.X, torso_upper_2d.Y)

                    skel_torso.From = Vector2.new(torso_upper_2d.X, torso_upper_2d.Y)
                    skel_torso.To = Vector2.new(torso_lower_2d.X, torso_lower_2d.Y)

                    skel_left_lower_arm.From = Vector2.new(torso_upper_2d.X, torso_upper_2d.Y)
                    skel_left_lower_arm.To = Vector2.new(leftarmlower_2d.X, leftarmlower_2d.Y)

                    skel_right_lower_arm.From = Vector2.new(torso_upper_2d.X, torso_upper_2d.Y)
                    skel_right_lower_arm.To = Vector2.new(rightarmlower_2d.X, rightarmlower_2d.Y)

                    skel_left_lower_leg.From = Vector2.new(torso_lower_2d.X, torso_lower_2d.Y)
                    skel_left_lower_leg.To = Vector2.new(leftleglower_2d.X, leftleglower_2d.Y)

                    skel_right_lower_leg.From = Vector2.new(torso_lower_2d.X, torso_lower_2d.Y)
                    skel_right_lower_leg.To = Vector2.new(rightleglower_2d.X, rightleglower_2d.Y)

                    skel_head.Visible = _G.EspSkeleton
                    skel_torso.Visible = _G.EspSkeleton
                    skel_left_lower_arm.Visible = _G.EspSkeleton
                    skel_right_lower_arm.Visible = _G.EspSkeleton
                    skel_left_lower_leg.Visible = _G.EspSkeleton
                    skel_right_lower_leg.Visible = _G.EspSkeleton

                    skel_head.Color = _G.SkeletonColor
                    skel_torso.Color = _G.SkeletonColor
                    skel_left_lower_arm.Color = _G.SkeletonColor
                    skel_right_lower_arm.Color = _G.SkeletonColor
                    skel_left_lower_leg.Color = _G.SkeletonColor
                    skel_right_lower_leg.Color = _G.SkeletonColor
                    
                    skel_head.Transparency = _G.SkeletonTransparency
                    skel_torso.Transparency = _G.SkeletonTransparency
                    skel_left_lower_arm.Transparency = _G.SkeletonTransparency
                    skel_right_lower_arm.Transparency = _G.SkeletonTransparency
                    skel_left_lower_leg.Transparency = _G.SkeletonTransparency
                    skel_right_lower_leg.Transparency = _G.SkeletonTransparency

                    skel_head.Thickness = _G.SkeletonThickness
                    skel_torso.Thickness = _G.SkeletonThickness
                    skel_left_lower_arm.Thickness = _G.SkeletonThickness
                    skel_right_lower_arm.Thickness = _G.SkeletonThickness
                    skel_left_lower_leg.Thickness = _G.SkeletonThickness
                    skel_right_lower_leg.Thickness = _G.SkeletonThickness
                else
                    skel_head.Visible = false
                    skel_torso.Visible = false
                    skel_left_lower_arm.Visible = false
                    skel_right_lower_arm.Visible = false
                    skel_left_lower_leg.Visible = false
                    skel_right_lower_leg.Visible = false
                end
            else
                if player == nil then
                    connection:Disconnect()
                    connection = nil
                end

                skel_head.Visible = false
                skel_torso.Visible = false
                skel_left_lower_arm.Visible = false
                skel_right_lower_arm.Visible = false
                skel_left_lower_leg.Visible = false
                skel_right_lower_leg.Visible = false
            end
        end)
    end
    coroutine.wrap(update6)()
    return skel_head, skel_torso, skel_left_upper_arm, skel_right_upper_arm, skel_left_lower_arm, skel_right_lower_arm, skel_left_upper_leg, skel_right_upper_leg, skel_left_lower_leg, skel_right_lower_leg
end

local function draw15(player, character)
    local skel_head = Drawing.new("Line")
    local skel_upperTorso = Drawing.new("Line")
    local skel_lowerTorso = Drawing.new("Line")
    local skel_rightUpperArm = Drawing.new("Line")
    local skel_rightLowerArm = Drawing.new("Line")
    local skel_rightHand = Drawing.new("Line")
    local skel_leftUpperArm = Drawing.new("Line")
    local skel_leftLowerArm = Drawing.new("Line")
    local skel_leftHand = Drawing.new("Line")
    local skel_rightUpperLeg = Drawing.new("Line")
    local skel_rightLowerLeg = Drawing.new("Line")
    local skel_rightFoot = Drawing.new("Line")
    local skel_leftUpperLeg = Drawing.new("Line")
    local skel_leftLowerLeg = Drawing.new("Line")
    local skel_leftFoot = Drawing.new("Line")

    local function update15()
        local connection
        connection = runservice.RenderStepped:Connect(function()

            if game.workspace:FindFirstChild(character.Name) and character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").Health > 0 and character.HumanoidRootPart then
                local character_rootpart_3d = character.HumanoidRootPart.Position
                local character_rootpart_2d, rootpart_onscreen = camera:WorldToViewportPoint(character_rootpart_3d)

                if rootpart_onscreen and character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
                    wait(0.001)
                    local head_2d = camera:WorldToViewportPoint(character.Head.Position)
                    local upperTorso_2d = camera:WorldToViewportPoint(character.UpperTorso.Position)
                    local lowerTorso_2d = camera:WorldToViewportPoint(character.LowerTorso.Position)
                    local rightUpperArm_2d = camera:WorldToViewportPoint(character.RightUpperArm.Position)
                    local rightLowerArm_2d = camera:WorldToViewportPoint(character.RightLowerArm.Position)
                    local rightHand_2d = camera:WorldToViewportPoint(character.RightHand.Position)
                    local leftUpperArm_2d = camera:WorldToViewportPoint(character.LeftUpperArm.Position)
                    local leftLowerArm_2d = camera:WorldToViewportPoint(character.LeftLowerArm.Position)
                    local leftHand_2d = camera:WorldToViewportPoint(character.LeftHand.Position)
                    local rightUpperLeg_2d = camera:WorldToViewportPoint(character.RightUpperLeg.Position)
                    local rightLowerLeg_2d = camera:WorldToViewportPoint(character.RightLowerLeg.Position)
                    local rightFoot_2d = camera:WorldToViewportPoint(character.RightFoot.Position)
                    local leftUpperLeg_2d = camera:WorldToViewportPoint(character.LeftUpperLeg.Position)
                    local leftLowerLeg_2d = camera:WorldToViewportPoint(character.LeftLowerLeg.Position)
                    local leftFoot_2d = camera:WorldToViewportPoint(character.LeftFoot.Position)

                    skel_head.From = Vector2.new(head_2d.X, head_2d.Y)
                    skel_head.To = Vector2.new(upperTorso_2d.X, upperTorso_2d.Y)

                    skel_upperTorso.From = Vector2.new(upperTorso_2d.X, upperTorso_2d.Y)
                    skel_upperTorso.To = Vector2.new(lowerTorso_2d.X, lowerTorso_2d.Y)

                    skel_leftUpperArm.From = Vector2.new(upperTorso_2d.X, upperTorso_2d.Y)
                    skel_leftUpperArm.To = Vector2.new(leftUpperArm_2d.X, leftUpperArm_2d.Y)

                    skel_leftLowerArm.From = Vector2.new(leftUpperArm_2d.X, leftUpperArm_2d.Y)
                    skel_leftLowerArm.To = Vector2.new(leftLowerArm_2d.X, leftLowerArm_2d.Y)

                    skel_leftHand.From = Vector2.new(leftLowerArm_2d.X, leftLowerArm_2d.Y)
                    skel_leftHand.To = Vector2.new(leftHand_2d.X, leftHand_2d.Y)

                    skel_rightUpperArm.From = Vector2.new(upperTorso_2d.X, upperTorso_2d.Y)
                    skel_rightUpperArm.To = Vector2.new(rightUpperArm_2d.X, rightUpperArm_2d.Y)

                    skel_rightLowerArm.From = Vector2.new(rightUpperArm_2d.X, rightUpperArm_2d.Y)
                    skel_rightLowerArm.To = Vector2.new(rightLowerArm_2d.X, rightLowerArm_2d.Y)

                    skel_rightHand.From = Vector2.new(rightLowerArm_2d.X, rightLowerArm_2d.Y)
                    skel_rightHand.To = Vector2.new(rightHand_2d.X, rightHand_2d.Y)

                    skel_leftUpperLeg.From = Vector2.new(lowerTorso_2d.X, lowerTorso_2d.Y)
                    skel_leftUpperLeg.To = Vector2.new(leftUpperLeg_2d.X, leftUpperLeg_2d.Y)

                    skel_leftLowerLeg.From = Vector2.new(leftUpperLeg_2d.X, leftUpperLeg_2d.Y)
                    skel_leftLowerLeg.To = Vector2.new(leftLowerLeg_2d.X, leftLowerLeg_2d.Y)

                    skel_leftFoot.From = Vector2.new(leftLowerLeg_2d.X, leftLowerLeg_2d.Y)
                    skel_leftFoot.To = Vector2.new(leftFoot_2d.X, leftFoot_2d.Y)

                    skel_rightUpperLeg.From = Vector2.new(lowerTorso_2d.X, lowerTorso_2d.Y)
                    skel_rightUpperLeg.To = Vector2.new(rightUpperLeg_2d.X, rightUpperLeg_2d.Y)

                    skel_rightLowerLeg.From = Vector2.new(rightUpperLeg_2d.X, rightUpperLeg_2d.Y)
                    skel_rightLowerLeg.To = Vector2.new(rightLowerLeg_2d.X, rightLowerLeg_2d.Y)

                    skel_rightFoot.From = Vector2.new(rightLowerLeg_2d.X, rightLowerLeg_2d.Y)
                    skel_rightFoot.To = Vector2.new(rightFoot_2d.X, rightFoot_2d.Y)

                    skel_head.Visible = _G.EspSkeleton
                    skel_upperTorso.Visible = _G.EspSkeleton
                    skel_lowerTorso.Visible = _G.EspSkeleton
                    skel_leftUpperArm.Visible = _G.EspSkeleton
                    skel_leftLowerArm.Visible = _G.EspSkeleton
                    skel_leftHand.Visible = _G.EspSkeleton
                    skel_rightUpperArm.Visible = _G.EspSkeleton
                    skel_rightLowerArm.Visible = _G.EspSkeleton
                    skel_rightHand.Visible = _G.EspSkeleton
                    skel_leftUpperLeg.Visible = _G.EspSkeleton
                    skel_leftLowerLeg.Visible = _G.EspSkeleton
                    skel_leftFoot.Visible = _G.EspSkeleton
                    skel_rightUpperLeg.Visible = _G.EspSkeleton
                    skel_rightLowerLeg.Visible = _G.EspSkeleton
                    skel_rightFoot.Visible = _G.EspSkeleton

                    skel_head.Color = _G.SkeletonColor
                    skel_upperTorso.Color = _G.SkeletonColor
                    skel_lowerTorso.Color = _G.SkeletonColor
                    skel_leftUpperArm.Color = _G.SkeletonColor
                    skel_leftLowerArm.Color = _G.SkeletonColor
                    skel_leftHand.Color = _G.SkeletonColor
                    skel_rightUpperArm.Color = _G.SkeletonColor
                    skel_rightLowerArm.Color = _G.SkeletonColor
                    skel_rightHand.Color = _G.SkeletonColor
                    skel_leftUpperLeg.Color = _G.SkeletonColor
                    skel_leftLowerLeg.Color = _G.SkeletonColor
                    skel_leftFoot.Color = _G.SkeletonColor
                    skel_rightUpperLeg.Color = _G.SkeletonColor
                    skel_rightLowerLeg.Color = _G.SkeletonColor
                    skel_rightFoot.Color = _G.SkeletonColor

                    skel_head.Transparency = _G.SkeletonTransparency
                    skel_upperTorso.Transparency = _G.SkeletonTransparency
                    skel_lowerTorso.Transparency = _G.SkeletonTransparency
                    skel_leftUpperArm.Transparency = _G.SkeletonTransparency
                    skel_leftLowerArm.Transparency = _G.SkeletonTransparency
                    skel_leftHand.Transparency = _G.SkeletonTransparency
                    skel_rightUpperArm.Transparency = _G.SkeletonTransparency
                    skel_rightLowerArm.Transparency = _G.SkeletonTransparency
                    skel_rightHand.Transparency = _G.SkeletonTransparency
                    skel_leftUpperLeg.Transparency = _G.SkeletonTransparency
                    skel_leftLowerLeg.Transparency = _G.SkeletonTransparency
                    skel_leftFoot.Transparency = _G.SkeletonTransparency
                    skel_rightUpperLeg.Transparency = _G.SkeletonTransparency
                    skel_rightLowerLeg.Transparency = _G.SkeletonTransparency
                    skel_rightFoot.Transparency = _G.SkeletonTransparency

                    skel_head.Thickness = _G.SkeletonThickness
                    skel_upperTorso.Thickness = _G.SkeletonThickness
                    skel_lowerTorso.Thickness = _G.SkeletonThickness
                    skel_leftUpperArm.Thickness = _G.SkeletonThickness
                    skel_leftLowerArm.Thickness = _G.SkeletonThickness
                    skel_leftHand.Thickness = _G.SkeletonThickness
                    skel_rightUpperArm.Thickness = _G.SkeletonThickness
                    skel_rightLowerArm.Thickness = _G.SkeletonThickness
                    skel_rightHand.Thickness = _G.SkeletonThickness
                    skel_leftUpperLeg.Thickness = _G.SkeletonThickness
                    skel_leftLowerLeg.Thickness = _G.SkeletonThickness
                    skel_leftFoot.Thickness = _G.SkeletonThickness
                    skel_rightUpperLeg.Thickness = _G.SkeletonThickness
                    skel_rightLowerLeg.Thickness = _G.SkeletonThickness
                    skel_rightFoot.Thickness = _G.SkeletonThickness
                else
                    skel_head.Visible = false
                    skel_upperTorso.Visible = false
                    skel_lowerTorso.Visible = false
                    skel_leftUpperArm.Visible = false
                    skel_leftLowerArm.Visible = false
                    skel_leftHand.Visible = false
                    skel_rightUpperArm.Visible = false
                    skel_rightLowerArm.Visible = false
                    skel_rightHand.Visible = false
                    skel_leftUpperLeg.Visible = false
                    skel_leftLowerLeg.Visible = false
                    skel_leftFoot.Visible = false
                    skel_rightUpperLeg.Visible = false
                    skel_rightLowerLeg.Visible = false
                    skel_rightFoot.Visible = false
                end
            else
                if player == nil then
                    connection:Disconnect()
                    connection = nil
                end

                skel_head.Visible = false
                skel_upperTorso.Visible = false
                skel_lowerTorso.Visible = false
                skel_leftUpperArm.Visible = false
                skel_leftLowerArm.Visible = false
                skel_leftHand.Visible = false
                skel_rightUpperArm.Visible = false
                skel_rightLowerArm.Visible = false
                skel_rightHand.Visible = false
                skel_leftUpperLeg.Visible = false
                skel_leftLowerLeg.Visible = false
                skel_leftFoot.Visible = false
                skel_rightUpperLeg.Visible = false
                skel_rightLowerLeg.Visible = false
                skel_rightFoot.Visible = false
            end
        end)
    end
    coroutine.wrap(update15)()
    return skel_head, skel_upperTorso, skel_lowerTorso, skel_leftUpperArm, skel_leftLowerArm, skel_leftHand, skel_rightUpperArm, skel_rightLowerArm, skel_rightHand, skel_leftUpperLeg, skel_leftLowerLeg, skel_leftFoot, skel_rightUpperLeg,skel_rightLowerLeg, skel_rightFoot
end

local function hideSkeleton(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        print("Humanoid not found in character: " .. character.Name)
        return
    end

    wait(0.025)

    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        local r6Parts = {
            skel_torso,
            skel_left_lower_arm,
            skel_right_lower_arm,
            skel_left_lower_leg,
            skel_right_lower_leg
        }

        for _, part in ipairs(r6Parts) do
            if part then
                part.Visible = false
            end
        end
    elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
        local r15Parts = {
            skel_upperTorso,
            skel_lowerTorso,
            skel_leftUpperArm,
            skel_leftLowerArm,
            skel_leftHand,
            skel_rightUpperArm,
            skel_rightLowerArm,
            skel_rightHand,
            skel_leftUpperLeg,
            skel_leftLowerLeg,
            skel_leftFoot,
            skel_rightUpperLeg,
            skel_rightLowerLeg,
            skel_rightFoot
        }

        for _, part in ipairs(r15Parts) do
            if part then
                part.Visible = false
            end
        end
    end
end

local function draw(player, character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        print("Humanoid not found in character: " .. character.Name)
        return
    end

    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        draw6(player, character)
    elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
        draw15(player, character)
    end

    humanoid.Died:Connect(function()
        print("Character died: " .. character.Name)
        wait(0.025)
        hideSkeleton(character)
    end)
end

local function clearLines(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        print("Humanoid not found in character: " .. character.Name)
        return
    end
    wait(0.025)
    hideSkeleton(character)
end

local function onCharacterAdded(player, character)
    print("Character added: " .. character.Name)
    wait(0.025)
    coroutine.wrap(draw)(player, character)
end

local function onCharacterRemoving(player)
    if player.Character then
        print("Character removing: " .. player.Character.Name)
        clearLines(player.Character)
    end
end

local function onPlayerAdded(player)
    print("Player added: " .. player.Name)
    if player.Character then
        wait(0.025)
        onCharacterAdded(player, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        wait(0.025)
        onCharacterAdded(player, character)
    end)
    player.CharacterRemoving:Connect(function()
        wait(0.025)
        onCharacterRemoving(player)
    end)
end

for _, player in pairs(game.Players:GetPlayers()) do
    wait(0.025)
    if player ~= LocalPlayer then
        onPlayerAdded(player)
    end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

_G.EspSkeleton = false
_G.SkeletonColor = Color3.new(1, 0, 0)
_G.SkeletonTransparency = 1
_G.SkeletonThickness = 1.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rayfield Example Window",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})

local Tab = Window:CreateTab("Tab Example", "rewind")

local Toggle = Tab:CreateToggle({
    Name = "Toggle Example",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.EspSkeleton = Value
    end,
})

local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.SkeletonColor = Value
    end
})

local Slider = Tab:CreateSlider({
    Name = "Slider Example",
    Range = {0, 3},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.SkeletonThickness = Value
    end,
})

local Slider = Tab:CreateSlider({
    Name = "Slider Example 2",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 1,
    Flag = "Slider12", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.SkeletonTransparency = Value
    end,
})
