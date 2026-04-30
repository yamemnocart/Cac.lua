local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local mainBtn = Instance.new("TextButton", ScreenGui)
mainBtn.Size = UDim2.new(0,100,0,40)
mainBtn.Position = UDim2.new(0,20,0,200)
mainBtn.Text = "MENU"
mainBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0,200,0,250)
frame.Position = UDim2.new(0,20,0,250)
frame.Visible = false
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Camera Lock"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

local list = Instance.new("ScrollingFrame", frame)
list.Size = UDim2.new(1,0,1,-30)
list.Position = UDim2.new(0,0,0,30)
list.CanvasSize = UDim2.new(0,0,0,0)

local selectedPlayer = nil

-- Toggle menu
mainBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Create player buttons
local function refreshList()
    list:ClearAllChildren()
    local y = 0

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", list)
            btn.Size = UDim2.new(1,0,0,30)
            btn.Position = UDim2.new(0,0,0,y)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
            end)

            y = y + 30
        end
    end

    list.CanvasSize = UDim2.new(0,0,0,y)
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

-- Lock button
local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size = UDim2.new(1,0,0,30)
lockBtn.Position = UDim2.new(0,0,1,-60)
lockBtn.Text = "Lock Cam"
lockBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)

lockBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local hum = selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            camera.CameraSubject = hum
            camera.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- Unlock button
local unlockBtn = Instance.new("TextButton", frame)
unlockBtn.Size = UDim2.new(1,0,0,30)
unlockBtn.Position = UDim2.new(0,0,1,-30)
unlockBtn.Text = "Unlock"
unlockBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)

unlockBtn.MouseButton1Click:Connect(function()
    if player.Character then
        camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
    end
end)
