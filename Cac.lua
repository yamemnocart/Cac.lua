local player = game.Players.LocalPlayer
local character = player.Character
local root = character:WaitForChild("HumanoidRootPart")

character.Parent = nil
root.Anchored = true
task.wait(0.1)
character.Parent = game.Workspace
root.Anchored = false
