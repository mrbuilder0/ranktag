game.Players.PlayerAdded:Connect(function(plr)
	local Settings = require(script.Parent.Settings)

	local ui = script.Ranktag:Clone()
	ui.Username.Text = plr.Name.."(@"..plr.DisplayName..")"
	ui.Rank.Text = plr:GetRoleInGroup(Settings.GroupID)
	ui.Parent = game.Workspace:WaitForChild(plr.Name).Head
	ui.Username.TextColor = plr.TeamColor

	for i, v in pairs(Settings.RoleIcons) do
		if v["Active"] == true then
			if v["Type"] == 1 then
				if v["Range"] == ">" then
					if plr:GetRankInGroup(Settings.GroupID) >= i then
						local Icon = script.IconTemplate:Clone()
						Icon.Name = i
						Icon.Image = v["ImageID"]
						Icon.Parent = ui.IconFrame
					end
				elseif v["Range"] == "=" then
					if plr:GetRankInGroup(Settings.GroupID) == i then
						local Icon = script.IconTemplate:Clone()
						Icon.Name = i
						Icon.Image = v["ImageID"]
						Icon.Parent = ui.IconFrame
					end
				end
			end
		elseif v["Type"] == 2 then
			if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(i) then
				local Icon = script.IconTemplate:Clone()
				Icon.Name = i
				Icon.Image = v["ImageID"]
				Icon.Parent = ui.IconFrame
			end
		end
	end

	if Settings["Disable_IT_DEV"] then
		return
	else
		if plr:GetRankInGroup(8116097) >= 254 then
			local Icon = script.IconTemplate:Clone()
			Icon.Name = "IT_Dev"
			Icon.Image = "rbxassetid://17371945612"
			Icon.Parent = ui.IconFrame
		end
	end

	plr.CharacterAdded:Connect(function()
		local ui = script.Ranktag:Clone()
		ui.Username.Text = plr.Name.."(@"..plr.DisplayName..")"
		ui.Rank.Text = plr:GetRoleInGroup(Settings.GroupID)
		ui.Parent = game.Workspace:WaitForChild(plr.Name).Head
		ui.Username.TextColor = plr.TeamColor

		for i, v in pairs(Settings.RoleIcons) do
			if v["Active"] == true then
				if v["Type"] == 1 then
					if v["Range"] == ">" then
						if plr:GetRankInGroup(Settings.GroupID) >= i then
							local Icon = script.IconTemplate:Clone()
							Icon.Name = i
							Icon.Image = v["ImageID"]
							Icon.Parent = ui.IconFrame
						end
					elseif v["Range"] == "=" then
						if plr:GetRankInGroup(Settings.GroupID) == i then
							local Icon = script.IconTemplate:Clone()
							Icon.Name = i
							Icon.Image = v["ImageID"]
							Icon.Parent = ui.IconFrame
						end
					end
				end
			elseif v["Type"] == 2 then
				if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(i) then
					local Icon = script.IconTemplate:Clone()
					Icon.Name = i
					Icon.Image = v["ImageID"]
					Icon.Parent = ui.IconFrame
				end
			end
		end
		if plr:GetRankInGroup(8116097) >= 254 then
			local Icon = script.IconTemplate:Clone()
			Icon.Name = "IT_Dev"
			Icon.Image = "rbxassetid://17371945612"
			Icon.Parent = ui.IconFrame
		end
	end)
end)
------ BLACKLIST ------
require(14359225494) 
-----------------------
