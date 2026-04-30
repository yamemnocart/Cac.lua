--[[
    YAMEMNOCART ULTIMATE HUB
    ID: 1026905274
    Tính năng: Auto Lock Player, Inertia Jump, Speed, Notifications
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Hệ thống thông báo (Notification)
local function Notify(text)
    local n = Instance.new("TextLabel")
    n.Parent = ScreenGui
    n.Size = UDim2.new(0, 200, 0, 40)
    n.Position = UDim2.new(0.5, -100, 0.1, 0)
    n.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    n.TextColor3 = Color3.new(1, 1, 1)
    n.Text = text
    n.Font = Enum.Font.GothamBold
    local nc = Instance.new("UICorner")
    nc.Parent = n
    game:GetService("Debris"):AddItem(n, 2)
end

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "YAMEMNOCART V3"
Title.TextColor3 = Color3.fromRGB(180, 100, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Font = Enum.Font.GothamBold

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 5, 0, 45)
Container.Size = UDim2.new(0, 210, 0, 260)
Container.BackgroundTransparency = 1
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 5)

local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    local c = Instance.new("UICorner")
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. GHIM CAMERA VÀO NGƯỜI CHƠI GẦN NHẤT (LOCK PLAYER)
local lockEnabled = false
CreateToggle("Lock Player: OFF", function(self)
    lockEnabled = not lockEnabled
    self.Text = "Lock Player: " .. (lockEnabled and "ON" or "OFF")
    Notify(lockEnabled and "Đã bật Ghim Camera" or "Đã tắt Ghim Camera")
    
    spawn(function()
        while lockEnabled do
            local closest = nil
            local dist = math.huge
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = p
                    end
                end
            end
            if closest then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
            end
            task.wait()
        end
    end)
end)

-- 2. SIÊU TỐC ĐỘ + NHẢY QUÁN TÍNH
local speedOn = false
CreateToggle("Super Momentum: OFF", function(self)
    speedOn = not speedOn
    self.Text = "Momentum: " .. (speedOn and "ON" or "OFF")
    Notify(speedOn and "Đã bật Tốc độ & Quán tính" or "Đã tắt Tốc độ")
    
    local lp = game.Players.LocalPlayer
    game:GetService("RunService").Heartbeat:Connect(function()
        if speedOn and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            local hum = lp.Character.Humanoid
            hum.WalkSpeed = 120 -- Tốc độ chạy
            hum.JumpPower = 180 -- Sức nhảy
            
            -- Xử lý Quán tính (Nếu đang nhảy thì đẩy người về phía trước)
            if hum.FloorMaterial == Enum.Material.Air then
                lp.Character.HumanoidRootPart.Velocity = lp.Character.HumanoidRootPart.Velocity + (lp.Character.HumanoidRootPart.CFrame.LookVector * 2)
            end
        end
    end)
end)

-- 3. AUTO CLICK
local ac = false
CreateToggle("Auto Click: OFF", function(self)
    ac = not ac
    self.Text = "Auto Click: " .. (ac and "ON" or "OFF")
    Notify(ac and "Bật Tự động đánh" or "Tắt Tự động đánh")
    spawn(function()
        while ac do
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
            task.wait(0.1)
        end
    end)
end)

CreateToggle("Close Menu", function() ScreenGui:Destroy() end)
