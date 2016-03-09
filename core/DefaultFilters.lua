--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2014 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...

function addon:SetupDefaultFilters()
  -- Globals: GetEquipmentSetLocations
  --<GLOBALS
  local _G = _G
  local BANK_CONTAINER = _G.BANK_CONTAINER
  local BANK_CONTAINER_INVENTORY_OFFSET = _G.BANK_CONTAINER_INVENTORY_OFFSET
  local EquipmentManager_UnpackLocation = _G.EquipmentManager_UnpackLocation
  local format = _G.format
  local GetContainerItemQuestInfo = _G.GetContainerItemQuestInfo
  local GetEquipmentSetInfo = _G.GetEquipmentSetInfo
  local GetEquipmentSetItemIDs = _G.GetEquipmentSetItemIDs
  local GetNumEquipmentSets = _G.GetNumEquipmentSets
  local pairs = _G.pairs
  local wipe = _G.wipe
  --GLOBALS>

  local L, BI = addon.L, addon.BI

  -- Make some strings local to speed things
  local CONSUMMABLE = BI['Consumable']
  local GEM = BI['Gem']
  local GLYPH = BI['Glyph']
  local JUNK = BI['Junk']
  local MISCELLANEOUS = BI['Miscellaneous']
  local QUEST = BI['Quest']
  local RECIPE = BI['Recipe']
  local TRADE_GOODS = BI['Trade Goods']
  local WEAPON = BI["Weapon"]
  local ARMOR =  BI["Armor"]
  local JEWELRY = L["Jewelry"]
  local EQUIPMENT = L['Equipment']
  local AMMUNITION = L['Ammunition']

  -- Define global ordering
  self:SetCategoryOrders{
    [QUEST] = 30,
    [TRADE_GOODS] = 20,
    [EQUIPMENT] = 10,
    [CONSUMMABLE] = -10,
    [MISCELLANEOUS] = -20,
    [AMMUNITION] = -30,
    [JUNK] = -40,
  }

  -- [90] Parts of an equipment set
  do
    local setFilter = addon:RegisterFilter("ItemSets", 90, "ABEvent-1.0", "ABBucket-1.0")
    setFilter.uiName = L['Gear manager item sets']
    setFilter.uiDesc = L['Put items belonging to one or more sets of the built-in gear manager in specific sections.']

    function setFilter:OnInitialize()
      self.db = addon.db:RegisterNamespace('ItemSets', {
        profile = { oneSectionPerSet = true },
        char = { mergedSets = { ['*'] = false } },
      })
      self.names = {}
      self.slots = {}
    end

    function setFilter:OnEnable()
      self:RegisterEvent('EQUIPMENT_SETS_CHANGED')
      self:RegisterMessage("AdiBags_PreFilter")
      self:RegisterMessage("AdiBags_PreContentUpdate")
      self:UpdateNames()
    end

    local GetSlotId = addon.GetSlotId

    function setFilter:UpdateNames()
      self:Debug('Updating names')
      wipe(self.names)
      for i = 1, GetNumEquipmentSets() do
        local name = GetEquipmentSetInfo(i)
        self.names[name] = name
      end
      self.dirty = true
    end

    function setFilter:UpdateSlots()
      self:Debug('Updating slots')
      wipe(self.slots)
      local missing = false
      for i = 1, GetNumEquipmentSets() do
        local name = GetEquipmentSetInfo(i)
        local ids = GetEquipmentSetItemIDs(name)
        local locations = GetEquipmentSetLocations(name)
        if ids and locations then
          for invId, location in pairs(locations) do
            if location ~= 0 and location ~= 1 and ids[invId] ~= 0 then
              local player, bank, bags, voidstorage, slot, container  = EquipmentManager_UnpackLocation(location)
              local slotId
              if bags and slot and container then
                slotId = GetSlotId(container, slot)
              elseif bank and slot then
                slotId = GetSlotId(BANK_CONTAINER, slot - BANK_CONTAINER_INVENTORY_OFFSET)
              elseif not (player or voidstorage) or not slot then
                missing = true
              end
              if slotId and not self.slots[slotId] then
                self.slots[slotId] = name
              end
            end
          end
        else
          missing = true
        end
      end
      self.dirty = not missing
    end

    function setFilter:EQUIPMENT_SETS_CHANGED(event)
      self:UpdateNames()
      self:SendMessage('AdiBags_FiltersChanged', true)
    end

    function setFilter:AdiBags_PreContentUpdate(event)
      self.dirty = true
    end

    function setFilter:AdiBags_PreFilter(event)
      if self.dirty then
        self:UpdateSlots()
      end
    end

    local SETS, SET_NAME =  L['Sets'], L["Set: %s"]
    function setFilter:Filter(slotData)
      local name = self.slots[slotData.slotId]
      if name then
        if not self.db.profile.oneSectionPerSet or self.db.char.mergedSets[name] then
          return SETS, EQUIPMENT
        else
          return format(SET_NAME, name), EQUIPMENT
        end
      end
    end

    function setFilter:GetOptions()
      return {
        oneSectionPerSet = {
          name = L['One section per set'],
          desc = L['Check this to display one individual section per set. If this is disabled, there will be one big "Sets" section.'],
          type = 'toggle',
          order = 10,
        },
        mergedSets = {
          name = L['Merged sets'],
          desc = L['Check sets that should be merged into a unique "Sets" section. This is obviously a per-character setting.'],
          type = 'multiselect',
          order = 20,
          values = self.names,
          get = function(info, name)
            return self.db.char.mergedSets[name]
          end,
          set = function(info, name, value)
            self.db.char.mergedSets[name] = value
            self:SendMessage('AdiBags_FiltersChanged')
          end,
          disabled = function() return not self.db.profile.oneSectionPerSet end,
        },
      }, addon:GetOptionHandler(self, true)
    end

  end

  -- [85] Miscellaneous Items
  do
    local miscFilter = addon:RegisterFilter('Miscellaneous', 85)
    miscFilter.uiName = L['Miscellaneous']
    miscFilter.uiDesc = L['Section for some miscellaneous sections.']

    function miscFilter:OnInitialize(slotData)
      self.db = addon.db:RegisterNamespace('Miscellaneous', {
        profile = {
          miscellaneousCategories = {
            ['Teleport'] = true,
            ['Exchangeable'] = true,
            ['Chest & Openable'] = true,
          },
          factionCategories = {
            ['The Tillers'] = true,
          },
          mergeEventExchangeable = true,
          mergeEventChestOpenable = true,
        }
      })
    end

    function miscFilter:GetOptions()
      return {
        miscellaneousCategories = {
          name = L['Miscellaneous Categories'],
          desc = L['Select which first-level categories should be split by sub-categories.'],
          type = 'multiselect',
          order = 10,
          values = {
            ['Teleport'] = 'Teleport',
            ['Exchangeable'] = 'Exchangeable',
            ['Chest & Openable'] = 'Chest & Openable',
          }
        },

        factionCategories = {
          name = L['Faction Categories'],
          desc = L['Pets consumables aren\'t considered consumables, now they are a subcategory of pets items (like bandage or biscuit and battle stones)'],
          type = 'multiselect',
          order = 15,
          values = {
            ['The Tillers'] = 'The Tillers',
          }
        },

        mergeEventExchangeable = {
          name = L['Event exchangeable items'],
          desc = L['Consider event exchangeable items as "Exchangeable"'],
          type = 'toggle',
          width = 'double',
          order = 20,
        },

        mergeEventChestOpenable = {
          name = L['Event chest and openable items'],
          desc = L['Consider event chest and penable items as "Chest & Openable"'],
          type = 'toggle',
          width = 'double',
          order = 25,
        },
      }, addon:GetOptionHandler(self, true)
    end

    function miscFilter:Filter(slotData)
      if self.db.profile.miscellaneousCategories['Teleport'] and addon.MISC_TELEPORT_IDS[slotData.itemId] then
        return L['Misc: Teleport']
      end

      if self.db.profile.miscellaneousCategories['Exchangeable'] then
        if addon.MISC_EXCHANGEABLE[slotData.itemId] then
          return L['Misc: Exchangeable']
        elseif self.db.profile.mergeEventExchangeable and addon.MISC_EVENT_EXCHANGEABLE[slotData.itemId] then
          return L['Misc: Exchangeable']
        end
      end

      if self.db.profile.miscellaneousCategories['Chest & Openable'] then
        if addon.MISC_CHEST_OPENABLE[slotData.itemId] then
          return L['Misc: Chest & Openable']
        elseif self.db.profile.mergeEventChestOpenable and addon.MISC_EVENT_CHEST_OPENABLE[slotData.itemId] then
          return L['Misc: Chest & Openable']
        end
      end

      if self.db.profile.factionCategories['The Tillers'] and addon.MISC_THE_TILLERS[slotData.itemId] then
        return L['Misc: The Tillers']
      end
    end
  end

  -- [75] Quest Items
  function isEventItem(slotData)
    if addon.EVENT_LUNAR_FESTIVAL[slotData.itemId] then
      return true
    elseif addon.EVENT_LOVE_IS_IN_THE_AIR[slotData.itemId] then
      return true
    elseif addon.EVENT_NOBLEGARDEN[slotData.itemId] then
      return true
    elseif addon.EVENT_CHILDRENS_WEEK[slotData.itemId] then
      return true
    elseif addon.EVENT_MIDSUMMER[slotData.itemId] then
      return true
    elseif addon.EVENT_BREWFEST[slotData.itemId] then
      return true
    elseif addon.EVENT_HALLOWS_END[slotData.itemId] then
      return true
    elseif addon.EVENT_PILGRIMS_BOUNTY[slotData.itemId] then
      return true
    elseif addon.EVENT_WINTER_VEIL[slotData.itemId] then
      return true
    elseif addon.EVENT_ARGET_TOURNAMENT[slotData.itemId] then
      return true
    elseif addon.EVENT_DARKMOON_FAIRE[slotData.itemId] then
      return true
    elseif addon.EVENT_BRAWLERS_GUILD[slotData.itemId] then
      return true
    end
    return false
  end
  do
    local questItemFilter = addon:RegisterFilter('Quest', 70, function(self, slotData)
      if slotData.class == QUEST or slotData.subclass == QUEST then
        if isEventItem(slotData) then
          return L['Quest: Event & Seasonal']
        else
          return QUEST
        end
      else
        local isQuestItem, questId = GetContainerItemQuestInfo(slotData.bag, slotData.slot)
        if isEventItem(slotData) then
          return (questId or isQuestItem) and L['Quest: Event & Seasonal']
        else
          return (questId or isQuestItem) and QUEST
        end
      end
    end)
    questItemFilter.uiName = L['Quest Items']
    questItemFilter.uiDesc = L['Put quest-related items in their own section.']
  end

  -- [60] Equipment
  do
    local equipCategories = {
      INVTYPE_2HWEAPON = WEAPON,
      INVTYPE_AMMO = MISCELLANEOUS,
      INVTYPE_BAG = MISCELLANEOUS,
      INVTYPE_BODY = MISCELLANEOUS,
      INVTYPE_CHEST = ARMOR,
      INVTYPE_CLOAK = ARMOR,
      INVTYPE_FEET = ARMOR,
      INVTYPE_FINGER = JEWELRY,
      INVTYPE_HAND = ARMOR,
      INVTYPE_HEAD = ARMOR,
      INVTYPE_HOLDABLE = WEAPON,
      INVTYPE_LEGS = ARMOR,
      INVTYPE_NECK = JEWELRY,
      INVTYPE_QUIVER = MISCELLANEOUS,
      INVTYPE_RANGED = WEAPON,
      INVTYPE_RANGEDRIGHT = WEAPON,
      INVTYPE_RELIC = JEWELRY,
      INVTYPE_ROBE = ARMOR,
      INVTYPE_SHIELD = WEAPON,
      INVTYPE_SHOULDER = ARMOR,
      INVTYPE_TABARD = MISCELLANEOUS,
      INVTYPE_THROWN = WEAPON,
      INVTYPE_TRINKET = JEWELRY,
      INVTYPE_WAIST = ARMOR,
      INVTYPE_WEAPON = WEAPON,
      INVTYPE_WEAPONMAINHAND = WEAPON,
      INVTYPE_WEAPONMAINHAND_PET = WEAPON,
      INVTYPE_WEAPONOFFHAND = WEAPON,
      INVTYPE_WRIST = ARMOR,
    }

    local equipmentFilter = addon:RegisterFilter('Equipment', 60, function(self, slotData)
      local equipSlot = slotData.equipSlot
      if equipSlot and equipSlot ~= "" then
        local rule = self.db.profile.dispatchRule
        local category
        if rule == 'category' then
          category = equipCategories[equipSlot] or _G[equipSlot]
        elseif rule == 'slot' then
          category = _G[equipSlot]
        end
        if category == ARMOR and self.db.profile.armorTypes and slotData.subclass then
          category = slotData.subclass
        end
        return category or EQUIPMENT, EQUIPMENT
      end
    end)
    equipmentFilter.uiName = EQUIPMENT
    equipmentFilter.uiDesc = L['Put any item that can be equipped (including bags) into the "Equipment" section.']

    function equipmentFilter:OnInitialize()
      self.db = addon.db:RegisterNamespace('Equipment', { profile = { dispatchRule = 'category', armorTypes = false } })
    end

    function equipmentFilter:GetOptions()
      return {
        dispatchRule = {
          name = L['Section setup'],
          desc = L['Select the sections in which the items should be dispatched.'],
          type = 'select',
          width = 'double',
          order = 10,
          values = {
            one = L['Only one section.'],
            category = L['Four general sections.'],
            slot = L['One section per item slot.'],
          },
        },
        armorTypes = {
          name = L['Split armors by types'],
          desc = L['Check this so armors are dispatched in four sections by type.'],
          type = 'toggle',
          order = 20,
          disabled = function() return self.db.profile.dispatchRule ~= 'category' end,
        },
      }, addon:GetOptionHandler(self, true)
    end
  end

  -- [70] Event & Seasonal Items
  do
    local eventFilter = addon:RegisterFilter('Event', 75)
    eventFilter.uiName = L['Event']
    eventFilter.uiDesc = L['Put event and seasonal items in their own section.']

    function eventFilter:Filter(slotData)
      if addon.EVENT_LUNAR_FESTIVAL[slotData.itemId] then
        return L['Event: Lunar Festival']
      elseif addon.EVENT_LOVE_IS_IN_THE_AIR[slotData.itemId] then
        return L['Event: Love is in the air']
      elseif addon.EVENT_NOBLEGARDEN[slotData.itemId] then
        return L['Event: Noblegarden']
      elseif addon.EVENT_CHILDRENS_WEEK[slotData.itemId] then
        return L['Event: Childrens Week']
      elseif addon.EVENT_MIDSUMMER[slotData.itemId] then
        return L['Event: Midsummer']
      elseif addon.EVENT_BREWFEST[slotData.itemId] then
        return L['Event: Brewfest']
      elseif addon.EVENT_HALLOWS_END[slotData.itemId] then
        return L['Event: Hallows End']
      elseif addon.EVENT_PILGRIMS_BOUNTY[slotData.itemId] then
        return L['Event: Pilgrims Bounty']
      elseif addon.EVENT_WINTER_VEIL[slotData.itemId] then
        return L['Event: Winter Veil']
      elseif addon.EVENT_ARGET_TOURNAMENT[slotData.itemId] then
        return L['Event: Argente Tournament']
      elseif addon.EVENT_DARKMOON_FAIRE[slotData.itemId] then
        return L['Event: Darkmoon Faire']
      elseif addon.EVENT_BRAWLERS_GUILD[slotData.itemId] then
        return L['Event: Brawlers Guild']
      end
    end
  end

  -- [15] Garrison Items
  do
    local garrisonFilter = addon:RegisterFilter('Garrison', 15)
    garrisonFilter.uiName = L['Garrison']
    garrisonFilter.uiDesc = L['Put garrison related items in their own section.']

    function garrisonFilter:OnInitialize(slotData)
      self.db = addon.db:RegisterNamespace('Garrison', {
        profile = {
          mergeGarrisonFollowers = false,
          mergeGarrisonShipyard = false,
        }
      })
    end

    function garrisonFilter:GetOptions()
      return {
        mergeGarrisonFollowers = {
          name = L['Merge Followers Items'],
          desc = L['Pets consumables aren\'t considered consumables, now they are a subcategory of pets items (like bandage or biscuit and battle stones)'],
          type = 'toggle',
          width = 'double',
          order = 10,
        },
        mergeGarrisonShipyard = {
          name = L['Merge Shipyard Items'],
          desc = L['Create an own category for Battle-Stones (doesn\'t work if "Pets Consumable" isn\'t enabled)'],
          type = 'toggle',
          width = 'double',
          order = 20,
        },
      }, addon:GetOptionHandler(self, false, function() return self:Update() end)
    end

    function garrisonFilter:Filter(slotData)
      local isGarrison = addon.GARRISON_IDS[slotData.itemId]
      local isGarrisonFollower = addon.GARRISON_FOLLOWERS_IDS[slotData.itemId]
      local isGarrisonShipyard = addon.GARRISON_SHIPYARD_IDS[slotData.itemId]

      if isGarrisonFollower then
        if self.db.profile.mergeGarrisonFollowers then
          return L['Garrison']
        else
          return L['Garrison: Followers']
        end
      end

      if isGarrisonShipyard then
        if self.db.profile.isGarrisonShipyard then
          return L['Garrison']
        else
          return L['Garrison: Shipyard']
        end
      end

      if isGarrison then
        return L['Garrison']
      end
    end
  end

  -- [10] Pets Items
  do
    local petsFilter = addon:RegisterFilter('Pets', 10)
    petsFilter.uiName = L['Pets']
    petsFilter.uiDesc = L['Put pet-related items in their own section.']

    function petsFilter:OnInitialize(slotData)
      self.db = addon.db:RegisterNamespace('Pets', {
        profile = {
          mergePetsMiscellaneous = true,
          mergePetsBattleStones = true,
        }
      })
    end

    function petsFilter:GetOptions()
      return {
        mergePetsMiscellaneous = {
          name = L['Pets Consumables'],
          desc = L['Pets consumables aren\'t considered consumables, now they are a subcategory of pets items (like bandage or biscuit and battle stones)'],
          type = 'toggle',
          width = 'double',
          order = 10,
        },
        mergePetsBattleStones = {
          name = L['Battle-Stones'],
          desc = L['Create an own category for Battle-Stones (doesn\'t work if "Pets Consumable" isn\'t enabled)'],
          type = 'toggle',
          width = 'double',
          order = 20,
        },
      }, addon:GetOptionHandler(self, false, function() return self:Update() end)
    end

    function petsFilter:Filter(slotData)
      local class, subclass = slotData.class, slotData.subclass

      if slotData.itemId == 82800 then -- Official item (Pet Cage)
        return L['Pets']
      end

      if class == MISCELLANEOUS and subclass == L['Companion Pets'] then
        return L['Pets: Unused']
      end

      if self.db.profile.mergePetsMiscellaneous then
        local isBattleStone = addon.PETS_BATTLE_STONES_IDS[slotData.itemId]
        local isPetMiscellaneous = addon.PETS_MISCELLANEOUS_IDS[slotData.itemId]
        if self.db.profile.mergePetsBattleStones and isBattleStone then
          return L['Pets: Battle-Stone']
        elseif isPetMiscellaneous or isBattleStone then
          return L['Pets: Miscellaneous']
        end
      end
    end
  end

  -- [5] Item classes
  do
    local itemCat = addon:RegisterFilter('ItemCategory', 5)
    itemCat.uiName = L['Item category']
    itemCat.uiDesc = L['Put items in sections depending on their first-level category at the Auction House.']
      ..'\n|cffff7700'..L['Please note this filter matchs every item. Any filter with lower priority than this one will have no effect.']..'|r'

    function itemCat:OnInitialize(slotData)
      self.db = addon.db:RegisterNamespace(self.moduleName, {
        profile = {
          splitBySubclass = { false },
          mergeGems = true,
          mergeGlyphs = true,
        }
      })
    end

    function itemCat:GetOptions()
      return {
        splitBySubclass = {
          name = L['Split by subcategories'],
          desc = L['Select which first-level categories should be split by sub-categories.'],
          type = 'multiselect',
          order = 10,
          values = {
            [TRADE_GOODS] = TRADE_GOODS,
            [CONSUMMABLE] = CONSUMMABLE,
            [MISCELLANEOUS] = MISCELLANEOUS,
            [GEM] = GEM,
            [GLYPH] = GLYPH,
            [RECIPE] = RECIPE,
          }
        },
        mergeGems = {
          name = L['Gems are trade goods'],
          desc = L['Consider gems as a subcategory of trade goods'],
          type = 'toggle',
          width = 'double',
          order = 20,
        },
        mergeGlyphs = {
          name = L['Glyphs are trade goods'],
          desc = L['Consider glyphs as a subcategory of trade goods'],
          type = 'toggle',
          width = 'double',
          order = 30,
        },
      }, addon:GetOptionHandler(self, true)
    end

    function itemCat:Filter(slotData)
      local class, subclass = slotData.class, slotData.subclass
      if class == GEM and self.db.profile.mergeGems then
        class, subclass = TRADE_GOODS, class
      elseif class == GLYPH and self.db.profile.mergeGlyphs then
        class, subclass = TRADE_GOODS, class
      end
      if self.db.profile.splitBySubclass[class] then
        return subclass, class
      else
        return class
      end
    end

  end
end