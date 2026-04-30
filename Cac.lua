--[[
    YAMEMNOCART PREMIUM MENU - UPDATED
    Tính năng mới: Lock Camera, Speed, Jump
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "YamemnocartHub"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "YAMEMNOCART V2"
Title.TextColor3 = Color3.fromRGB(190, 130, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 5, 0, 50)
Container.Size = UDim2.new(0, 210, 0, 240)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 8)

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. LOCK CAMERA (Ghim camera khi bật Shiftlock)
local camLock = false
CreateButton("Lock Camera: OFF", function(self)
    camLock = not camLock
    self.Text = "Lock Camera: " .. (camLock and "ON" or "OFF")
    local RunService = game:GetService("RunService")
    local cam = workspace.CurrentCamera
    local player = game.Players.LocalPlayer
    
    RunService:BindToRenderStep("CameraLock", Enum.RenderPriority.Camera.Value + 1, function()
        if camLock and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Tự động xoay người theo hướng Camera (Giống Shiftlock)
            local root = player.Character.HumanoidRootPart
            root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z))
        else
            RunService:UnbindFromRenderStep("CameraLock")
        end
    end)
end)

-- 2. SUPER SPEED (Tốc độ chạy siêu nhanh)
local speedLevel = 16
CreateButton("Super Speed: 100", function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 100 -- Bạn có thể chỉnh con số này cao hơn nếu muốn
    end
end)

-- 3. SUPER JUMP (Nhảy siêu cao)
CreateButton("Super Jump: 150", function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = 150
        hum.UseJumpPower = true
    end
end)

-- 4. AUTO CLICK (Hỗ trợ đánh quái)
_G.AutoClick = false
CreateButton("Auto Click: OFF", function(self)
    _G.AutoClick = not _G.AutoClick
    self.Text = "Auto Click: " .. (_G.AutoClick and "ON" or "OFF")
    spawn(function()
        while _G.AutoClick do
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
            task.wait(0.1)
        end
    end)
end)

-- 5. RESET (Trở về bình thường)
CreateButton("Reset Stats", function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        camLock = false
    end
end)

CreateButton("Đóng Menu (X)", function() ScreenGui:Destroy() end)
