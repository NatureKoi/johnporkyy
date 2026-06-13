local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local function TeleportBehindPlayer(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	
	local targetCharacter = targetPlayer.Character
	local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
	
	if not targetRoot then return end
	
	-- Get the target player's facing direction and position
	local targetCFrame = targetRoot.CFrame
	local behindDistance = 5 -- Distance behind the player
	
	-- Calculate position behind the player (opposite of their look direction)
	local behindPosition = targetCFrame * CFrame.new(0, 0, behindDistance)
	
	-- Teleport the local player behind the target
	HumanoidRootPart.CFrame = behindPosition
end

local function FindClosestPlayer()
	local players = Players:GetPlayers()
	local closestPlayer = nil
	local closestDistance = math.huge
	
	for _, player in ipairs(players) do
		if player ~= LocalPlayer and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (HumanoidRootPart.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestPlayer = player
				end
			end
		end
	end
	
	return closestPlayer
end

-- Right-click to teleport and force r-click on closest player
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		local closestPlayer = FindClosestPlayer()
		if closestPlayer and closestPlayer.Character then
			TeleportBehindPlayer(closestPlayer)
			
			-- Point mouse at closest player and simulate right-click
			local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				Mouse.Target = closestPlayer.Character
				Mouse.Hit = targetRoot.CFrame
				mouse1click()
			end
	end
end)
