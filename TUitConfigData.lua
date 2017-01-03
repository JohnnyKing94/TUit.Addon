TUI_Config = {
    Races = {
        ["1"] = {
            id = 1,
            name = "Breton",
            texture = "breton.dds",
        },
        ["2"] = {
            id = 2,
            name = "Redguard",
            texture = "redguard.dds",
        },
        ["3"] = {
            id = 3,
            name = "Orc",
            texture = "orc.dds",
        },
        ["4"] = {
            id = 4,
            name = "Dark Elf",
            texture = "dunmer.dds",
        },
        ["5"] = {
            id = 5,
            name = "Nord",
            texture = "nord.dds",
        },
        ["6"] = {
            id = 6,
            name = "Argonian",
            texture = "argonian.dds",
        },
        ["7"] = {
            id = 7,
            name = "High Elf",
            texture = "altmer.dds",
        },
        ["8"] = {
            id = 8,
            name = "Wood Elf",
            texture = "bosmer.dds",
        },
        ["9"] = {
            id = 9,
            name = "Khajiit",
            texture = "khajiit.dds",
        },
        ["10"] = {
            id = 10,
            name = "Imperial",
            texture = "imperial.dds",
        },
    },
    Classes = {
        ["1"] = {
            id = 1,
            name = "Dragonknight",
            texture = "dragonknight.dds",
        },
        ["2"] = {
            id = 2,
            name = "Sorcerer",
            texture = "sorcerer.dds",
        },
        ["3"] = {
            id = 3,
            name = "Nightblade",
            texture = "nightblade.dds",
        },
        ["6"] = {
            id = 6,
            name = "Templar",
            texture = "templar.dds",
        }
    },
    Roles = {
        [1] = {
            name = "Tank",
            texture = "tank.dds"
        },
        [2] = {
            name = "Dps",
            texture = "dps.dds"
        },
        [3] = {
            name = "Healer",
            texture = "healer.dds"
        },
        [4] = {
            name = "Tank/Dps",
            texture = "tank-dps.dds"
        },
        [5] = {
            name = "Tank/Healer",
            texture = "tank-healer.dds"
        },
        [6] = {
            name = "Dps/Healer",
            texture = "dps.dds"
        },
    },
    ItemData = {
        slots = {
            [EQUIP_SLOT_MAIN_HAND] = { name = "Mano Principale" },
            [EQUIP_SLOT_OFF_HAND] = { name = "Mano Secondaria" },
            [EQUIP_SLOT_BACKUP_MAIN] = { name = "Alternativa Principale" },
            [EQUIP_SLOT_BACKUP_OFF] = { name = "Alternativa Secondaria" },
            [EQUIP_SLOT_HEAD] = { name = "Testa" },
            [EQUIP_SLOT_CHEST] = { name = "Torso" },
            [EQUIP_SLOT_LEGS] = { name = "Gambe" },
            [EQUIP_SLOT_SHOULDERS] = { name = "Spalle" },
            [EQUIP_SLOT_FEET] = { name = "Scarpe" },
            [EQUIP_SLOT_WAIST] = { name = "Cintura" },
            [EQUIP_SLOT_HAND] = { name = "Guanti" },
            [EQUIP_SLOT_NECK] = { name = "Collare" },
            [EQUIP_SLOT_RING1] = { name = "Anello 1" },
            [EQUIP_SLOT_RING2] = { name = "Anello 2" },
        },
        flags = {
            crafted       = 0x01,
            jewelry       = 0x02,
            weapon        = 0x04,
            monster       = 0x08,
            mixedWeights  = 0x10,
            allianceStyle = 0x20,
            multiStyle    = 0x40,
        },
        undauntedNames = {
            [1] = "Maj",
            [2] = "Glirion",
            [3] = "Urgarlag",
        },
        zoneTypes = {
            overland = 1,
            ava      = 2,
            dungeon  = 3,
            trial    = 4,
        },
        zoneClassification = {
            -- Daggerfall Covenant -------------------------------------------------
            [534] = 1, -- Stros M'Kai
            [535] = 1, -- Betnikh
            [  3] = 1, -- Glenumbra
            [ 19] = 1, -- Stormhaven
            [ 20] = 1, -- Rivenspire
            [104] = 1, -- Alik'r Desert
            [ 92] = 1, -- Bangkorai

            -- Aldmeri Dominion ----------------------------------------------------
            [537] = 1, -- Khenarthi's Roost
            [381] = 1, -- Auridon
            [383] = 1, -- Grahtwood
            [108] = 1, -- Greenshade
            [ 58] = 1, -- Malabal Tor
            [382] = 1, -- Reaper's March

            -- Ebonheart Pact ------------------------------------------------------
            [280] = 1, -- Bleakrock Isle
            [281] = 1, -- Bal Foyen
            [ 41] = 1, -- Stonefalls
            [ 57] = 1, -- Deshaan
            [117] = 1, -- Shadowfen
            [101] = 1, -- Eastmarch
            [103] = 1, -- The Rift

            -- Neutral -------------------------------------------------------------
            [347] = 1, -- Coldharbour
            [267] = 1, -- Eyevea
            [642] = 1, -- The Earth Forge
            [888] = 1, -- Craglorn
            [684] = 1, -- Wrothgar
            [816] = 1, -- Hew's Bane
            [823] = 1, -- The Gold Coast

            -- AvA -----------------------------------------------------------------
            [181] = 2, -- Cyrodiil
            [584] = 2, -- Imperial City
            [643] = 2, -- Imperial Sewers

            -- Dungeons ------------------------------------------------------------
            [144] = 3, -- Spindleclutch I
            [936] = 3, -- Spindleclutch II
            [380] = 3, -- The Banished Cells I
            [935] = 3, -- The Banished Cells II
            [283] = 3, -- Fungal Grotto I
            [934] = 3, -- Fungal Grotto II
            [146] = 3, -- Wayrest Sewers I
            [933] = 3, -- Wayrest Sewers II
            [126] = 3, -- Elden Hollow I
            [931] = 3, -- Elden Hollow II
            [ 63] = 3, -- Darkshade Caverns I
            [930] = 3, -- Darkshade Caverns II
            [130] = 3, -- Crypt of Hearts I
            [932] = 3, -- Crypt of Hearts II
            [176] = 3, -- City of Ash I
            [681] = 3, -- City of Ash II
            [148] = 3, -- Arx Corinium
            [ 22] = 3, -- Volenfell
            [131] = 3, -- Tempest Island
            [449] = 3, -- Direfrost Keep
            [ 38] = 3, -- Blackheart Haven
            [ 31] = 3, -- Selene's Web
            [ 64] = 3, -- Blessed Crucible
            [ 11] = 3, -- Vaults of Madness
            [678] = 3, -- Imperial City Prison
            [688] = 3, -- White-Gold Tower
            [843] = 3, -- Ruins of Mazzatun
            [848] = 3, -- Cradle of Shadows

            -- Trials --------------------------------------------------------------
            [636] = 4, -- Hel Ra Citadel
            [638] = 4, -- Aetherian Archive
            [639] = 4, -- Sanctum Ophidia
            [725] = 4, -- Maw of Lorkhaj
            [635] = 4, -- Dragonstar Arena
            [677] = 4, -- Maelstrom Arena

            -- Miscellaneous -------------------------------------------------------
            [ -1] = 3, -- Random Dungeon Finder
        },
    },
	colors = {
		health          = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_HEALTH)),
		magicka         = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_MAGICKA)),
		stamina         = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_STAMINA)),
		violet          = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_ARTIFACT)),
		gold            = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_LEGENDARY)),
		brown           = ZO_ColorDef:New("885533"),
        lightbrown      = ZO_ColorDef:New("C4855A"),
		teal            = ZO_ColorDef:New("66CCCC"),
		pink            = ZO_ColorDef:New("FF99CC"),
	},
}