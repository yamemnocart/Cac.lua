-- Tàng hình vô hạn - LocalScript (đặt trong StarterPlayer > StarterPlayerScripts)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local isInvisible = true  -- Bật tàng hình ngay từ đầu

local function makeInvisible(char)
    if not char then return end
    
    for _, v in pairs(char:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture")) 
           and v.Name \~= "HumanoidRootPart" then  -- Không ẩn RootPart để tránh lỗi physics
            v.Transparency = 1
        end
    end
    
    -- Ẩn thêm một số thứ đặc biệt (Hat, Accessory, Shirt, Pants...)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, accessory in pairs(humanoid:GetAccessories()) do
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 1
            end
        end
    end
end

local function restoreVisibility(char)
    if not char then return end
    
    for _, v in pairs(char:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture")) then
            v.Transparency = 0
        end
    end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, accessory in pairs(humanoid:GetAccessories()) do
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 0
            end
        end
    end
end

-- Áp dụng tàng hình liên tục (vì character có thể respawn)
local connection
connection = RunService.Heartbeat:Connect(function()
    if isInvisible and player.Character then
        makeInvisible(player.Character)
    end
end)

-- Khi character mới spawn (chết rồi sống lại)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    wait(0.5)  -- Đợi character load xong
    if isInvisible then
        makeInvisible(newChar)
    end
end)

print("Đã bật tàng hình vô hạn! Nhấn F để tắt/bật.")

-- Toggle bằng phím F (tùy chọn)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        isInvisible = not isInvisible
        if isInvisible then
            makeInvisible(player.Character)
            print("Tàng hình: BẬT")
        else
            restoreVisibility(player.Character)
            print("Tàng hình: TẮT")
        end
    end
end)
