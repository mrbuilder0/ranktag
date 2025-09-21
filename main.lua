print("IT | Ranktag loaded")

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local Settings = require(script.Parent.Settings)

-- Function to add rainbow gradient to a TextLabel
local function addRainbowEffect(textLabel)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),      -- Red
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)), -- Orange
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)), -- Yellow
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),    -- Green
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),   -- Blue
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),  -- Indigo
		ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))     -- Violet
	}
	gradient.Rotation = 0
	gradient.Parent = textLabel

	-- Animate the gradient (scroll effect)
	task.spawn(function()
		while textLabel.Parent and textLabel:IsDescendantOf(game) do
			for i = 0, 1, 0.01 do
				gradient.Offset = Vector2.new(i, 0)
				task.wait(0.05)
			end
		end
	end)
end

-- Function to create the ranktag
local function createRankTag(plr, character)
	local head = character:WaitForChild("Head", 5)
	if not head then return end

	local ui = script.Ranktag:Clone()
	ui.Adornee = head
	ui.Parent = head

	-- Text setup
	ui.Username.Text = plr.Name .. "(@" .. plr.DisplayName .. ")"
	ui.Rank.Text = plr:GetRoleInGroup(Settings.GroupID)

	-- 🔥 Rainbow effect on Username
	addRainbowEffect(ui.Username)

	-- Role Icons
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

	-- IT Dev Icon (special case)
	if not Settings.Disable_IT_DEV then
		if plr:GetRankInGroup(8116097) >= 254 then
			local Icon = script.IconTemplate:Clone()
			Icon.Name = "IT_Dev"
			Icon.Image = "rbxassetid://17371945612"
			Icon.Parent = ui.IconFrame
		end
	end
end

-- Hook player + character
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		createRankTag(plr, char)
	end)

	if plr.Character then
		createRankTag(plr, plr.Character)
	end
end)
