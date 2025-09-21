local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local Settings = require(script.Parent.Settings)

-- Function to create the ranktag
local function createRankTag(plr, character)
	local head = character:WaitForChild("Head", 5) -- wait up to 5 seconds for head
	if not head then return end -- fail-safe

	local ui = script.Ranktag:Clone()
	ui.Adornee = head -- ensure BillboardGui is attached to head
	ui.Parent = head

	-- Text setup
	ui.Username.Text = plr.Name .. "(@" .. plr.DisplayName .. ")"
	ui.Rank.Text = plr:GetRoleInGroup(Settings.GroupID)
	ui.Username.TextColor3 = plr.TeamColor.Color -- .TextColor is deprecated, use .TextColor3

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
				-- check GamePass ownership safely
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

	-- If character already exists (when joining mid-game)
	if plr.Character then
		createRankTag(plr, plr.Character)
	end
end)
