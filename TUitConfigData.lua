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
        items = {
            -- Crafted -------------------------------------------------------------
            { 46258, 0x51, { 3, 381, 41 }, 2 }, -- Death's Wind
            { 46644, 0x51, { 19, 383, 57 }, 3 }, -- Twilight's Embrace
            { 47035, 0x51, { 3, 381, 41 }, 2 }, -- Night's Silence
            { 47403, 0x51, { 20, 108, 117 }, 4 }, -- Whitestrake's Retribution
            { 47793, 0x51, { 19, 383, 57 }, 3 }, -- Armor of the Seducer
            { 48169, 0x51, { 104, 58, 101 }, 5 }, -- Vampire's Kiss
            { 48559, 0x51, { 20, 108, 117 }, 4 }, -- Magnus' Gift
            { 48950, 0x51, { 92, 382, 103 }, 6 }, -- Night Mother's Gaze
            { 49333, 0x51, { 3, 381, 41 }, 2 }, -- Ashen Grip
            { 49708, 0x51, { 347 }, 8 }, -- Oblivion's Foe
            { 50082, 0x51, { 347 }, 8 }, -- Spectre's Eye
            { 50470, 0x51, { 19, 383, 57 }, 3 }, -- Torug's Pact
            { 50845, 0x51, { 20, 108, 117 }, 4 }, -- Hist Bark
            { 51233, 0x51, { 92, 382, 103 }, 6 }, -- Willow's Path
            { 51622, 0x51, { 92, 382, 103 }, 6 }, -- Hunding's Rage
            { 51988, 0x51, { 104, 58, 101 }, 5 }, -- Song of Lamae
            { 52369, 0x51, { 104, 58, 101 }, 5 }, -- Alessia's Bulwark
            { 52750, 0x51, { 642 }, 8 }, -- Orgnum's Scales
            { 53138, 0x51, { 267 }, 8 }, -- Eyes of Mara
            { 53519, 0x51, { 642 }, 8 }, -- Kagrenac's Hope
            { 53893, 0x51, { 267 }, 8 }, -- Shalidor's Curse
            { 55163, 0x51, { 888 }, 8 }, -- Way of the Arena
            { 58483, 0x51, { 888 }, 9 }, -- Twice-Born Star
            { 60133, 0x51, { 584 }, 5 }, -- Noble's Conquest
            { 60490, 0x51, { 584 }, 7 }, -- Redistributor
            { 60833, 0x51, { 584 }, 9 }, -- Armor Master
            { 69837, 0x51, { 684 }, 6 }, -- Law of Julianos
            { 70173, 0x51, { 684 }, 3 }, -- Trial by Fire
            { 70880, 0x51, { 684 }, 9 }, -- Morkuldin
            { 72037, 0x51, { 816 }, 5 }, -- Tava's Favor
            { 72401, 0x51, { 816 }, 7 }, -- Clever Alchemist
            { 72674, 0x51, { 816 }, 9 }, -- Eternal Hunt
            { 75449, 0x51, { 823 }, 5 }, -- Kvatch Gladiator
            { 75784, 0x51, { 823 }, 7 }, -- Varen's Legacy
            { 76134, 0x51, { 823 }, 9 }, -- Pelinal's Aptitude

            -- Non-Crafted ---------------------------------------------------------
            { 68432, 0x20, { 643 } }, -- Black Rose
            { 68439, 0x00, { 684 } }, -- Trinimac's Valor
            { 68447, 0x00, { 684 } }, -- Briarheart
            { 68527, 0x00, { 677 } }, -- Winterborn
            { 68535, 0x20, { 643 } }, -- Powerful Assault
            { 68608, 0x00, { 684 } }, -- Mark of the Pariah
            { 68615, 0x20, { 643 } }, -- Meritorious Service
            { 68623, 0x00, { 677 } }, -- Para Bellum
            { 68696, 0x00, { 677 } }, -- Glorious Defender
            { 68703, 0x00, { 677 } }, -- Elemental Succession
            { 68711, 0x20, { 643 } }, -- Shield Breaker
            { 68784, 0x00, { 677 } }, -- Permafrost
            { 68791, 0x20, { 643 } }, -- Phoenix
            { 68799, 0x00, { 677 } }, -- Hunt Leader
            { 68872, 0x20, { 643 } }, -- Reactive Armor
            { 72870, 0x10, { 816 } }, -- Bahraha's Curse
            { 72950, 0x10, { 816 } }, -- Syvarra's Scales
            { 72993, 0x00, { 725 } }, -- Moondancer
            { 73019, 0x00, { 725 } }, -- Twilight Remedy
            { 73044, 0x00, { 725 } }, -- Roar of Alkosh
            { 73067, 0x00, { 725 } }, -- Lunar Bastion
            { 73873, 0x00, { 181 } }, -- Marksman's Crest
            { 73935, 0x00, { 181 } }, -- Leki's Focus
            { 73997, 0x00, { 181 } }, -- Fasalla's Guile
            { 74080, 0x00, { 181 } }, -- Warrior's Fury
            { 74165, 0x00, { 181 } }, -- Vicious Death
            { 74238, 0x00, { 181 } }, -- Robes of Transmutation
            { 74744, 0x00, { 20 } }, -- Darkstride
            { 74906, 0x00, { 108 } }, -- Shadow Dancer's Raiment
            { 76929, 0x00, { 823 } }, -- Hide of Morihaus
            { 77089, 0x00, { 823 } }, -- Flanking Strategist
            { 77256, 0x10, { 823 } }, -- Sithis' Touch
            { 78068, 0x00, { 643 } }, -- Galerion's Revenge
            { 78356, 0x00, { 643 } }, -- Vicecanon of Venom
            { 78621, 0x00, { 643 } }, -- Thews of the Harbinger
            { 79237, 0x10, { 643 } }, -- Imperial Physique
            { 79947, 0x00, { 636, 638, 639 } }, -- Eternal Warrior
            { 80099, 0x00, { 636, 638, 639 } }, -- Vicious Serpent
            { 80251, 0x00, { 636, 638, 639 } }, -- Infallible Mage
            { 80714, 0x00, { 381 } }, -- Queen's Elegance
            { 81025, 0x00, { 382 } }, -- Senche's Bite
            { 82244, 0x00, { 843 } }, -- Aspect of Mazzatun
            { 82426, 0x00, { 843 } }, -- Amber Plasm
            { 82617, 0x00, { 843 } }, -- Heem-Jas' Retribution
            { 82799, 0x00, { 848 } }, -- Hand of Mephala
            { 82981, 0x00, { 848 } }, -- Gossamer
            { 83172, 0x00, { 848 } }, -- Widowmaker
            { 84538, 0x00, { 101 } }, -- Akaviri Dragonguard
            { 84720, 0x00, { 41 } }, -- Silks of the Sun
            { 84911, 0x00, { 41 } }, -- Shadow of the Red Mountain
            { 85093, 0x00, { 383 } }, -- Syrabane's Grip
            { 85466, 0x00, { 58 } }, -- Salvation
            { 86021, 0x00, { 3 } }, -- Hide of the Werewolf
            { 86203, 0x00, { 104 } }, -- Robes of the Withered Hand
            { 86576, 0x00, { 19 } }, -- Storm Knight's Plate
            { 86758, 0x00, { 20 } }, -- Necropotence
            { 86949, 0x00, { 635 } }, -- Footman's Fortune
            { 87131, 0x00, { 635 } }, -- Healer's Habit
            { 87322, 0x00, { 635 } }, -- Robes of Destruction Mastery
            { 87513, 0x00, { 635 } }, -- Archer's Mind
            { 88000, 0x20, { 181 } }, -- Alessian Order
            { 88364, 0x20, { 181 } }, -- Crest of Cyrodiil
            { 88546, 0x20, { 181 } }, -- Bastion of the Heartland
            { 88728, 0x20, { 181 } }, -- Beckoning Steel
            { 88910, 0x20, { 181 } }, -- The Juggernaut
            { 89274, 0x20, { 181 } }, -- Affliction
            { 89456, 0x20, { 181 } }, -- Ravager
            { 89820, 0x20, { 181 } }, -- Elf Bane
            { 90240, 0x20, { 181 } }, -- Desert Rose
            { 90813, 0x20, { 181 } }, -- Curse Eater
            { 91004, 0x20, { 181 } }, -- Almalexia's Mercy
            { 91386, 0x20, { 181 } }, -- Robes of Alteration Mastery
            { 91577, 0x20, { 181 } }, -- The Arch-Mage
            { 91768, 0x20, { 181 } }, -- Light of Cyrodiil
            { 91959, 0x20, { 181 } }, -- Buffer of the Swift
            { 92280, 0x00, { 381 } }, -- Twin Sisters
            { 92644, 0x20, { 181 } }, -- Shield of the Valiant
            { 92826, 0x20, { 181 } }, -- Shadow Walker
            { 93190, 0x20, { 181 } }, -- Hawk's Eye
            { 93372, 0x20, { 181 } }, -- The Morag Tong
            { 93554, 0x20, { 181 } }, -- Kyne's Kiss
            { 93736, 0x20, { 181 } }, -- Ward of Cyrodiil
            { 93918, 0x20, { 181 } }, -- Sentry
            { 94269, 0x00, { 381 } }, -- Armor of the Veiled Heritance
            { 95285, 0x00, { 888 } }, -- Way of Fire
            { 95467, 0x00, { 888 } }, -- Way of Martial Knowledge
            { 95658, 0x00, { 888 } }, -- Way of Air
            { 95983, 0x50, { 534, 537, 280, 535, 281 } }, -- Armor of the Trainee
            { 96411, 0x00, { 3 } }, -- Bloodthorn's Touch
            { 96602, 0x00, { 41 } }, -- Shalk Exoskeleton
            { 96784, 0x00, { 3 } }, -- Wyrd Tree's Blessing
            { 96972, 0x00, { 57 } }, -- Night Mother's Embrace
            { 97050, 0x00, { 57 } }, -- Plague Doctor
            { 97232, 0x00, { 57 } }, -- Mother's Sorrow
            { 97423, 0x00, { 108 } }, -- Wilderqueen's Arch
            { 97605, 0x00, { 383 } }, -- Green Pact
            { 97787, 0x00, { 19 } }, -- Night Terror
            { 97969, 0x00, { 19 } }, -- Dreamer's Mantle
            { 98160, 0x00, { 383 } }, -- Ranger's Gait
            { 98342, 0x00, { 108 } }, -- Beekeeper's Gear
            { 98524, 0x00, { 20 } }, -- Vampire Cloak
            { 98706, 0x00, { 117 } }, -- Robes of the Hist
            { 98897, 0x00, { 117 } }, -- Swamp Raider
            { 99079, 0x00, { 117 } }, -- Hatchling's Shell
            { 99298, 0x00, { 104 } }, -- Sword-Singer
            { 99480, 0x00, { 104 } }, -- Order of Diagna
            { 99662, 0x00, { 58 } }, -- Spinner's Garments
            { 99853, 0x00, { 58 } }, -- Thunderbug's Carapace
            { 100035, 0x00, { 101 } }, -- Stendarr's Embrace
            { 100226, 0x00, { 101 } }, -- Fiord's Legacy
            { 100411, 0x00, { 92 } }, -- Vampire Lord
            { 100602, 0x00, { 92 } }, -- Spriggan's Thorns
            { 100784, 0x00, { 92 } }, -- Seventh Legion Brute
            { 100966, 0x00, { 382 } }, -- Skooma Smuggler
            { 101157, 0x00, { 382 } }, -- Soulshine
            { 101339, 0x00, { 103 } }, -- Ysgramor's Birthright
            { 101530, 0x00, { 103 } }, -- Witchman Armor
            { 101712, 0x00, { 103 } }, -- Draugr's Heritage
            { 101895, 0x00, { 347 } }, -- Prisoner's Rags
            { 102086, 0x00, { 347 } }, -- Stygian
            { 102268, 0x00, { 347 } }, -- Meridia's Blessed Armor
            { 102450, 0x00, { 380, 935 } }, -- Sanctuary
            { 102641, 0x00, { 380, 935 } }, -- Jailbreaker
            { 102823, 0x00, { 380, 935 } }, -- Tormentor
            { 103005, 0x00, { 144, 936 } }, -- Spelunker
            { 103187, 0x00, { 283, 934 } }, -- Spider Cultist Cowl
            { 103378, 0x00, { 126, 931 } }, -- Light Speaker
            { 103569, 0x00, { 126, 931 } }, -- Undaunted Bastion
            { 103751, 0x00, { 146, 933 } }, -- Combat Physician
            { 103942, 0x00, { 146, 933 } }, -- Toothrow
            { 104124, 0x00, { 63, 930 } }, -- Netch's Touch
            { 104315, 0x00, { 63, 930 } }, -- Strength of the Automaton
            { 104497, 0x00, { 176, 681 } }, -- Burning Spellweave
            { 104688, 0x00, { 176, 681 } }, -- Sunderflame
            { 104870, 0x00, { 176, 681 } }, -- Embershield
            { 105052, 0x00, { 31 } }, -- Hircine's Veneer
            { 105234, 0x00, { 64 } }, -- Sword Dancer
            { 105416, 0x00, { 22 } }, -- Treasure Hunter
            { 105607, 0x00, { 22 } }, -- Duneripper's Scales
            { 105789, 0x00, { 130, 932 } }, -- Shroud of the Lich
            { 105980, 0x00, { 130, 932 } }, -- Leviathan
            { 106162, 0x00, { 130, 932 } }, -- Ebon Armory
            { 106344, 0x00, { 148 } }, -- Lamia's Song
            { 106535, 0x00, { 148 } }, -- Undaunted Infiltrator
            { 106717, 0x00, { 148 } }, -- Medusa
            { 106899, 0x00, { 449 } }, -- Magicka Furnace
            { 107090, 0x00, { 449 } }, -- Draugr Hulk
            { 107272, 0x00, { 38 } }, -- Undaunted Unweaver
            { 107463, 0x00, { 38 } }, -- Bone Pirate's Tatters
            { 107645, 0x00, { 38 } }, -- Knight-errant's Mail
            { 107827, 0x00, { 144, 936 } }, -- Prayer Shawl
            { 108018, 0x00, { 144, 936 } }, -- Knightmare
            { 108200, 0x00, { 283, 934 } }, -- Viper's Sting
            { 108382, 0x00, { 283, 934 } }, -- Dreugh King Slayer
            { 108564, 0x00, { 126, 931 } }, -- Barkskin
            { 108746, 0x00, { 146, 933 } }, -- Sergeant's Mail
            { 108928, 0x00, { 63, 930 } }, -- Armor of Truth
            { 109110, 0x00, { 22 } }, -- Crusader
            { 109292, 0x00, { 449 } }, -- The Ice Furnace
            { 109474, 0x00, { 31 } }, -- Vestments of the Warlock
            { 109665, 0x00, { 31 } }, -- Durok's Bane
            { 109847, 0x00, { 64 } }, -- Noble Duelist's Silks
            { 110038, 0x00, { 64 } }, -- Nikulas' Heavy Armor
            { 110220, 0x00, { 131 } }, -- Overwhelming Surge
            { 110411, 0x00, { 131 } }, -- Storm Master
            { 110593, 0x00, { 131 } }, -- Jolting Arms
            { 110775, 0x00, { 11 } }, -- The Worm's Raiment
            { 110966, 0x00, { 11 } }, -- Oblivion's Edge
            { 111148, 0x00, { 11 } }, -- Rattlecage
            { 111330, 0x00, { 678 } }, -- Scathing Mage
            { 111521, 0x00, { 678 } }, -- Sheer Venom
            { 111703, 0x00, { 678 } }, -- Leeching Plate
            { 111885, 0x00, { 688 } }, -- Spell Power Cure
            { 112076, 0x00, { 688 } }, -- Essence Thief
            { 112258, 0x00, { 688 } }, -- Brands of Imperium
            { 112458, 0x00, { 638 } }, -- Healing Mage
            { 112649, 0x00, { 638 } }, -- Quick Serpent
            { 112831, 0x00, { 638 } }, -- Defending Warrior
            { 113013, 0x00, { 636 } }, -- Destructive Mage
            { 113204, 0x00, { 636 } }, -- Poisonous Serpent
            { 113386, 0x00, { 636 } }, -- Berserking Warrior
            { 113568, 0x00, { 639 } }, -- Wise Mage
            { 113759, 0x00, { 639 } }, -- Twice-Fanged Serpent
            { 113941, 0x00, { 639 } }, -- Immortal Warrior

            -- Monster Sets --------------------------------------------------------
            { 59390, 0x18, { 934 }, 1 }, -- Spawn of Mephala
            { 59426, 0x18, { 936 }, 1 }, -- Blood Spawn
            { 59456, 0x18, { 678 }, 3 }, -- Lord Warden
            { 59492, 0x18, { 933 }, 1 }, -- Scourge Harvester
            { 59528, 0x18, { 930 }, 1 }, -- Engine Guardian
            { 59576, 0x18, { 931 }, 1 }, -- Nightflame
            { 59612, 0x18, { 932 }, 2 }, -- Nerien'eth
            { 59648, 0x18, { 681 }, 2 }, -- Valkyn Skoria
            { 59678, 0x18, { 935 }, 1 }, -- Maw of the Infernal
            { 68123, 0x18, { 688 }, 3 }, -- Molag Kena
            { 82142, 0x18, { 848 }, 3 }, -- Velidreth
            { 82188, 0x18, { 843 }, 3 }, -- Mighty Chudan
            { 94476, 0x18, { 144 }, 1 }, -- Swarm Mother
            { 94500, 0x18, { 146 }, 1 }, -- Slimecraw
            { 94548, 0x18, {  22 }, 2 }, -- Tremorscale
            { 94556, 0x18, {  38 }, 2 }, -- Pirate Skeleton
            { 94732, 0x18, { 380 }, 1 }, -- Shadowrend
            { 94756, 0x18, {  63 }, 1 }, -- Sentinel of Rkugamz
            { 94764, 0x18, { 126 }, 1 }, -- Chokethorn
            { 94788, 0x18, { 176 }, 2 }, -- Infernal Guardian
            { 94796, 0x18, { 130 }, 2 }, -- Ilambris
            { 94804, 0x18, { 449 }, 2 }, -- Iceheart
            { 94836, 0x18, {  64 }, 2 }, -- The Troll King
            { 94852, 0x18, {  11 }, 2 }, -- Grothdarr
            { 95012, 0x18, { 283 }, 1 }, -- Kra'gh
            { 95052, 0x18, { 148 }, 2 }, -- Sellistrix
            { 95084, 0x18, { 131 }, 2 }, -- Stormfist
            { 95116, 0x18, {  31 }, 2 }, -- Selene

            -- 3p Jewelry Sets -----------------------------------------------------
            { 69166, 0x22, { 584, -1 } }, -- Endurance
            { 69278, 0x22, { 584, -1 } }, -- Willpower
            { 69390, 0x22, { 584, -1 } }, -- Agility
            { 87748, 0x22, { 181 } }, -- Blessing of the Potentates
            { 87867, 0x22, { 181 } }, -- Deadly Strike
            { 89988, 0x22, { 181 } }, -- Wrath of the Imperium
            { 90107, 0x22, { 181 } }, -- Grace of the Ancients
            { 92136, 0x22, { 181 } }, -- Eagle Eye
            { 92147, 0x22, { 181 } }, -- Vengeance Leech

            -- Arena Weapons -------------------------------------------------------
            { 55939, 0x04, { 635 } }, -- The Master's Restoration Staff
            { 55983, 0x04, { 635 } }, -- The Master's Sword
            { 55988, 0x04, { 635 } }, -- The Master's Greatsword
            { 55990, 0x04, { 635 } }, -- The Master's Dagger
            { 55991, 0x04, { 635 } }, -- The Master's Bow
            { 55992, 0x04, { 635 } }, -- The Master's Inferno Staff
            { 57452, 0x04, { 635 } }, -- The Master's Ice Staff
            { 57458, 0x04, { 635 } }, -- The Master's Lightning Staff
            { 71104, 0x04, { 677 } }, -- The Maelstrom's Axe
            { 71109, 0x04, { 677 } }, -- The Maelstrom's Mace
            { 71115, 0x04, { 677 } }, -- The Maelstrom's Sword
            { 71122, 0x04, { 677 } }, -- The Maelstrom's Battle Axe
            { 71128, 0x04, { 677 } }, -- The Maelstrom's Maul
            { 71134, 0x04, { 677 } }, -- The Maelstrom's Greatsword
            { 71140, 0x04, { 677 } }, -- The Maelstrom's Dagger
            { 71146, 0x04, { 677 } }, -- The Maelstrom's Bow
            { 71156, 0x04, { 677 } }, -- The Maelstrom's Inferno Staff
            { 71162, 0x04, { 677 } }, -- The Maelstrom's Ice Staff
            { 71168, 0x04, { 677 } }, -- The Maelstrom's Lightning Staff
            { 79870, 0x04, { 677 } }, -- The Maelstrom's Restoration Staff
        },
    },
	colors = {
		health  = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_HEALTH)),
		magicka = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_MAGICKA)),
		stamina = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_POWER, POWERTYPE_STAMINA)),
		violet  = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_ARTIFACT)),
		gold    = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_LEGENDARY)),
		brown   = ZO_ColorDef:New("885533"),
		teal    = ZO_ColorDef:New("66CCCC"),
		pink    = ZO_ColorDef:New("FF99CC"),
	},
}