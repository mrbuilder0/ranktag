local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local Settings = require(script.Parent.Settings)

-- Function to add rainbow gradient to a TextLabel
local function addRainbowEffect(textLabel)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),      -- Red
		ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 127, 0)), -- Orange
		ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 255, 0)), -- Yellow
		ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0, 255, 0)),   -- Green
		ColorSequenceKeypoint.new(0.57, Color3.fromRGB(0, 0, 255)),   -- Blue
		ColorSequenceKeypoint.new(0.71, Color3.fromRGB(75, 0, 130)),  -- Indigo
		ColorSequenceKeypoint.new(0.85, Color3.fromRGB(148, 0, 211)), -- Violet
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 127, 0))       -- Red-Orange
	}
	gradient.Rotation = 0
	gradient.Offset = Vector2.new(-1, 0)
	gradient.Parent = textLabel


	task.spawn(function()
		while textLabel.Parent and textLabel:IsDescendantOf(game) do
			local tween = TweenService:Create(
				gradient,
				TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false),
				{ Offset = Vector2.new(1, 0) }
			)
			tween:Play()
			tween.Completed:Wait()
			gradient.Offset = Vector2.new(-1, 0)
		end
	end)
end


local function createRankTag(plr, character)
	local head = character:WaitForChild("Head", 5)
	if not head then return end

	local ui = script.Ranktag:Clone()
	ui.Adornee = head
	ui.Parent = head


	ui.Username.Text = plr.Name .. "(@" .. plr.DisplayName .. ")"
	ui.Rank.Text = plr:GetRoleInGroup(Settings.GroupID)


	if Settings["RainbowGamepassFunction"]["Active"] == true then
		if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(plr.UserId,Settings["RainbowGamepassFunction"]["GamepassID"]) then
			addRainbowEffect(ui.Username)
		end
	end

	for i, v in pairs(Settings.RoleIcons) do
		if v.Active then
			if v.Type == 1 then
				if (v.Range == ">" and plr:GetRankInGroup(Settings.GroupID) >= i)
					or (v.Range == "=" and plr:GetRankInGroup(Settings.GroupID) == i) then
					local Icon = script.IconTemplate:Clone()
					Icon.Name = tostring(i)
					Icon.Image = v.ImageID
					Icon.Parent = ui.IconFrame
				end
			elseif v.Type == 2 then
				task.spawn(function()
					local success, owns = pcall(function()
						return MarketplaceService:UserOwnsGamePassAsync(plr.UserId, i)
					end)
					if success and owns then
						local Icon = script.IconTemplate:Clone()
						Icon.Name = tostring(i)
						Icon.Image = v.ImageID
						Icon.Parent = ui.IconFrame
					end
				end)
			end
		end
	end


	if not Settings.Disable_IT_DEV then
		if plr:GetRankInGroup(13074666) >= 1 then
			local Icon = script.IconTemplate:Clone()
			Icon.Name = "IT_Dev"
			Icon.Image = "rbxassetid://17371945612"
			Icon.Parent = ui.IconFrame
		end
	end
	game.Workspace:FindFirstChild(plr.Name).Name = " "
end

for i, plr in pairs(game.Players:GetChildren()) do
	createRankTag(plr, plr.Character)
end


Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		createRankTag(plr, char)
	end)

	if plr.Character then
		createRankTag(plr, plr.Character)
	end
end)
