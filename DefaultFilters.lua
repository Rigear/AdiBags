--[[
AdiBags - Adirelle's bag addon.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local addonName, addon = ...
local L = addon.L

function addon:SetupDefaultFilters()

	-- [100] Parts of an equipment set
	addon:RegisterFilter{
		name = "ItemSets",
		priority = 100,
		sets = {},
		updateOnEvent = "EQUIPMENT_SETS_CHANGED",
		PreFilter = function(self)
			wipe(self.sets)
			for i = 1, GetNumEquipmentSets() do
				local name = GetEquipmentSetInfo(i)
				local section = L["Set: %s"]:format(name)
				local items = GetEquipmentSetItemIDs(name)
				for loc, id in pairs(items) do
					if id and not self.sets[id] then
						self.sets[id] = section
					end
				end
			end
		end,
		Filter = function(self, bag, slot, itemId, link)
			return self.sets[itemId]
		end,
	}

	-- [90] Ammo and shards
	addon:RegisterFilter('AmmoShards', 90, function(self, bag, slot, itemId, link) -- L["AmmoShards"]
		if itemId == 6265 then -- Soul Shard
			return L['Soul shards'], true
		elseif select(9, GetItemInfo(itemId)) == 'INVTYPE_AMMO' then
			return L['Ammunition'], true
		end
	end)

	-- [80] Low quality items
	do
		local lowQualityPattern = string.format('%s|Hitem:%%d+:0:0:0:0', ITEM_QUALITY_COLORS[ITEM_QUALITY_POOR].hex)
		addon:RegisterFilter('Junk', 80, function(self, bag, slot, itemId, link) -- L["Junk"]
			return link:match(lowQualityPattern) and L['Junk']
		end)
	end

	-- [70] Equipment	
	addon:RegisterFilter('Equipment', 70, function(self, bag, slot, itemId, link) -- L["Equipement"]
		local invType = select(9, GetItemInfo(itemId))
		if invType and invType ~= "" then
			return L['Equipment']
		end
	end)
	
	-- [60] Item classes	
	addon:RegisterFilter('ItemCategory', 70, function(self, bag, slot, itemId, link) --L["ItemCategory"]
		local cat = select(6, GetItemInfo(itemId))
		if cat == L["Gem"] then
			return L["Trade Goods"]
		else
			return cat
		end
	end)

end
