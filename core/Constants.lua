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
local L = addon.L

--<GLOBALS
local _G = _G
local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS
local pairs = _G.pairs
--GLOBALS>

-- Backpack and bags
local BAGS = { [BACKPACK_CONTAINER] = BACKPACK_CONTAINER }
for i = 1, NUM_BAG_SLOTS do BAGS[i] = i end

-- Base nank bags
local BANK_ONLY = { [BANK_CONTAINER] = BANK_CONTAINER }
for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do BANK_ONLY[i] = i end

--- Reagent bank bags
local REAGENTBANK_ONLY = { [REAGENTBANK_CONTAINER] = REAGENTBANK_CONTAINER }

-- All bank bags
local BANK = {}
for _, bags in ipairs { BANK_ONLY, REAGENTBANK_ONLY } do
  for id in pairs(bags) do BANK[id] = id end
end

-- All bags
local ALL = {}
for _, bags in ipairs { BAGS, BANK } do
  for id in pairs(bags) do ALL[id] = id end
end

addon.BAG_IDS = {
  BAGS = BAGS,
  BANK = BANK,
  BANK_ONLY = BANK_ONLY,
  REAGENTBANK_ONLY = REAGENTBANK_ONLY,
  ALL = ALL
}

addon.FAMILY_TAGS = {
--@noloc[[
  [0x00001] = L["QUIVER_TAG"], -- Quiver
  [0x00002] = L["AMMO_TAG"], -- Ammo Pouch
  [0x00004] = L["SOUL_BAG_TAG"], -- Soul Bag
  [0x00008] = L["LEATHERWORKING_BAG_TAG"], -- Leatherworking Bag
  [0x00010] = L["INSCRIPTION_BAG_TAG"], -- Inscription Bag
  [0x00020] = L["HERB_BAG_TAG"], -- Herb Bag
  [0x00040] = L["ENCHANTING_BAG_TAG"] , -- Enchanting Bag
  [0x00080] = L["ENGINEERING_BAG_TAG"], -- Engineering Bag
  [0x00100] = L["KEYRING_TAG"], -- Keyring
  [0x00200] = L["GEM_BAG_TAG"], -- Gem Bag
  [0x00400] = L["MINING_BAG_TAG"], -- Mining Bag
  [0x08000] = L["TACKLE_BOX_TAG"], -- Tackle Box
  [0x10000] = L["COOKING_BAR_TAG"], -- Refrigerator
--@noloc]]
}

addon.FAMILY_ICONS = {
  [0x00001] = [[Interface\Icons\INV_Misc_Ammo_Arrow_01]], -- Quiver
  [0x00002] = [[Interface\Icons\INV_Misc_Ammo_Bullet_05]], -- Ammo Pouch
  [0x00004] = [[Interface\Icons\INV_Misc_Gem_Amethyst_02]], -- Soul Bag
  [0x00008] = [[Interface\Icons\Trade_LeatherWorking]], -- Leatherworking Bag
  [0x00010] = [[Interface\Icons\INV_Inscription_Tradeskill01]], -- Inscription Bag
  [0x00020] = [[Interface\Icons\Trade_Herbalism]], -- Herb Bag
  [0x00040] = [[Interface\Icons\Trade_Engraving]], -- Enchanting Bag
  [0x00080] = [[Interface\Icons\Trade_Engineering]], -- Engineering Bag
  [0x00100] = [[Interface\Icons\INV_Misc_Key_14]], -- Keyring
  [0x00200] = [[Interface\Icons\INV_Misc_Gem_BloodGem_01]], -- Gem Bag
  [0x00400] = [[Interface\Icons\Trade_Mining]], -- Mining Bag
  [0x08000] = [[Interface\Icons\Trade_Fishing]], -- Tackle Box
  [0x10000] = [[Interface\Icons\INV_Misc_Bag_Cooking]], -- Refrigerator
}

addon.ITEM_SIZE = 37
addon.ITEM_SPACING = 4
addon.SECTION_SPACING = addon.ITEM_SIZE / 3 + addon.ITEM_SPACING
addon.BAG_INSET = 8
addon.TOP_PADDING = 32
addon.HEADER_SIZE = 14 + addon.ITEM_SPACING

addon.BACKDROP = {
  bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
  edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
  tile = false,
  edgeSize = 16,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

addon.DEFAULT_SETTINGS = {
  profile = {
    enabled = true,
    bags = {
      ["*"] = true,
    },
    positionMode = "anchored",
    positions = {
      anchor = { point = "BOTTOMRIGHT", xOffset = -32, yOffset = 200 },
      Backpack = { point = "BOTTOMRIGHT", xOffset = -32, yOffset = 200 },
      Bank = { point = "TOPLEFT", xOffset = 32, yOffset = -104 },
    },
    scale = 0.9,
    columnWidth = {
      Backpack = 4,
      Bank = 6,
    },
    maxHeight = 0.80,
    qualityHighlight = true,
    qualityOpacity = 1.0,
    dimJunk = true,
    questIndicator = true,
    showBagType = true,
    filters = { ['*'] = true },
    filterPriorities = {},
    sortingOrder = 'default',
    modules = { ['*'] = true },
    virtualStacks = {
      ['*'] = false,
      freeSpace = true,
      notWhenTrading = 1,
    },
    skin = {
      background = "Blizzard Tabard Background",
      border = "Blizzard Tooltip",
      borderWidth = 16,
      insets = 3,
      BackpackColor = { 1, 1, 1, 0.95 },
      BankColor = { 0, 0, 1, 0.95 },
      ReagentBankColor = { 0, 1, 0, 0.95 },
    },
    rightClickConfig = true,
    autoOpen = true,
    hideAnchor = false,
    autoDeposit = false,
    compactLayout = false,
  },
  char = {
    collapsedSections = {
      ['*'] = false,
    },
  },
  global = {
    muteBugGrabber = false,
  },
}

--[[
Se possivel é preciso separar estes dados em um arquivo separado
--]]

  --[[ Modelo
  -- 
  [] = true, -- 
  [] = true, -- 
  [] = true, -- 
  [] = true, -- 
  [] = true, -- 
  --]]

addon.GARRISON_IDS = {
  [116395] = true, -- Comprehensive Outpost Construction Guide
  [116394] = true, -- Outpost Building Assembly Notes

  ------- Work Orders
  [114119] = true, -- Crate of Salvage
  [114116] = true, -- Bag of Salvaged Goods
  [114120] = true, -- Big Crate of Salvage
  [114781] = true, -- Timber
  [116053] = true, -- Draenic Seeds
  [115508] = true, -- Draenic Stone
  [113991] = true, -- Iron Trap
  [115009] = true, -- Improved Iron Trap
  [115010] = true, -- Deadly Iron Trap
  [119813] = true, -- Furry Caged Beast
  [119814] = true, -- Leathery Caged Beast
  [119810] = true, -- Meaty Caged Beast
  [119819] = true, -- Caged Mighty Clefthoof
  [119817] = true, -- Caged Mighty Riverbeast
  [119815] = true, -- Caged Mighty Wolf
  [117397] = true, -- Nat's Lucky Coin
  [118043] = true, -- Broken Bones
  [128373] = true, -- Rush Order: Shipyard
  [122307] = true, -- Rush Order: Barn
  [122487] = true, -- Rush Order: Gladiator's Sanctum
  [122490] = true, -- Rush Order: Dwarven Bunker
  [122491] = true, -- Rush Order: War Mill
  [122496] = true, -- Rush Order: Garden Shipment
  [122497] = true, -- Rush Order: Garden Shipment
  [122500] = true, -- Rush Order: Gnomish Gearworks
  [122501] = true, -- Rush Order: Goblin Workshop
  [122502] = true, -- Rush Order: Mine Shipment
  [122503] = true, -- Rush Order: Mine Shipment
  [122576] = true, -- Rush Order: Alchemy Lab
  [122590] = true, -- Rush Order: Enchanter's Study
  [122591] = true, -- Rush Order: Engineering Works
  [122592] = true, -- Rush Order: Gem Boutique
  [122593] = true, -- Rush Order: Scribe's Quarters
  [122594] = true, -- Rush Order: Tailoring Emporium
  [122595] = true, -- Rush Order: The Forge
  [122596] = true, -- Rush Order: The Tannery

  ------- Iron Horde (War Mill)
  [113681] = true, -- Iron Horde Scraps
  [113823] = true, -- Crusted Iron Horde Pauldrons
  [113822] = true, -- Ravaged Iron Horde Belt
  [113821] = true, -- Battered Iron Horde Helmet

  ------- Mining Consumables
  [118897] = true, -- Miner's Coffee
  [118903] = true, -- Preserved Mining Pick

  ------- Blueprints
  [118215] = true, -- Book of Garrison Blueprints
  [111812] = true, -- Garrison Blueprint: Alchemy Lab, Level 1
  [111929] = true, -- Garrison Blueprint: Alchemy Lab, Level 2
  [111930] = true, -- Garrison Blueprint: Alchemy Lab, Level 3
  [111968] = true, -- Garrison Blueprint: Barn, Level 2
  [111969] = true, -- Garrison Blueprint: Barn, Level 3
  [111956] = true, -- Garrison Blueprint: Barracks, Level 1
  [111970] = true, -- Garrison Blueprint: Barracks, Level 2
  [111971] = true, -- Garrison Blueprint: Barracks, Level 3
  [111966] = true, -- Garrison Blueprint: Dwarven Bunker, Level 2
  [111967] = true, -- Garrison Blueprint: Dwarven Bunker, Level 3
  [111817] = true, -- Garrison Blueprint: Enchanter's Study, Level 1
  [111972] = true, -- Garrison Blueprint: Enchanter's Study, Level 2
  [111973] = true, -- Garrison Blueprint: Enchanter's Study, Level 3
  [109258] = true, -- Garrison Blueprint: Engineering Works, Level 1
  [109256] = true, -- Garrison Blueprint: Engineering Works, Level 2
  [109257] = true, -- Garrison Blueprint: Engineering Works, Level 3
  [109578] = true, -- Garrison Blueprint: Fishing Shack
  [111927] = true, -- Garrison Blueprint: Fishing Shack, Level 2
  [111928] = true, -- Garrison Blueprint: Fishing Shack, Level 3
  [116248] = true, -- Garrison Blueprint: Frostwall Mines, Level 2
  [116249] = true, -- Garrison Blueprint: Frostwall Mines, Level 3
  [116431] = true, -- Garrison Blueprint: Frostwall Tavern, Level 2
  [116432] = true, -- Garrison Blueprint: Frostwall Tavern, Level 3
  [111814] = true, -- Garrison Blueprint: Gem Boutique, Level 1
  [111974] = true, -- Garrison Blueprint: Gem Boutique, Level 2
  [111975] = true, -- Garrison Blueprint: Gem Boutique, Level 3
  [111980] = true, -- Garrison Blueprint: Gladiator's Sanctum, Level 2
  [111981] = true, -- Garrison Blueprint: Gladiator's Sanctum, Level 3
  [111984] = true, -- Garrison Blueprint: Gnomish Gearworks, Level 2
  [111985] = true, -- Garrison Blueprint: Gnomish Gearworks, Level 3
  [116200] = true, -- Garrison Blueprint: Goblin Workshop, Level 2
  [116201] = true, -- Garrison Blueprint: Goblin Workshop, Level 3
  [109577] = true, -- Garrison Blueprint: Herb Garden, Level 2
  [111997] = true, -- Garrison Blueprint: Herb Garden, Level 3
  [109254] = true, -- Garrison Blueprint: Lumber Mill, Level 2
  [109255] = true, -- Garrison Blueprint: Lumber Mill, Level 3
  [109576] = true, -- Garrison Blueprint: Lunarfall Excavation, Level 2
  [111996] = true, -- Garrison Blueprint: Lunarfall Excavation, Level 3
  [107694] = true, -- Garrison Blueprint: Lunarfall Inn, Level 2
  [109065] = true, -- Garrison Blueprint: Lunarfall Inn, Level 3
  [109062] = true, -- Garrison Blueprint: Mage Tower, Level 2
  [109063] = true, -- Garrison Blueprint: Mage Tower, Level 3
  [111998] = true, -- Garrison Blueprint: Menagerie, Level 2
  [111999] = true, -- Garrison Blueprint: Menagerie, Level 3
  [111957] = true, -- Garrison Blueprint: Salvage Yard, Level 1
  [111976] = true, -- Garrison Blueprint: Salvage Yard, Level 2
  [111977] = true, -- Garrison Blueprint: Salvage Yard, Level 3
  [111815] = true, -- Garrison Blueprint: Scribe's Quarters, Level 1
  [111978] = true, -- Garrison Blueprint: Scribe's Quarters, Level 2
  [111979] = true, -- Garrison Blueprint: Scribe's Quarters, Level 3
  [116196] = true, -- Garrison Blueprint: Spirit Lodge, Level 2
  [116197] = true, -- Garrison Blueprint: Spirit Lodge, Level 3
  [112002] = true, -- Garrison Blueprint: Stables, Level 2
  [112003] = true, -- Garrison Blueprint: Stables, Level 3
  [111982] = true, -- Garrison Blueprint: Storehouse, Level 2
  [111983] = true, -- Garrison Blueprint: Storehouse, Level 3
  [111816] = true, -- Garrison Blueprint: Tailoring Emporium, Level 1
  [111992] = true, -- Garrison Blueprint: Tailoring Emporium, Level 2
  [111993] = true, -- Garrison Blueprint: Tailoring Emporium, Level 3
  [111813] = true, -- Garrison Blueprint: The Forge, Level 1
  [111990] = true, -- Garrison Blueprint: The Forge, Level 2
  [111991] = true, -- Garrison Blueprint: The Forge, Level 3
  [111818] = true, -- Garrison Blueprint: The Tannery, Level 1
  [111988] = true, -- Garrison Blueprint: The Tannery, Level 2
  [111989] = true, -- Garrison Blueprint: The Tannery, Level 3
  [111986] = true, -- Garrison Blueprint: Trading Post, Level 2
  [111987] = true, -- Garrison Blueprint: Trading Post, Level 3
  [116185] = true, -- Garrison Blueprint: War Mill, Level 2
  [116186] = true, -- Garrison Blueprint: War Mill, Level 3
  [127267] = true, -- Ship Blueprint: Carrier
  [127268] = true, -- Ship Blueprint: Transport
  [127269] = true, -- Ship Blueprint: Battleship (horde)
  [127270] = true, -- Ship Blueprint: Submarine
  [127268] = true, -- Ship Blueprint: Transport
  [126900] = true, -- Ship Blueprint: Destroyer
  [128492] = true, -- Ship Blueprint: Battleship (alliance)
  ------- Blueprints dropped by rare mobs in Tanaan Jungle
  [126950] = true, -- Equipment Blueprint: Bilge Pump
  [128258] = true, -- Equipment Blueprint: Felsmoke Launchers
  [128232] = true, -- Equipment Blueprint: High Intensity Fog Lights
  [128255] = true, -- Equipment Blueprint: Ice Cutter
  [128231] = true, -- Equipment Blueprint: Trained Shark Tank
  [128252] = true, -- Equipment Blueprint: True Iron Rudder
  [128257] = true, -- Equipment Blueprint: Ghostly Spyglass
  ------- Other blueprints
  [128256] = true, -- Equipment Blueprint: Gyroscopic Internal Stabilizer
  [128250] = true, -- Equipment Blueprint: Unsinkable
  [128251] = true, -- Equipment Blueprint: Tuskarr Fishing Net
  [128260] = true, -- Equipment Blueprint: Blast Furnace
  [128490] = true, -- Blueprint: Oil Rig
  [128444] = true, -- Blueprint: Oil Rig
}

addon.GARRISON_FOLLOWERS_IDS = {
  ------- Armor
  [120301] = true, -- Armor Enhancement Token
  [114745] = true, -- Braced Armor Enhancement
  [114808] = true, -- Fortified Armor Enhancement
  [114822] = true, -- Heavily Reinforced Armor Enhancement
  [114807] = true, -- War Ravaged Armor Set
  [114806] = true, -- Blackrock Armor Set
  [114746] = true, -- Goredrenched Armor Set
  ------- Weapon
  [120302] = true, -- Weapon Enhancement Token
  [114128] = true, -- Balanced Weapon Enhancement
  [114129] = true, -- Striking Weapon Enhancement
  [114131] = true, -- Power Overrun Weapon Enhancement
  [114616] = true, -- War Ravaged Weaponry
  [114081] = true, -- Blackrock Weaponry
  [114622] = true, -- Goredrenched Weaponry
  ------- Armor & Weapon 
  [120313] = true, -- Sanketsu
  [128314] = true, -- Frozen Arms of a Hero
  ------- Abilities & Traits
  [118354] = true, -- Follower Re-training Certificate
  [122272] = true, -- Follower Ability Retraining Manual
  [122273] = true, -- Follower Trait Retraining Guide
  [123858] = true, -- Follower Retraining Scroll Case
  [118475] = true, -- Hearthstone Strategy Guide
  [118474] = true, -- Supreme Manual of Dance
  [122584] = true, -- Winning with Wildlings
  [122583] = true, -- Grease Monkey Guide
  [122582] = true, -- Guide to Arakkoa Relations
  [122580] = true, -- Ogre Buddy Handbook
  ------- Other enhancements
  [120311] = true, -- The Blademaster's Necklace
  [122298] = true, -- Bodyguard Miniaturization Device
  ------- Contracts
  [116915] = true, -- Inactive Apexis Guardian
  [114245] = true, -- Abu'Gar's Favorite Lure
  [114243] = true, -- Abu'Gar's Finest Reel
  [114242] = true, -- Abu'Gar's Vitality
  [119161] = true, -- Contract: Karg Bloodfury
  [119162] = true, -- Contract: Cleric Maluuf
  [119165] = true, -- Contract: Professor Felblast
  [119166] = true, -- Contract: Cacklebone
  [119167] = true, -- Contract: Vindicator Heluun
  [119248] = true, -- Contract: Dawnseeker Rukaryx
  [119233] = true, -- Contract: Kaz the Shrieker
  [119240] = true, -- Contract: Lokra
  [119242] = true, -- Contract: Magister Serena
  [119243] = true, -- Contract: Magister Krelas
  [119244] = true, -- Contract: Hulda Shadowblade
  [119245] = true, -- Contract: Dark Ranger Velonara
  [119252] = true, -- Contract: Rangari Erdanii
  [119253] = true, -- Contract: Spirit of Bony Xuk
  [119254] = true, -- Contract: Pitfighter Vaandaam
  [119255] = true, -- Contract: Bruto
  [119256] = true, -- Contract: Glirin
  [119257] = true, -- Contract: Penny Clobberbottom
  [119267] = true, -- Contract: Ziri'ak
  [119288] = true, -- Contract: Daleera Moonfang
  [119291] = true, -- Contract: Artificer Andren
  [119292] = true, -- Contract: Vindicator Onaala
  [119296] = true, -- Contract: Rangari Chel
  [119298] = true, -- Contract: Ranger Kaalya
  [119418] = true, -- Contract: Morketh Bladehowl
  [119420] = true, -- Contract: Miall
  [122135] = true, -- Contract: Greatmother Geyah
  [122136] = true, -- Contract: Kal'gor the Honorable
  [122137] = true, -- Contract: Bruma Swiftstone
  [122138] = true, -- Contract: Ulna Thresher
  [112737] = true, -- Contract: Ka'la of the Frostwolves
  [112848] = true, -- Contract: Daleera Moonfang
  [114825] = true, -- Contract: Ulna Thresher
  [114826] = true, -- Contract: Bruma Swiftstone
  [119164] = true, -- Contract: Arakkoa Outcasts Follower
  [119168] = true, -- Contract: Vol'jin's Spear Follower
  [119169] = true, -- Contract: Wrynn's Vanguard Follower
  [119821] = true, -- Contract: Dawnseeker Rukaryx
  [128439] = true, -- Contract: Pallas
  [128440] = true, -- Contract: Dowser Goodwell
  [128441] = true, -- Contract: Solar Priest Vayx
  [128445] = true, -- Contract: Dowser Bigspark
}

addon.GARRISON_SHIPYARD_IDS = {
  [125787] = true, --  Bilge Pump
  [127663] = true, --  Trained Shark Tank
  [127880] = true, --  Ice Cutter
  [127881] = true, --  Gyroscopic Internal Stabilizer
  [127882] = true, --  Blast Furnace
  [127883] = true, --  True Iron Rudder
  [127884] = true, --  Felsmoke Launcher
  [127662] = true, --  High Intensity Fog Lights
  [127888] = true, --  Automated Sky Scanner
  [127889] = true, --  Ammo Reserves
  [127890] = true, --  Sonic Amplification Field
  [127891] = true, --  Extra Quarters
  [127892] = true, --  Q-43 Noisemaker Mines
  [127894] = true, --  Tuskarr Fishing Net
  [127895] = true, --  Ghostly Spyglass
  [127886] = true, --  Unsinkable
}

addon.QUESTS_REPUTATION = {
  --[[ Draenor --]] 

  -- Steamwheedle Preservation Society
  [118099] = true, -- Gorian Artifact Fragment
  [118100] = true, -- Highmaul Relic

  --[[  Pandaria --]] 

  -- The Tillers
  [79265] = true, -- Blue Feather
  [79266] = true, -- Jade Cat
  [79268] = true, -- Marsh Lily
  [79264] = true, -- Ruby Shard
  [79267] = true, -- Lovely Apple

  -- Order of the Cloud Serpent 
  [104286] = true, -- Quivering Firestorm Egg

  --[[  Northerend --]] 

  -- The Sons of Hodir / Explorers' League
  [42780] = true, -- Relic of Ulduar

  --[[  Outland --]] 

  -- The Scryers
  [29739] = true, -- Arcane Tome
  [30810] = true, -- Sunfury Signet
  [29426] = true, -- Firewing Signet

  -- Skettis
  [32446] = true, -- Elixir of Shadows
  [32620] = true, -- Time-Lost Scroll
  [32388] = true, -- Shadow Dust

  -- The Aldor
  [30809] = true, -- Mark of Sargeras

  -- Netherwing
  [32506] = true, -- Netherwing Egg
  [32468] = true, -- Netherdust Pollen
  [32464] = true, -- Nethercite Ore
  [32470] = true, -- Nethermine Flayer hideAnchor
  [32427] = true, -- Netherwing Crystal

  --[[  Kalimdor --]] 

  --[[  Eastern --]] 
}

addon.PETS_BATTLE_STONES_IDS = {
  ------- Flawless Stones
  [98715] = true, -- Marked Flawless Battle-Stone
  [92679] = true, -- Flawless Aquatic Battle-Stone
  [92675] = true, -- Flawless Beast Battle-Stone
  [92676] = true, -- Flawless Critter Battle-Stone
  [92683] = true, -- Flawless Dragonkin Battle-Stone
  [92665] = true, -- Flawless Elemental Battle-Stone
  [92677] = true, -- Flawless Flying Battle-Stone
  [92682] = true, -- Flawless Humanoid Battle-Stone
  [92678] = true, -- Flawless Magic Battle-Stone
  [92680] = true, -- Flawless Mechanical Battle-Stone
  [92681] = true, -- Flawless Undead Battle-Stone

  ------- Battle-training Stones
  [116429] = true, -- Flawless Battle-Training Stone
  [116424] = true, -- Aquatic Battle-Training Stone
  [116374] = true, -- Beast Battle-Training Stone
  [116418] = true, -- Critter Battle-Training Stone
  [116419] = true, -- Dragonkin Battle-Training Stone
  [116420] = true, -- Elemental Battle-Training Stone
  [116421] = true, -- Flying Battle-Training Stone
  [116416] = true, -- Humanoid Battle-Training Stone
  [116422] = true, -- Magic Battle-Training Stone
  [116417] = true, -- Mechanical Battle-Training Stone
  [116423] = true, -- Undead Battle-Training Stone

  ------- Others Stones
  [92742] = true,  -- Polished Battle-Stone (Uncommon)
  [113193] = true, -- Mythical Battle-Pet Stone
  [122457] = true, -- Ultimate Battle-Training Stone
  [127755] = true  -- Fel-Touched Battle-Training Stone
}

addon.PETS_MISCELLANEOUS_IDS = {
  ------- Consumable
  [86143] = true,   -- Battle Pet Bandage
  [37431] = true,   -- Fetch Ball
  [43626] = true,   -- Happy Pet Snack
  [43352] = true,   -- Pet Grooming Kit
  [89906] = true,   -- Magical Mini-Treat
  [71153] = true,   -- Magical Pet Biscuit
  [98114] = true,   -- Pet Treat
  [98112] = true,   -- Lesser Pet Treat

  ------- Leashes
  [89139] = true,   -- Chain Pet Leash
  [44820] = true,   -- Red Ribbon Pet Leash  
  [37460] = true,   -- Rope Pet Leash

  ------- Costumes
  [103786] = true,  -- "Dapper Gentleman" Costume
  [103789] = true,  -- "Little Princess" Costume
  [103795] = true,  -- "Dread Pirate" Costume
  [103797] = true   -- Big Pink Bow
}

addon.MISC_ARCHEOLOGY = {
  
}

addon.MISC_TELEPORT_IDS = {
  -- Hearthstones
  [6948] = true,   -- Hearthstone
  [110560] = true, -- Garrison Hearthstone
  [64488] = true,  -- The Innkeeper's Daughter
  [54452] = true,  -- Ethereal Portal
  [93672] = true,  -- Dark Portal
  [28585] = true,  -- Ruby Slippers
  [64457] = true,  -- The Last Relic of Argus
  [37118] = true,  -- Scroll of Recall
  [44314] = true,  -- Scroll of Recall II
  [44315] = true,  -- Scroll of Recall III

  -- Engineering
  [18984] = true,  -- Dimensional Ripper - Everlook
  [18986] = true,  -- Ultrasafe Transporter: Gadgetzan
  [48933] = true,  -- Wormhole Generator: Northrend
  [87215] = true,  -- Wormhole Generator: Pandaria
  [112059] = true, -- Wormhole Centrifuge

  -- Alchemy
  [58487] = true, -- Potion of Deepholm

  -- Others
  [65274] = true,  -- Cloak of Coordination (alliance)
  [65274] = true,  -- Cloak of Coordination (horde)
  [63206] = true,  -- Wrap of Unity (alliance)
  [63207] = true,  -- Wrap of Unity (horde)
  [63352] = true,  -- Shroud of Cooperation (alliance)
  [63353] = true,  -- Shroud of Cooperation (horde)
  [44935] = true,  -- Ring of the Kirin Tor
  [103678] = true, -- Time-Lost Artifact
  [50287] = true,  -- Boots of the Bay
  [28585] = true,  -- Ruby Slippers
  [32757] = true,  -- Blessed Medallion of Karabor
  [95051] = true,  -- Brassiest Knuckle (alliance)
  [95050] = true,  -- Brassiest Knuckle (horde)
  [46874] = true,  -- Argent Crusader's Tabard
  [63378] = true,  -- Hellscream's Reach Tabard
  [63379] = true,  -- Baradin's Wardens Tabard
  [22589] = true, -- Atiesh, Greatstaff of the Guardian
  [37863] = true, -- Direbrew's Remote
  [128353] = true, -- Admiral's Compass
  [17690] = true,  -- Frostwolf Insignia Rank 1
  [17905] = true,  -- Frostwolf Insignia Rank 2
  [17906] = true,  -- Frostwolf Insignia Rank 3
  [17907] = true,  -- Frostwolf Insignia Rank 4
  [17908] = true,  -- Frostwolf Insignia Rank 5
  [17909] = true,  -- Frostwolf Insignia Rank 6
  [17691] = true,  -- Stormpike Insignia Rank 1
  [17900] = true,  -- Stormpike Insignia Rank 2
  [17901] = true,  -- Stormpike Insignia Rank 3
  [17902] = true,  -- Stormpike Insignia Rank 4
  [17903] = true,  -- Stormpike Insignia Rank 5
  [17904] = true,  -- Stormpike Insignia Rank 6
  [95568] = true, -- Sunreaver Beacon
}

addon.MISC_THE_TILLERS = {
  ------- Seeds
  [85216] = true, -- Enigma Seed
  [79102] = true, -- Green Cabbage Seeds
  [89328] = true, -- Jade Squash Seeds
  [85217] = true, -- Magebulb Seed
  [80592] = true, -- Mogu Pumpkin Seeds
  [80594] = true, -- Pink Turnip Seeds
  [89202] = true, -- Raptorleaf Seed
  [80593] = true, -- Red Blossom Leek Seeds
  [80591] = true, -- Scallion Seeds
  [85215] = true, -- Snakeroot Seed
  [89233] = true, -- Songbell Seed
  [89329] = true, -- Striped Melon Seeds
  [80595] = true, -- White Turnip Seeds
  [89197] = true, -- Windshear Cactus Seed
  [89326] = true, -- Witchberry Seeds

  ------- Bags
  [95449] = true, -- Bag of Enigma Seeds
  [80809] = true, -- Bag of Green Cabbage Seeds
  [89848] = true, -- Bag of Jade Squash Seeds
  [84782] = true, -- Bag of Juicycrunch Carrot Seeds
  [95451] = true, -- Bag of Magebulb Seeds
  [85153] = true, -- Bag of Mogu Pumpkin Seeds
  [85162] = true, -- Bag of Pink Turnip Seeds
  [95457] = true, -- Bag of Raptorleaf Seeds
  [85158] = true, -- Bag of Red Blossom Leek Seeds
  [84783] = true, -- Bag of Scallion Seeds
  [95447] = true, -- Bag of Snakeroot Seeds
  [89849] = true, -- Bag of Striped Melon Seeds
  [85163] = true, -- Bag of White Turnip Seeds
  [95454] = true, -- Bag of Windshear Cactus Seeds
  [89847] = true, -- Bag of Witchberry Seeds

  ------- Others
  [80513] = true, -- Vintage Bug Sprayer
  [79104] = true, -- Rusty Watering Can
  [89880] = true, -- Dented Shovel
  [89815] = true, -- Master Plow
}

addon.MISC_EXCHANGEABLE = {
  [26045]  = true, -- Halaa Battle Token
  [26044]  = true, -- Halaa Research Token
  [116415] = true, -- Pet Charm
  [124099] = true, -- Blackfang Claw
  [91838] = true, -- Lion's Landing Commission
}

addon.MISC_QUEST_EXCHANGEABLE = {
  [113578]  = true, -- Hearty Soup Bone
}

addon.MISC_CHEST_OPENABLE = {
  -- Blingtron
  [86623] = true,  -- Blingtron 4000 Gift Package
  [113258] = true, -- Blingtron 5000 Gift Package

  -- Bags
  [88567] = true,  -- Ghost Iron Lockbox
  [87217] = true,  -- Small Bag of Goods
  [69886] = true,  -- Bag of Coins
  [94159] = true,  -- Small Bag of Zandalari Supplies
  [20767] = true,  -- Scum Covered Bag
  [20766] = true,  -- Slimy Bag

  -- Lockbox
  [68729] = true,  -- Elementium Lockbox
  [43624] = true,  -- Titanium Lockbox
  [43622] = true,  -- Froststeel Lockbox
  [31952] = true,  -- Khorium Lockbox
  [5760] = true,   -- Eternium Lockbox
  [5758] = true,   -- Mithril Lockbox
  [4638] = true,   -- Reinforced Steel Lockbox
  [4637] = true,   -- Steel Lockbox
  [4636] = true,   -- Strong Iron Lockbox
  [4634] = true,   -- Iron Lockbox
  [4633] = true,   -- Heavy Bronze Lockbox
  [4632] = true,   -- Ornate Bronze Lockbox
  [88567] = true,  -- Ghost Iron Lockbox
  [118193] = true, -- Mysterious Shining Lockbox

  -- Others
  [89613] = true,  -- Cache of Treasures
  [34593] = true,  -- Scryer Supplies Package
  [34594] = true,  -- Scryer Supplies Package
}

addon.MISC_TOYS = {
  [119093] = true, -- Aviana's Feather
  [86565] = true,  -- Battle Horn
  [118935] = true, -- Ever-Blooming Frond
  [113542] = true, --  Whispers of Rai'Vosh
}
addon.MISC_TOYS_DRAENOR = {
  [128320] = true, -- Corrupted Primal Obelisk
  [128502] = true, -- Hunter's Seeking Crystal
  [119151] = true, -- Soulgrinder
  [127669] = true, -- Skull of the Mad Chief
  [116113] = true, -- Breath of Talador
  [127655] = true, -- Sassy Imp
  [115506] = true, -- Treessassin's Guise
}
addon.MISC_TOYS_PANDARIA = {
  [81054] = true,  -- Kafa'kota Berry
  [86590] = true,  -- Essence of the Breeze
  [104293] = true, -- Scuttler's Shell
  [104288] = true, -- Condensed Jademist 
  [88384] = true,  -- Burlap Ritual Bag
  [104328] = true, -- Cauterizing Core
}

addon.MISC_ASHRAN = {
  [116411] = true, -- Scroll of Protection
  [116410] = true, -- Scroll of Speed

  -- Class Items
  [117016] = true, -- Wand of Arcane Imprisonment
  [117013] = true, -- Wand of Lightning Shield
  [120327] = true, -- Guide: Sharpshooting
  [112154] = true, -- Guide: Disengage
  [118760] = true, -- Book of Rebirth
  [114849] = true, -- Manual Of Spell Reflection
  [112005] = true, -- The Jailer's Libram
  [111926] = true, -- Codex of Ascension
  [114846] = true, -- Sigil of Dark Simulacrum
  [114848] = true, -- Grimoire Of Convert Demon
  [116982] = true, -- Handbook: Preparation
  [114843] = true, -- Handbook: Pick Pocket
  [114847] = true, -- Tablet of Ghost Wolf
  [114844] = true, -- Scroll of Touch of Death
  [114842] = true, -- Book of Flight Form 
  [114845] = true, -- Tome of Blink

  -- Vendors
  [114126] = true, -- Disposable Pocket Flying Machine
  [115501] = true, -- Kowalski's Music Box
  [116396] = true, -- LeBlanc's Recorder
  [115513] = true, -- Wrynn's Vanguard Battle Standard
  [114629] = true, -- Proximity Alarm-o-Bot 2000
  [114124] = true, -- Phantom Potion
  [115511] = true, -- Bizmo's Big Bang Boom Bomb
  [114125] = true, -- Preserved Discombobulator Ray
  [115522] = true, -- Swift Riding Crop
  [115532] = true, -- Flimsy X-Ray Goggles
  [116925] = true, -- Vintage Free Action Potion
}

--[[
Itens de evento
--]]

addon.MISC_EVENT_EXCHANGEABLE = {
  [21100] = true, -- Coin of Ancestry
  [49927] = true, -- Love Token
}
addon.MISC_EVENT_CHEST_OPENABLE = {
  -- Love is in the Air
  [54537] = true, -- Heart-Shaped Box
  [21813] = true, -- Bag of Heart Candies
  [49909] = true, -- Box of Chocolates
  [50160] = true, -- Lovely Dress Box
}
addon.EVENT_LUNAR_FESTIVAL = {
  [21746] = true, -- Lucky Red Envelope
  [21744] = true, -- Lucky Rocket Cluster
  [21745] = true, -- Elder's Moonstone

  -- Exchangeable
  [21100] = true, -- Coin of Ancestry
}
addon.EVENT_LOVE_IS_IN_THE_AIR = {
  [49668] = true, -- Crown Perfume Sprayer
  [49669] = true, -- Crown Cologne Sprayer
  [49670] = true, -- Crown Chocolate Sampler
  [49661] = true, -- Lovely Charm Collector's Kit
  [49655] = true, -- Lovely Charm
  [49916] = true, -- Lovely Charm Bracelet
  [49939] = true, -- Lovely Orgrimmar Card
  [49937] = true, -- Lovely Undercity Card
  [49941] = true, -- Lovely Thunder Bluff Card
  [49943] = true, -- Lovely Silvermoon City Card
  [49936] = true, -- Lovely Stormwind Card
  [49940] = true, -- Lovely Ironforge Card
  [49938] = true, -- Lovely Darnassus Card
  [49942] = true, -- Lovely Exodar Card
  [50131] = true, -- Snagglebolt's Air Analyzer
  [49867] = true, -- Crown Chemical Co. Supplies
  [49641] = true, -- Faded Lovely Greeting Card
  [50320] = true, -- Faded Lovely Greeting Card
  [22218] = true, -- Handful of Rose Petals
  [22261] = true, -- Love Fool
  [22200] = true, -- Silver Shafted Arrow
  [34258] = true, -- Love Rocket
  [116648] = true, -- Manufactured Love Prism

  -- Exchangeable
  [49927] = true, -- Love Token

  -- Chest & Openable
  [54537] = true, -- Heart-Shaped Box
  [21813] = true, -- Bag of Heart Candies
  [49909] = true, -- Box of Chocolates
  [50160] = true, -- Lovely Dress Box
}
addon.EVENT_NOBLEGARDEN = {
}
addon.EVENT_CHILDRENS_WEEK = {
}
addon.EVENT_MIDSUMMER = {
}
addon.EVENT_BREWFEST = {
}
addon.EVENT_HALLOWS_END = {
}
addon.EVENT_PILGRIMS_BOUNTY = {
}
addon.EVENT_WINTER_VEIL = {
}
addon.EVENT_ARGET_TOURNAMENT = {
}
addon.EVENT_DARKMOON_FAIRE = {
  [71634] = true, -- Darkmoon Adventurer's Guide
}
addon.EVENT_BRAWLERS_GUILD = {
}