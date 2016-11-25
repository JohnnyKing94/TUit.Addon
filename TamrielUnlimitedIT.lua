-- INIT VARIABILI
TamrielUnlimitedIT = {}
TamrielUnlimitedIT.name = "TamrielUnlimitedIT"
TamrielUnlimitedIT.LMM = LibStub("LibMainMenu")

TamrielUnlimitedIT.err = {}
TamrielUnlimitedIT.PreLoadEvent = {}
TamrielUnlimitedIT.BackToMainPage = false

DebugArray = {}
DebugArray.err = {}
DebugArray.PreLoadEvent = {}
DebugArray.PlayerLoaded = false

-- Util e PreLoadEvent
function AddErr(str)

	if (DebugArray.PlayerLoaded) then
		d(str)
	else
		DebugArray.err[#DebugArray.err + 1] = str
	end
end
function PrintErrMessage()
	for i = 1, #DebugArray.err do
		d(DebugArray.err[i])
	end

	while #DebugArray.err ~= 0 do
		table.remove(DebugArray.err)
	end
end
function AddPreLoadEvent(ev)
	DebugArray.PreLoadEvent[#DebugArray.PreLoadEvent + 1] = ev
end

-- Inizializzazione
function TamrielUnlimitedIT.OnAddOnLoaded(event, addonName)
	TamrielUnlimitedIT.InitializeSavedVars()
	if TUitDataVar ~= nil then
	
		TamrielUnlimitedIT.TUitDataVar = deepcopy(TUitDataVar)
		
		if TUitDataVar.PlayersData ~= nil then
			TUitDataVar.Player = CreatePlayerArray(TUitDataVar.PlayersData)
		end
		if TUitDataVar.Guilds ~= nil then
			TUitDataVar.Guild = CreateGuildArray(TUitDataVar.Guilds)
			if TUitDataVar.Guilds.AD ~= nil then
				TUitDataVar.GuildAD = CreateGuildArray(TUitDataVar.Guilds.AD)
			end
			if TUitDataVar.Guilds.DC ~= nil then
				TUitDataVar.GuildDC = CreateGuildArray(TUitDataVar.Guilds.DC)
			end
			if TUitDataVar.Guilds.EP ~= nil then
				TUitDataVar.GuildEP = CreateGuildArray(TUitDataVar.Guilds.EP)
			end
		end
		if TUitDataVar.Events ~= nil then
			TamrielUnlimitedIT.EventTemp = deepcopy(TUitDataVar.Events)
		end
	
		if next(TamrielUnlimitedIT.TUitDataVar) ~= nil then
			if addonName == TamrielUnlimitedIT.name then
				TamrielUnlimitedIT:InitializeScene()
			end
		end
	end
end
function TamrielUnlimitedIT.PlayerNotification()
	if TUitDataVar ~= nil then
		if next(TamrielUnlimitedIT.TUitDataVar) ~= nil then
			d("|c919191L'addon|r |cff0000"..TamrielUnlimitedIT.name.."|r |c919191è stato caricato con successo|r")

			EVENT_MANAGER:UnregisterForEvent(TamrielUnlimitedIT.name, EVENT_PLAYER_ACTIVATED)
			
			local DettagliArray = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
			if DettagliArray ~= nil and #DettagliArray ~= 0 then
				d("|cffa800Hai un messaggio nella|r |cfffffftab Convalida|r |cffa800dell'addon|r |cff0000Tamriel Unlimited IT|r|cffa800. Si prega di leggere!|r")
			end
		else
			d("La struttura del |cff0000TUitDataVar|r risulta essere vuota nel file |c919191TUitData.lua|r, si prega di riscaricare i dati via app!\n\rUna volta caricati fare |cff0000/reloadui|r")
		end
	else
		d("Il file |c919191TUitData.lua|r risulta essere vuoto o non esistere, si prega di riscaricare i dati via app!\n\rUna volta caricati fare |cff0000/reloadui|r")
	end
end
function TamrielUnlimitedIT.InitializeSavedVars()
	AccountData = {
		Guilds = {},
		CP = 0,
	}
	CharactersData = {
		lev = 0,
		sex = 1,
		class = "",
		alli = 1,
		race = "",
		last_update = "",
	}
	TamrielUnlimitedIT.savedVariablesGlobal = ZO_SavedVars:NewAccountWide("TUitData", 1, nil, AccountData)
	TamrielUnlimitedIT.savedVariables = ZO_SavedVars:New("TUitData", 1, nil, CharactersData)

	TamrielUnlimitedIT.UpdateAccountData()
	TamrielUnlimitedIT.UpdateCharacterData()
end
function TamrielUnlimitedIT:InitializeScene()
	self.Hidden = true;
	self.InPausa = IsReticleHidden();

	TamrielUnlimitedIT.PlayerTemp = {}
	LoadArrayPlayerTemp()


	-- Utenti
	TamrielUnlimitedIT.Utenti = CreateControlFromVirtual("DynamicLabel_stampataUtenti", UtentiPanelMainMenu, "DynamicTextUtenti", 0)
	TamrielUnlimitedIT.Utenti:SetAnchor(TOP, UtentiPanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Utenti:SetHidden(false)
	local sc = DynamicLabel_stampataUtenti0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPagePlayer = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelUtenti", sc, "DynamicScrollPageUtenti", 0)
	if TamrielUnlimitedIT.PlayerTemp ~= nil then
		if #TamrielUnlimitedIT.PlayerTemp ~= 0 then
			SortCP()
		else
			LoadNoPlayer()
		end
	else
		LoadNoPlayer()
	end

	Search_edit:SetHandler("OnEnter", function (self, key, ctrl, alt, shift, command)
			CercaPlayer(Search_edit:GetText())
		end)

	-- Gilde
	TamrielUnlimitedIT.Guilds = CreateControlFromVirtual("DynamicLabel_stampataGilde", GildePanelMainMenu, "DynamicTextGilde", 0)
	TamrielUnlimitedIT.Guilds:SetAnchor(TOP, GildePanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Guilds:SetHidden(false)
	local sc = DynamicLabel_stampataGilde0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPageGilde = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelGilde", sc, "DynamicScrollPageGilde", 0)
	LoadGilde()

	-- Eventi
	TamrielUnlimitedIT.Events = CreateControlFromVirtual("DynamicLabel_stampataEventi", EventiPanelMainMenu, "DynamicTextEventi", 0)
	TamrielUnlimitedIT.Events:SetAnchor(TOP, EventiPanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Events:SetHidden(false)
	local sc = DynamicLabel_stampataEventi0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPageEventi = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelEventi", sc, "DynamicScrollPageEventi", 0)
	TamrielUnlimitedIT.DynamicScrollPageEventiMessage = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelEventiMessage", sc, "EventMessage", 0)
	LoadEventi()

	-- Community
	TamrielUnlimitedIT.Community = CreateControlFromVirtual("DynamicLabel_stampataCommunity", CommunityPanelMainMenu, "DynamicTextCommunity", 0)
	TamrielUnlimitedIT.Community:SetAnchor(TOP, CommunityPanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Community:SetHidden(false)
	local sc = DynamicLabel_stampataCommunity0ContainerScrollChild
	local el1 = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelCommunity", sc, "DynamicScrollPageCommunity", 0)

	-- Convalida
	TamrielUnlimitedIT.Convalida = CreateControlFromVirtual("DynamicLabel_stampataConvalida", ConvalidaPanelMainMenu, "DynamicTextConvalida", 0)
	TamrielUnlimitedIT.Convalida:SetAnchor(TOP, ConvalidaPanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Convalida:SetHidden(false)
	local sc = DynamicLabel_stampataConvalida0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPageConvalida = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelConvalida", sc, "DynamicScrollPageConvalida", 0)
	LoadConvalida()


	-- Contributori
	TamrielUnlimitedIT.Contributori = CreateControlFromVirtual("DynamicLabel_stampataContributori", ContributoriPanelMainMenu, "DynamicTextContributori", 0)
	TamrielUnlimitedIT.Contributori:SetAnchor(TOP, ContributoriPanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.Contributori:SetHidden(false)
	local sc = DynamicLabel_stampataContributori0ContainerScrollChild
	local el1 = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelContributori", sc, "DynamicScrollPageContributori", 0)

	-- DettagliUtente
	TamrielUnlimitedIT.DettagliUtente = CreateControlFromVirtual("DynamicLabel_stampataDettagliUtente", DettagliUtentePanelMainMenu, "DynamicTextDettagliUtente", 0)
	TamrielUnlimitedIT.DettagliUtente:SetAnchor(TOP, DettagliUtentePanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.DettagliUtente:SetHidden(false)
	local sc = DynamicLabel_stampataDettagliUtente0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPageDettagliUtente = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelDettagliUtente", sc, "DynamicScrollPageDettagliUtente", 0)

	TamrielUnlimitedIT.CreateScene()
end
function TamrielUnlimitedIT.CreateScene()

	-- Creazione stringhe
	ZO_CreateStringId("SI_TUI_NOME_ADDON", "Tamriel Unlimited IT")
	ZO_CreateStringId("SI_TUI_UTENTI", "Utenti")
	ZO_CreateStringId("SI_TUI_GILDE", "Gilde")
	ZO_CreateStringId("SI_TUI_EVENTI", "Eventi")
	ZO_CreateStringId("SI_TUI_COMMUNITY", "Community")
	ZO_CreateStringId("SI_TUI_CONVALIDA", "Convalida")
	ZO_CreateStringId("SI_TUI_CONTRIBUTORI", "Contributori")
	ZO_CreateStringId("SI_TUI_DETTAGLI_UTENTE", "Dettagli Utente")
	ZO_CreateStringId("SI_BINDING_NAME_TUI_SHOW_PANEL", "Apri TamrielUnlimitedIT")

	-- Creazione Array dati per icona nel menu
	TUI_MAIN_MENU_CATEGORY_DATA =
	{
		descriptor = 1,
		binding = "TUI_SHOW_PANEL",
		categoryName = SI_TUI_NOME_ADDON,
		normal = "TamrielUnlimitedIT/Textures/TamrielUnlimited_up.dds",
		pressed = "TamrielUnlimitedIT/Textures/TamrielUnlimited_down.dds",
		highlight = "TamrielUnlimitedIT/Textures/TamrielUnlimited_over.dds",
		callback = function ()
			ZO_MenuBar_ClearSelection(MAIN_MENU_KEYBOARD.categoryBar)

			if (TamrielUnlimitedIT.BackToMainPage) then
				TamrielUnlimitedIT.LMM:Update(TamrielUnlimitedIT.MENU_CATEGORY_TUI, "TuiUtenti")
				TamrielUnlimitedIT.BackToMainPage = false
			else
				TamrielUnlimitedIT.LMM:ToggleCategory(TamrielUnlimitedIT.MENU_CATEGORY_TUI)
			end
			ZO_MainMenuCategoryBarButton1:SetMouseEnabled(false)
		end
	}

	-- Creazione Scena Principale - Utenti
	TUI_SCENE_UTENTI = ZO_Scene:New("TuiUtenti", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_UTENTI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_UTENTI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_UTENTI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_UTENTI:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_UTENTI:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_UTENTI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_UTENTI_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_UTENTI)
	TUI_SCENE_UTENTI:AddFragment(TUI_UTENTI_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	UtentiPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	TUI_UTENTI_WINDOW = ZO_FadeSceneFragment:New(UtentiPanelMainMenu)
	TUI_SCENE_UTENTI:AddFragment(TUI_UTENTI_WINDOW)

	TUI_MENU_BAR = ZO_FadeSceneFragment:New(ZO_MainMenuCategoryBar)
	TUI_SCENE_UTENTI:AddFragment(TUI_MENU_BAR)

	TUI_SCENE_UTENTI:RegisterCallback("StateChange", function (oldState, newState)
			if newState == SCENE_FRAGMENT_HIDDEN then
				ChiudiAddRemoveFriend()
			end
		end)

	-- Creazione Scena - Gilde
	TUI_SCENE_GILDE = ZO_Scene:New("TuiGilde", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_GILDE:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_GILDE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_GILDE:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_GILDE:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_GILDE:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_GILDE:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_GILDE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_GILDE) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_GILDE:AddFragment(TUI_GILDE_TITLE_FRAGMENT)
	GildePanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUI_GILDE_WINDOW = ZO_FadeSceneFragment:New(GildePanelMainMenu)
	TUI_SCENE_GILDE:AddFragment(TUI_GILDE_WINDOW)

	TUI_SCENE_GILDE:AddFragment(TUI_MENU_BAR)

	TUI_SCENE_GILDE:RegisterCallback("StateChange", function (oldState, newState)
			if newState == SCENE_FRAGMENT_HIDDEN then
				ChiudiAddRemoveFriend()
			end
		end)


	-- Creazione Scena - EVENTI
	TUI_SCENE_EVENTI = ZO_Scene:New("TuiEventi", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_EVENTI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_EVENTI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_EVENTI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_EVENTI:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_EVENTI:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_EVENTI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_EVENTI_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_EVENTI) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_EVENTI:AddFragment(TUI_EVENTI_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	EventiPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	TUI_EVENTI_WINDOW = ZO_FadeSceneFragment:New(EventiPanelMainMenu)
	TUI_SCENE_EVENTI:AddFragment(TUI_EVENTI_WINDOW)

	TUI_SCENE_EVENTI:AddFragment(TUI_MENU_BAR)

	-- Creazione Scena - COMMUNITY
	TUI_SCENE_COMMUNITY = ZO_Scene:New("TuiCommunity", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_COMMUNITY:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_COMMUNITY:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_COMMUNITY:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_COMMUNITY:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_COMMUNITY_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_COMMUNITY) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_COMMUNITY:AddFragment(TUI_COMMUNITY_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	CommunityPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	TUI_COMMUNITY_WINDOW = ZO_FadeSceneFragment:New(CommunityPanelMainMenu)
	TUI_SCENE_COMMUNITY:AddFragment(TUI_COMMUNITY_WINDOW)

	TUI_SCENE_COMMUNITY:AddFragment(TUI_MENU_BAR)

	-- Creazione Scena - CONVALIDA
	TUI_SCENE_CONVALIDA = ZO_Scene:New("TuiConvalida", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_CONVALIDA:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_CONVALIDA:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_CONVALIDA:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_CONVALIDA:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_CONVALIDA_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_CONVALIDA) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_CONVALIDA:AddFragment(TUI_CONVALIDA_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	ConvalidaPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	TUI_CONVALIDA_WINDOW = ZO_FadeSceneFragment:New(ConvalidaPanelMainMenu)
	TUI_SCENE_CONVALIDA:AddFragment(TUI_CONVALIDA_WINDOW)

	TUI_SCENE_CONVALIDA:AddFragment(TUI_MENU_BAR)

	-- Creazione Scena - CONTRIBUTORI
	TUI_SCENE_CONTRIBUTORI = ZO_Scene:New("TuiContributori", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_CONTRIBUTORI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_CONTRIBUTORI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_CONTRIBUTORI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_CONTRIBUTORI:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_CONTRIBUTORI:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_CONTRIBUTORI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_CONTRIBUTORI_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_CONTRIBUTORI) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_CONTRIBUTORI:AddFragment(TUI_CONTRIBUTORI_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	ContributoriPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	TUI_CONTRIBUTORI_WINDOW = ZO_FadeSceneFragment:New(ContributoriPanelMainMenu)
	TUI_SCENE_CONTRIBUTORI:AddFragment(TUI_CONTRIBUTORI_WINDOW)

	TUI_SCENE_CONTRIBUTORI:AddFragment(TUI_MENU_BAR)

	-- Creazione Scena - DETTAGLI_UTENTE
	TUI_SCENE_DETTAGLI_UTENTE = ZO_Scene:New("TuiDettagliUtente", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_DETTAGLI_UTENTE:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_DETTAGLI_UTENTE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_DETTAGLI_UTENTE:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_DETTAGLI_UTENTE_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_DETTAGLI_UTENTE) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(TUI_DETTAGLI_UTENTE_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	DettagliUtentePanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	TUI_DETTAGLI_UTENTE_WINDOW = ZO_FadeSceneFragment:New(DettagliUtentePanelMainMenu)
	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(TUI_DETTAGLI_UTENTE_WINDOW)

	TUI_SCENE_DETTAGLI_UTENTE:AddFragment(TUI_MENU_BAR)

	do
		local iconData = {
			{
				categoryName = SI_TUI_UTENTI, -- Titolo vicino ai bottoni
				descriptor = "TuiUtenti",
				normal = "EsoUI/art/mainmenu/menubar_social_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_social_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_social_over.dds",
			},
			{
				categoryName = SI_TUI_GILDE, -- Titolo vicino ai bottoni
				descriptor = "TuiGilde",
				normal = "EsoUI/art/mainmenu/menubar_guilds_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_guilds_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_guilds_over.dds",
			},
			{
				categoryName = SI_TUI_EVENTI, -- Titolo vicino ai bottoni
				descriptor = "TuiEventi",
				normal = "EsoUI/art/guild/tabicon_roster_up.dds",
				pressed = "EsoUI/art/guild/tabicon_roster_down.dds",
				highlight = "EsoUI/art/guild/tabicon_roster_over.dds",
			},
			{
				categoryName = SI_TUI_COMMUNITY, -- Titolo vicino ai bottoni
				descriptor = "TuiCommunity",
				normal = "EsoUI/art/mainmenu/menubar_voip_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_voip_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_voip_over.dds",
			},

			{
				categoryName = SI_TUI_CONVALIDA, -- Titolo vicino ai bottoni
				descriptor = "TuiConvalida",
				normal = "EsoUI/art/guild/guildheraldry_indexicon_finalize_up.dds",
				pressed = "EsoUI/art/guild/guildheraldry_indexicon_finalize_down.dds",
				highlight = "EsoUI/art/guild/guildheraldry_indexicon_finalize_over.dds",
			},
		}

		-- Registrazione scene in gruppo
		SCENE_MANAGER:AddSceneGroup("TuiSceneGroup", ZO_SceneGroup:New("TuiUtenti", "TuiGilde", "TuiEventi", "TuiCommunity", "TuiConvalida", "TuiContributori", "TuiDettagliUtente"))

		-- Aggiunge la categoria al menu in alto ( in teoria )
		TamrielUnlimitedIT.MENU_CATEGORY_TUI = TamrielUnlimitedIT.LMM:AddCategory(TUI_MAIN_MENU_CATEGORY_DATA)

		-- Registra il gruppo e aggiunge i bottoni/label
		TamrielUnlimitedIT.LMM:AddSceneGroup(TamrielUnlimitedIT.MENU_CATEGORY_TUI, "TuiSceneGroup", iconData)


		local LMMXML = WINDOW_MANAGER:CreateControl("LMMXML2", ZO_MainMenuCategoryBar, CT_BUTTON)
		LMMXML:SetAnchor(CENTER, ZO_MainMenuCategoryBar, nil, 0, 28)
		TamrielUnlimitedIT.categoryBar = CreateControlFromVirtual("$(parent)CategoryBar", LMMXML2, "ZO_MenuBarTemplate")
		TamrielUnlimitedIT.categoryBar:SetAnchor(RIGHT, ZO_MainMenuCategoryBarButton1, LEFT, -70, 0)

		local categoryBarData =
		{
			buttonPadding = 16,
			normalSize = 51,
			downSize = 64,
			animationDuration = DEFAULT_SCENE_TRANSITION_TIME,
			buttonTemplate = "ZO_MainMenuCategoryBarButton",
		}
		ZO_MenuBar_SetData(TamrielUnlimitedIT.categoryBar, categoryBarData)

		ZO_MenuBar_AddButton(TamrielUnlimitedIT.categoryBar, TUI_MAIN_MENU_CATEGORY_DATA)

		local MieTab = SCENE_MANAGER:GetSceneGroup("TuiSceneGroup").scenes
		local MieTabNotBackToMainPage = {"TuiUtenti", "TuiGilde", "TuiEventi", "TuiCommunity", "TuiConvalida"}

		ListaKeyBinding = {}


		for layerIndex = 1, GetNumActionLayers() do
			local layerName, numCategories = GetActionLayerInfo(layerIndex)
			local layerId = nil
			for categoryIndex = 1, numCategories do
				local categoryName, numActions = GetActionLayerCategoryInfo(layerIndex, categoryIndex)
				local categoryId = nil
				for actionIndex = 1, numActions do
					local actionName, isRebindable, isHidden = GetActionInfo(layerIndex, categoryIndex, actionIndex)
					local key, mod1, mod2, mod3, mod4 = GetActionBindingInfo(layerIndex, categoryIndex, actionIndex, 1)
					ListaKeyBinding[key] = GetActionNameFromKey(layerName, key)
				end
			end
		end


		UtentiPanelMainMenu:SetKeyboardEnabled(true)
		UtentiPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)

		GildePanelMainMenu:SetKeyboardEnabled(true)
		GildePanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)

		EventiPanelMainMenu:SetKeyboardEnabled(true)
		EventiPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)


		CommunityPanelMainMenu:SetKeyboardEnabled(true)
		CommunityPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)

		ConvalidaPanelMainMenu:SetKeyboardEnabled(true)
		ConvalidaPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)

		ContributoriPanelMainMenu:SetKeyboardEnabled(true)
		ContributoriPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
				if (ListaKeyBinding[key] ~= nil) then
					SCENE_MANAGER:ShowBaseScene()
					ChiudiAddRemoveFriend()
				end
				return false
			end)

		SCENE_MANAGER:RegisterCallback("SceneStateChanged", function (scene, oldState, newState)
				if (inTable(MieTabNotBackToMainPage, scene.name) and newState == SCENE_FRAGMENT_SHOWING) then
					TamrielUnlimitedIT.BackToMainPage = false
				end

				if not inTable(MieTab, scene.name) and newState == SCENE_FRAGMENT_SHOWING then
					ZO_MainMenuCategoryBarButton1:SetMouseEnabled(true)
					ZO_MenuBar_ClearSelection(TamrielUnlimitedIT.categoryBar)

				end
			end)
	end
end




-- LISTA PLAYER


function ClearArrayPlayerTemp()
	for k in pairs(TamrielUnlimitedIT.PlayerTemp) do
		TamrielUnlimitedIT.PlayerTemp[k] = nil
	end
end
function LoadArrayPlayerTemp()
	ClearArrayPlayerTemp()
	TamrielUnlimitedIT.PlayerTemp = deepcopy(TUitDataVar.Player)
end
function LoadArrayPlayerTemp_NamePattern(Pattern)

	if Pattern == "" then
		LoadArrayPlayerTemp()
	else
		ClearArrayPlayerTemp()
		local c = 1
		for i = 1, #TUitDataVar.Player do
			if string.find(TUitDataVar.Player[i]["pg_name"], Pattern) ~= nil then
				TamrielUnlimitedIT.PlayerTemp[c] = deepcopy(TUitDataVar.Player[i])
				c = c + 1
			end
		end

	end

end
function CercaPlayer(Pattern)
	LoadArrayPlayerTemp_NamePattern(Pattern)
	SortCP()
end

function LoadPlayeList()
	ChiudiAddRemoveFriend()

	TamrielUnlimitedIT.DynamicScrollPagePlayer:SetDimensions(900, 20 * #TamrielUnlimitedIT.PlayerTemp + 50)
	TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Tabella"):SetDimensions(900, 20 * #TamrielUnlimitedIT.PlayerTemp + 50)

	local el1 = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Tabella")
	local pre = el1:GetNamedChild("stampa_Row0")
	local searchcontrol = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Search_control")
	local searchbtn = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Search_btn")
	
	pre:GetNamedChild("NOPG"):SetHidden(true)
	searchcontrol:SetHidden(false)
	searchbtn:SetHidden(false)
	pre:GetNamedChild("Colonna0"):SetHidden(false)
	pre:GetNamedChild("Colonna1"):SetHidden(false)
	pre:GetNamedChild("Colonna2"):SetHidden(false)
	pre:GetNamedChild("Colonna3"):SetHidden(false)
	pre:GetNamedChild("Colonna4"):SetHidden(false)
	pre:GetNamedChild("Colonna5"):SetHidden(false)
	pre:GetNamedChild("Colonna6"):SetHidden(false)

	local i = 1
	while i <= #TamrielUnlimitedIT.PlayerTemp do
		local v1 = el1:GetNamedChild("Dynamic_stampa_Row" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Row", el1, "DynamicRow", i)
		end

		v1:SetDimensions(900, 20)
		v1:SetHidden(false)
		v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 0)
		v1:GetNamedChild("Colonna0Label"):SetText(TamrielUnlimitedIT.PlayerTemp[i]["lev"])
		v1:GetNamedChild("Colonna1Label"):SetText(TamrielUnlimitedIT.PlayerTemp[i]["CP"])
		v1:GetNamedChild("Colonna2Label"):SetText(GetString("SI_GENDER", TamrielUnlimitedIT.PlayerTemp[i]["sex"]))
		v1:GetNamedChild("Colonna3bttn_friendLabel"):SetText(TamrielUnlimitedIT.PlayerTemp[i]["pg_name"])
		v1:GetNamedChild("Colonna3bttn_friendLabel"):SetColor(0, 186, 255, 1)
		v1:GetNamedChild("Colonna3bttn_friendLabel_UserID"):SetText(TamrielUnlimitedIT.PlayerTemp[i]["userid"])
		v1:GetNamedChild("Colonna4Label"):SetText(zo_strformat(SI_RACE_NAME, GetRaceName(TamrielUnlimitedIT.PlayerTemp[i]["sex"], TamrielUnlimitedIT.PlayerTemp[i]["race"])))
		v1:GetNamedChild("Colonna5Label"):SetText(zo_strformat(SI_CLASS_NAME, GetClassName(TamrielUnlimitedIT.PlayerTemp[i]["sex"], TamrielUnlimitedIT.PlayerTemp[i]["class"])))
		v1:GetNamedChild("Colonna6Label"):SetText(zo_strformat(GetString("SI_ALLIANCE", TamrielUnlimitedIT.PlayerTemp[i]["alli"])))

		if TamrielUnlimitedIT.PlayerTemp[i]["alli"] == 2 then
			v1:GetNamedChild("Colonna6Label"):SetColor(0.647, 0.141, 0.101, 1)
		elseif TamrielUnlimitedIT.PlayerTemp[i]["alli"] == 1 then
			v1:GetNamedChild("Colonna6Label"):SetColor(0.686, 0.596, 0.223, 1)
		else
			v1:GetNamedChild("Colonna6Label"):SetColor(0.156, 0.352, 0.631, 1)
		end

		pre = v1
		i = i + 1
	end


	local ii = i
	while ii <= #TUitDataVar.Player do
		local v1 = el1:GetNamedChild("Dynamic_stampa_Row" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end
end

function LoadNoPlayer()
	
	local el1 = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Tabella")
	local pre = el1:GetNamedChild("stampa_Row0")
	local searchcontrol = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Search_control")
	local searchbtn = TamrielUnlimitedIT.DynamicScrollPagePlayer:GetNamedChild("Search_btn")
	
	pre:GetNamedChild("NOPG"):SetHidden(false)
	searchcontrol:SetHidden(true)
	searchbtn:SetHidden(true)
	pre:GetNamedChild("Colonna0"):SetHidden(true)
	pre:GetNamedChild("Colonna1"):SetHidden(true)
	pre:GetNamedChild("Colonna2"):SetHidden(true)
	pre:GetNamedChild("Colonna3"):SetHidden(true)
	pre:GetNamedChild("Colonna4"):SetHidden(true)
	pre:GetNamedChild("Colonna5"):SetHidden(true)
	pre:GetNamedChild("Colonna6"):SetHidden(true)
		
	pre:GetNamedChild("NOPGLabel"):SetText("Non è stato scaricato alcun dato!")
	
end

-- SORTING

function SortLiv()

	if TamrielUnlimitedIT.CurrPlayerSort == "LivDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "LivAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, CheckLivAsc)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "LivDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, CheckLivDesc)
	end

	LoadPlayeList()
end
function SortCP()

	if TamrielUnlimitedIT.CurrPlayerSort == "CPDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "CPAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["CP"] == v2["CP"]) then return CheckLivAsc(v1, v2) end return v1["CP"] <= v2["CP"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "CPDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["CP"] == v2["CP"]) then return CheckLivDesc(v1, v2) end return v2["CP"] <= v1["CP"] end)
	end

	LoadPlayeList()
end
function SortSesso()
	if TamrielUnlimitedIT.CurrPlayerSort == "SessoDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "SessoAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["sex"] == v2["sex"]) then return CheckLivAsc(v1, v2) end return v1["sex"] <= v2["sex"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "SessoDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["sex"] == v2["sex"]) then return CheckLivDesc(v1, v2) end return v2["sex"] <= v1["sex"] end)
	end

	LoadPlayeList()
end
function SortUser()
	if TamrielUnlimitedIT.CurrPlayerSort == "UserDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "UserAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["pg_name"] == v2["pg_name"]) then return CheckLivAsc(v1, v2) end return v1["pg_name"] <= v2["pg_name"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "UserDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["pg_name"] == v2["pg_name"]) then return CheckLivDesc(v1, v2) end return v2["pg_name"] <= v1["pg_name"] end)
	end

	LoadPlayeList()
end
function SortRace()
	if TamrielUnlimitedIT.CurrPlayerSort == "RaceDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "RaceAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["race"] == v2["race"]) then return CheckLivAsc(v1, v2) end return v1["race"] <= v2["race"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "RaceDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["race"] == v2["race"]) then return CheckLivDesc(v1, v2) end return v2["race"] <= v1["race"] end)
	end

	LoadPlayeList()
end
function SortClass()
	if TamrielUnlimitedIT.CurrPlayerSort == "ClassDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "ClassAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["class"] == v2["class"]) then return CheckLivAsc(v1, v2) end return v1["class"] <= v2["class"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "ClassDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["class"] == v2["class"]) then return CheckLivDesc(v1, v2) end return v2["class"] <= v1["class"] end)
	end

	LoadPlayeList()
end
function SortFazione()
	if TamrielUnlimitedIT.CurrPlayerSort == "FazioneDesc" then
		TamrielUnlimitedIT.CurrPlayerSort = "FazioneAsc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["alli"] == v2["alli"]) then return CheckLivAsc(v1, v2) end return v1["alli"] <= v2["alli"] end)
	else
		TamrielUnlimitedIT.CurrPlayerSort = "FazioneDesc"
		quicksort(TamrielUnlimitedIT.PlayerTemp, function (v1, v2) if (v1["alli"] == v2["alli"]) then return CheckLivDesc(v1, v2) end return v2["alli"] <= v1["alli"] end)
	end

	LoadPlayeList()
end

function CheckLivAsc(v1, v2)

	-- v1<=v2
	if string.starts(v1["lev"], "VR") then
		if string.starts(v2["lev"], "VR") then
			return tonumber(string.sub(v1["lev"], 3)) <= tonumber(string.sub(v2["lev"], 3))
		else
			return false;
		end
	elseif string.starts(v2["lev"], "VR") then
		return true;
	else

		return tonumber(v1["lev"]) <= tonumber(v2["lev"])
	end
end
function CheckLivDesc(v1, v2)

	-- v2<=v1
	if string.starts(v2["lev"], "VR") then
		if string.starts(v1["lev"], "VR") then
			return tonumber(string.sub(v2["lev"], 3)) <= tonumber(string.sub(v1["lev"], 3))
		else
			return false;
		end
	elseif string.starts(v1["lev"], "VR") then
		return true;
	else

		return tonumber(v2["lev"]) <= tonumber(v1["lev"])
	end

end

-- CONTROLLI MENU' A TENDINA

function ApriMenuPlayer(self, button, BackPage)

	if button == 1 or GetUnitName("player") == self:GetNamedChild("Label"):GetText() then
		-- ChiudiAddRemoveFriend() -- Blocca il menu a tendina
		AddRemoveControl:SetHidden(false)
		AddRemoveControlAddFriend:SetEnabled(false)
		AddRemoveControlAddFriendLabel_AddFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlRemoveFriend:SetEnabled(false)
		AddRemoveControlRemoveFriendLabel_RemoveFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlInviaMail:SetEnabled(false)
		AddRemoveControlInviaMailLabel_SendMailFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlBisbiglia:SetEnabled(false)
		AddRemoveControlBisbigliaLabel_WhisperFriend:SetColor(0.5, 0.5, 0.5, 1)

		AddRemoveControlLabel_NomeAdd:SetText(self:GetNamedChild("Label"):GetText()) -- Aggiunge il nome PG
		AddRemoveControlDettagliUserIDLabel_DettagliUserID:SetText(self:GetNamedChild("Label_UserID"):GetText()) -- Aggiunge UserID alla voce dettagli

		AddRemoveControl:ClearAnchors()
		local mouseX, mouseY = GetUIMousePosition()
		AddRemoveControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, mouseX, mouseY)

		AddRemoveControlLabel_CallPage:SetText(BackPage)

	else
		AddRemoveControl:SetHidden(false)

		if IsFriend(self:GetNamedChild("Label"):GetText()) then
			AddRemoveControlAddFriend:SetEnabled(false)
			AddRemoveControlRemoveFriend:SetEnabled(true)
			AddRemoveControlAddFriendLabel_AddFriend:SetColor(0.5, 0.5, 0.5, 1)
			AddRemoveControlRemoveFriendLabel_RemoveFriend:SetColor(1, 1, 1, 1)


		else
			AddRemoveControlAddFriend:SetEnabled(true)
			AddRemoveControlRemoveFriend:SetEnabled(false)
			AddRemoveControlAddFriendLabel_AddFriend:SetColor(1, 1, 1, 1)
			AddRemoveControlRemoveFriendLabel_RemoveFriend:SetColor(0.5, 0.5, 0.5, 1)

		end

		AddRemoveControlLabel_NomeAdd:SetText(self:GetNamedChild("Label"):GetText()) -- Aggiunge il nome PG
		AddRemoveControlDettagliUserIDLabel_DettagliUserID:SetText(self:GetNamedChild("Label_UserID"):GetText()) -- Aggiunge UserID alla voce dettagli

		AddRemoveControl:ClearAnchors()
		local mouseX, mouseY = GetUIMousePosition()
		AddRemoveControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, mouseX, mouseY)

		AddRemoveControlLabel_CallPage:SetText(BackPage)

	end
end
function MouseDownGenerale()
	ChiudiAddRemoveFriend()
end
function ChiudiAddRemoveFriend()
	AddRemoveControl:SetHidden(true)
end
function AggiungiAmico(self)
	RequestFriend(self:GetParent():GetNamedChild("Label_NomeAdd"):GetText(), "")
	d("Richiesta Inviata")
	ChiudiAddRemoveFriend()
end
function RimuoviAmico(self)
	RemoveFriend(self:GetParent():GetNamedChild("Label_NomeAdd"):GetText())
	d("Amico Rimosso")
	ChiudiAddRemoveFriend()
end
function InviaMail(self)
	MAIL_SEND:ComposeMailTo(self:GetParent():GetNamedChild("Label_NomeAdd"):GetText())
	ChiudiAddRemoveFriend()
end
function Bisbiglia(self)
	StartChatInput("", CHAT_CHANNEL_WHISPER, self:GetParent():GetNamedChild("Label_NomeAdd"):GetText())
	ChiudiAddRemoveFriend()
end
function ApriDettagliPlayer(self, BackPage)
	local DettagliArray = TamrielUnlimitedIT.TUitDataVar.PlayersData[self:GetNamedChild("Label_DettagliUserID"):GetText()]
	if (DettagliArray == nil) then
		d("Nessuna informazione trovata per questo valore")
	else
		TamrielUnlimitedIT.BackToMainPage = true

		local pre = TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTesto")

		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTesto"):SetDimensions(900, (tablelength(DettagliArray.PG) - 1) * 100)

		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoUserID"):SetText(self:GetNamedChild("Label_DettagliUserID"):GetText())
		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoRiga5Label_BackPage"):SetText(BackPage)

		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoGildeList"):SetText("")

		if (tablelength(DettagliArray["Guilds"]) ~= 0) then
			for key, value in pairs(DettagliArray["Guilds"]) do
				TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoGilde"):SetText("Gilde")
				TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoGildeList"):SetText(TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoGildeList"):GetText() .. "- " .. value .. "\r\n")
			end
		else
			TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoGildeList"):SetText("- L'utente non fa parte di alcuna gilda!")
		end

		local el1 = TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoContUserDinamici")
		local pre = el1:GetNamedChild("pre")

		--[[ for key, value in pairs(DettagliArray) do
		d(key, value) end ]]--
		-- #Test per verificare il corretto costruttore di tabelle

		local i = 1

		for key, value in pairs(DettagliArray) do
			if (key~="Guilds" and key~="CP") then
				for key1, value1 in pairs(value) do

					local v1 = el1:GetNamedChild("Dynamic_stampa_Row_User" .. i)

					alli = TamrielUnlimitedIT.PlayerTemp[i]["alli"]
					sex = TamrielUnlimitedIT.PlayerTemp[i]["sex"]
					race = TamrielUnlimitedIT.PlayerTemp[i]["race"]
					class = TamrielUnlimitedIT.PlayerTemp[i]["class"]

					if v1 == nil then
						v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Row_User", el1, "DynamicRowDettagliUtente", i)
					end

					v1:SetDimensions(800, 80)
					v1:SetHidden(false)
					v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 20)

					local TextAlli = ""
					if value1.alli == 2 then
						TextAlli = "|ca4231a" .. zo_strformat(GetString("SI_ALLIANCE", value1.alli)) .. "|r"
					elseif value1.alli == 1 then
						TextAlli = "|caf9839" .. zo_strformat(GetString("SI_ALLIANCE", value1.alli)) .. "|r"
					else
						TextAlli = "|c285aa1" .. zo_strformat(GetString("SI_ALLIANCE", value1.alli)) .. "|r"
					end

					v1:GetNamedChild("NomePG"):SetText(key1)
					v1:GetNamedChild("Alleanza"):SetText(TextAlli)
					v1:GetNamedChild("Liv"):SetText("Livello: " .. value1.lev)
					v1:GetNamedChild("CP"):SetText("CP: " .. DettagliArray.CP)
					v1:GetNamedChild("Sex"):SetText("Sesso: " .. GetString("SI_GENDER", value1.sex))
					v1:GetNamedChild("Race"):SetText("Razza: " .. zo_strformat(SI_RACE_NAME, GetRaceName(value1.sex, value1.race)))
					v1:GetNamedChild("Class"):SetText("Classe: " .. zo_strformat(SI_CLASS_NAME, GetClassName(value1.sex, value1.class)))

					pre = v1
					i = i + 1
					
				end
			end
		end

		local ii = i
		while el1:GetNamedChild("Dynamic_stampa_Row_User" .. ii) ~= nil do
			local v1 = el1:GetNamedChild("Dynamic_stampa_Row_User" .. ii)
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
			ii = ii + 1
		end

		TamrielUnlimitedIT.LMM:Update(TamrielUnlimitedIT.MENU_CATEGORY_TUI, "TuiDettagliUtente")

	end

end



-- EVENTI

TamrielUnlimitedIT.CalculateRepeatsEvents = function ()

	local NumeroMaxRipetizioniSeNonSettate = 5
	ArrTemp = {}
	local CurrentTimeStamp = GetTimeStamp() + 7200


	for i = 1, #TamrielUnlimitedIT.TUitDataVar.Events do

		if (TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"] ~= "" and TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"] ~= nil) then
			local ArrRepTemp = {}
			local T1 = explode(";", TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"])
			for ii = 1, #T1 do
				local T2 = explode("=", T1[ii])
				ArrRepTemp[T2[1]] = T2[2]
			end


			if (ArrRepTemp["FREQ"] ~= nil) then

				if (ArrRepTemp["FREQ"] == "DAILY") then
					-- GIORNALIERO
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])

						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]


							while (lastITS < DataTermineTS) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end
							end


						elseif (ArrRepTemp["COUNT"] ~= nil) then


							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end

							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)


								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "WEEKLY") then
					-- SETTIMANALE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])

						if (ArrRepTemp["BYDAY"] ~= nil) then

							ArrRepTemp["BYDAY"] = explode(",", ArrRepTemp["BYDAY"])



							if (ArrRepTemp["UNTIL"] ~= nil) then
								-- DATA TERMINE
								-- 20150729T220000
								DatTermine = {}
								DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
								DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
								DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
								DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
								DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
								DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

								DataTermineTS = DateToTimestamp(DatTermine)
								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								local cc = 1


								while (lastITS < DataTermineTS) do

									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)
									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)
									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end


									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end


							elseif (ArrRepTemp["COUNT"] ~= nil) then


								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								local cc = 1
								-- NUMERO DI RIPETIZIONI
								for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)



									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end

									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end
							else

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]
								local cc = 1

								-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)

								local iii = 1

								while (iii <= NumeroMaxRipetizioniSeNonSettate) do


									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)


									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
										iii = iii + 1
									end

									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end
							end



						else

							if (ArrRepTemp["UNTIL"] ~= nil) then
								-- DATA TERMINE
								-- 20150729T220000
								DatTermine = {}
								DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
								DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
								DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
								DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
								DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
								DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

								DataTermineTS = DateToTimestamp(DatTermine)
								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]


								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end


							elseif (ArrRepTemp["COUNT"] ~= nil) then


								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								-- NUMERO DI RIPETIZIONI
								for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)

									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end


								end
							else

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
								local iii = 1

								while (iii <= NumeroMaxRipetizioniSeNonSettate) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)


									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
										iii = iii + 1
									end
								end
							end

						end
					end


					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "MONTHLY") then
					-- MENSILE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])

						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							if (DataTermineTS > CurrentTimeStamp) then
								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddMonth(tt1, interval)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddMonth(tt2, interval)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end
							end

						elseif (ArrRepTemp["COUNT"] ~= nil) then


							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddMonth(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddMonth(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end


							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddMonth(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddMonth(tt2, interval)
								lastFTS = DateToTimestamp(tt2)


								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "YEARLY") then
					-- ANNUALE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])

						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							if (DataTermineTS > CurrentTimeStamp) then
								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddYear(tt1, interval)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddYear(tt2, interval)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end
							end

						elseif (ArrRepTemp["COUNT"] ~= nil) then


							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddYear(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddYear(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end


							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddYear(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddYear(tt2, interval)
								lastFTS = DateToTimestamp(tt2)


								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end

				end
			end


		end
	end


	for i = 1, #ArrTemp do
		TamrielUnlimitedIT.TUitDataVar.Events[#TamrielUnlimitedIT.TUitDataVar.Events + 1] = ArrTemp[i]
	end

	-- AddErr(TamrielUnlimitedIT.TUitDataVar.Events)
	-- zo_loadstring("d(\"test\"")()


end

function SortEventi()
	quicksort(TamrielUnlimitedIT.TUitDataVar.Events, function (v1, v2) return v1[1] <= v2[1] end)
end


function LoadEventi()
	el1 = TamrielUnlimitedIT.DynamicScrollPageEventi
	eventMessage = TamrielUnlimitedIT.DynamicScrollPageEventiMessage
	
	if TamrielUnlimitedIT.EventTemp ~= nil then
		if #TamrielUnlimitedIT.EventTemp ~= 0 then
			TamrielUnlimitedIT.CalculateRepeatsEvents()
			--SortEventi()
			LoadEventiList()
		else
			LoadNoEventi()
		end
	else
		LoadNoEventi()
	end
end

function LoadNoEventi()
	eventMessage:SetHidden(false)
	el1:SetHidden(true)
	eventMessage:GetNamedChild("Label"):SetText("Non è stato scaricato alcun dato!")
end
function LoadEventiList()

	local AltezzaComponente = 120
	
	eventMessage:SetHidden(true)
	el1:SetHidden(false)
	
	local pre = el1:GetNamedChild("Label")

	local CurrentTimeStamp = GetTimeStamp() + 7200

	local counterControl = 1


	for i = 1, #TamrielUnlimitedIT.TUitDataVar.Events do

		-- minore della fine
		if (CurrentTimeStamp < TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]) then

			local v1 = el1:GetNamedChild("Dynamic_stampa_Evento" .. counterControl)
			if v1 == nil then
				v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Evento", el1, "DynamicEvento", counterControl)
			end

			v1:SetDimensions(710, AltezzaComponente)
			v1:SetHidden(false)
			v1:SetAnchor(TOP, pre, BOTTOM, 0, 10)

			DInizio = TimestampToDate(TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"] + 3600)
			DFine = TimestampToDate(TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"] + 3600)

			local OrariTxt = DInizio.ora .. ":"
			if (DInizio.minuto < 10) then
				OrariTxt = OrariTxt .. "0"
			end
			OrariTxt = OrariTxt .. DInizio.minuto .. " - " .. DFine.ora .. ":"
			if (DFine.minuto < 10) then
				OrariTxt = OrariTxt .. "0"
			end
			OrariTxt = OrariTxt .. DFine.minuto


			v1:GetNamedChild("DataLabelGiornoMese"):SetText(DInizio.giorno .. "/" .. DInizio.mese)
			v1:GetNamedChild("DataLabelOrario"):SetText(OrariTxt)
			v1:GetNamedChild("TitoloLabel"):SetText(TamrielUnlimitedIT.TUitDataVar.Events[i]["title"])
			v1:GetNamedChild("TestoRiga1"):SetText(TamrielUnlimitedIT.TUitDataVar.Events[i]["description"])

			pre = v1
			counterControl = counterControl + 1


			-- minore dell'inizio
			if (CurrentTimeStamp < TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]) then
				local diff = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"] - CurrentTimeStamp
				local DDiff = TimestampToDate(diff)
				-- Controllo che l'evento è nelle successive 24 ore
				TamrielUnlimitedIT.ciao = "asd"
				if (diff < 86400) then
					-- Controllo che l'evento non inizia in meno di un ora

					zo_callLater(function ()
							TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento è appena iniziato!")
						end, diff * 1000)

					if (diff > 3600) then
						zo_callLater(function ()
								TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento inizierà tra 1 ora!")
							end, (diff - 3600) * 1000)
					end
					if (diff > 600) then
						zo_callLater(function ()
								TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento inizierà tra 10 minuti!")
							end, (diff - 600) * 1000)
					end


					if ((diff > 661 and diff < 3600) or (diff > 60 and diff < 600)) then
						if (DDiff.minuto == 1) then
							AddPreLoadEvent(TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento inizierà tra " .. DDiff.minuto .. " minuto!"))
						else
							AddPreLoadEvent(TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento inizierà tra " .. DDiff.minuto .. " minuti!"))
						end
					end

				end

			else
				AddPreLoadEvent(TamrielUnlimitedIT.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "è in corso in questo momento!"))
			end
		end


	end


	TamrielUnlimitedIT.DynamicScrollPageEventi:SetDimensions(900, AltezzaComponente * counterControl)


	local ii = counterControl
	while ii <= #TamrielUnlimitedIT.TUitDataVar.Events do
		local v1 = el1:GetNamedChild("Dynamic_stampa_Evento" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end

end

TamrielUnlimitedIT.ShowEventMessage = function (Titolo, Corpo)
	CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_DISPLAY_ANNOUNCEMENT, CSA_EVENT_COMBINED_TEXT, SOUNDS.OBJECTIVE_COMPLETED, Titolo, Corpo, 'TamrielUnlimitedIT/Textures/calendar.dds', nil, nil, nil, 6000, true)
end

-- GILDE

function LoadGilde()
	TamrielUnlimitedIT.GuildTemp = deepcopy(TUitDataVar.Guild)
	
	if TamrielUnlimitedIT.GuildTemp ~= nil then
		if #TamrielUnlimitedIT.GuildTemp ~= 0 then
			LoadGildeList()
		else
			LoadNOGilde()
		end
	else
		LoadNOGilde()
	end
end

function LoadNOGilde()
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("NOGuilds"):SetHidden(false)
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("AD"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("DC"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("EP"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("NOGuildsLabel"):SetText("Non è stato scaricato alcun dato!")
end
function LoadGildeList()
	
	TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("NOGuilds"):SetHidden(true)
	
	TamrielUnlimitedIT.GuildADTemp = deepcopy(TUitDataVar.GuildAD)
	TamrielUnlimitedIT.GuildDCTemp = deepcopy(TUitDataVar.GuildDC)
	TamrielUnlimitedIT.GuildEPTemp = deepcopy(TUitDataVar.GuildEP)

	AltezzaComponente = 180
	PaddingDopo = 20

	DimTotale = 0

	-- ALDMERI DOMINION
	elAD = TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("AD")
	elAD:SetHidden(false)
	preAD = elAD:GetNamedChild("Label")
	preAD:SetColor(0.686, 0.596, 0.223, 1)
	if TamrielUnlimitedIT.GuildADTemp ~= nil then
		if #TamrielUnlimitedIT.GuildADTemp ~= 0 then
			LoadGildeAD()
		else
			LoadNoGuildAD()
		end
	else
		LoadNoGuildAD()
	end

	-- DAGGERFALL COVENANT
	elDC = TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("DC")
	preDC = elDC:GetNamedChild("Label")
	preDC:SetColor(0.156, 0.352, 0.631, 1)
	if TamrielUnlimitedIT.GuildDCTemp ~= nil then
		if #TamrielUnlimitedIT.GuildDCTemp ~= 0 then
			LoadGildeDC()
		else
			LoadNoGuildDC()
		end
	else
		LoadNoGuildDC()
	end

	-- EBONHEART PACT
	elEP = TamrielUnlimitedIT.DynamicScrollPageGilde:GetNamedChild("EP")
	preEP = elEP:GetNamedChild("Label")
	preEP:SetColor(0.647, 0.141, 0.101, 1)
	if TamrielUnlimitedIT.GuildEPTemp ~= nil then
		if #TamrielUnlimitedIT.GuildEPTemp ~= 0 then
			LoadGildeEP()
		else
			LoadNoGuildEP()
		end
	else
		LoadNoGuildEP()
	end

	-- 280 somma delle altezze dei component prima di quelli dinamici
	TamrielUnlimitedIT.DynamicScrollPageGilde:SetDimensions(900, DimTotale + 280)

end

function LoadNoGuildAD()
	elAD:GetNamedChild("NoGuildAD"):SetHidden(false)
	elAD:GetNamedChild("NoGuildADLabel"):SetText("Nessuna gilda negli Aldmeri Dominion")
end

function LoadGildeAD()
	elAD:GetNamedChild("NoGuildAD"):SetHidden(true)
	DimTotale = DimTotale + (AltezzaComponente * #TamrielUnlimitedIT.GuildADTemp) + preAD:GetHeight() + PaddingDopo
	elAD:SetDimensions(710, (AltezzaComponente * #TamrielUnlimitedIT.GuildADTemp) + preAD:GetHeight() + PaddingDopo)


	local i = 1
	while i <= #TamrielUnlimitedIT.GuildADTemp do
		local v1 = elAD:GetNamedChild("Dynamic_stampa_Gilda_AD" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Gilda_AD", elAD, "DynamicGilda", i)
		end

		v1:SetDimensions(710, AltezzaComponente)
		v1:SetHidden(false)
		v1:SetAnchor(TOP, preAD, BOTTOM, 0, 10)


		v1:GetNamedChild("TitoloLabel"):SetText(TamrielUnlimitedIT.GuildADTemp[i]["guild_name"])
		v1:GetNamedChild("TestoEditBox"):SetText(TamrielUnlimitedIT.GuildADTemp[i]["description"])
		v1:GetNamedChild("LogoTexture"):SetTexture(TamrielUnlimitedIT.GuildADTemp[i]["image"])
		v1:GetNamedChild("GuildMasterBtnLabel"):SetText(TamrielUnlimitedIT.GuildADTemp[i]["guild_master"])
		v1:GetNamedChild("GuildMasterBtnLabel_UserID"):SetText(TamrielUnlimitedIT.GuildADTemp[i]["guild_master"])

		preAD = v1
		i = i + 1
	end

	local ii = i
	while ii <= #TamrielUnlimitedIT.GuildADTemp do
		local v1 = elAD:GetNamedChild("Dynamic_stampa_Gilda_AD" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end
end

function LoadNoGuildDC()
	elDC:GetNamedChild("NoGuildDC"):SetHidden(false)
	elDC:GetNamedChild("NoGuildDCLabel"):SetText("Nessuna gilda nei Daggerfall Covenant")
end
function LoadGildeDC()
	elDC:GetNamedChild("NoGuildDC"):SetHidden(true)
	DimTotale = DimTotale + (AltezzaComponente * #TamrielUnlimitedIT.GuildDCTemp) + preDC:GetHeight() + PaddingDopo
	elDC:SetDimensions(710, (AltezzaComponente * #TamrielUnlimitedIT.GuildDCTemp) + preDC:GetHeight() + PaddingDopo)

	local i = 1
	while i <= #TamrielUnlimitedIT.GuildDCTemp do
		local v1 = elDC:GetNamedChild("Dynamic_stampa_Gilda_DC" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Gilda_DC", elDC, "DynamicGilda", i)
		end

		v1:SetDimensions(710, AltezzaComponente)
		v1:SetHidden(false)
		v1:SetAnchor(TOP, preDC, BOTTOM, 0, 10)


		v1:GetNamedChild("TitoloLabel"):SetText(TamrielUnlimitedIT.GuildDCTemp[i]["guild_name"])
		v1:GetNamedChild("TestoEditBox"):SetText(TamrielUnlimitedIT.GuildDCTemp[i]["description"])
		v1:GetNamedChild("LogoTexture"):SetTexture(TamrielUnlimitedIT.GuildDCTemp[i]["image"])
		v1:GetNamedChild("GuildMasterBtnLabel"):SetText(TamrielUnlimitedIT.GuildDCTemp[i]["guild_master"])
		v1:GetNamedChild("GuildMasterBtnLabel_UserID"):SetText(TamrielUnlimitedIT.GuildDCTemp[i]["guild_master"])

		preDC = v1
		i = i + 1
	end

	local ii = i
	while ii <= #TamrielUnlimitedIT.GuildDCTemp do
		local v1 = elDC:GetNamedChild("Dynamic_stampa_Gilda_DC" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end
end

function LoadNoGuildEP()
	elEP:GetNamedChild("NoGuildEP"):SetHidden(false)
	elEP:GetNamedChild("NoGuildEPLabel"):SetText("Nessuna gilda negli Ebonheart Pact")
end
function LoadGildeEP()
	elEP:GetNamedChild("NoGuildEP"):SetHidden(true)
	DimTotale = DimTotale + (AltezzaComponente * #TamrielUnlimitedIT.GuildEPTemp) + preEP:GetHeight() + PaddingDopo
	elEP:SetDimensions(710, (AltezzaComponente * #TamrielUnlimitedIT.GuildEPTemp) + preEP:GetHeight() + PaddingDopo)

	local i = 1
	while i <= #TamrielUnlimitedIT.GuildEPTemp do
		local v1 = elEP:GetNamedChild("Dynamic_stampa_Gilda_EP" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Gilda_EP", elEP, "DynamicGilda", i)
		end

		v1:SetDimensions(710, AltezzaComponente)
		v1:SetHidden(false)
		v1:SetAnchor(TOP, preEP, BOTTOM, 0, 10)


		v1:GetNamedChild("TitoloLabel"):SetText(TamrielUnlimitedIT.GuildEPTemp[i]["guild_name"])
		v1:GetNamedChild("TestoEditBox"):SetText(TamrielUnlimitedIT.GuildEPTemp[i]["description"])
		v1:GetNamedChild("LogoTexture"):SetTexture(TamrielUnlimitedIT.GuildEPTemp[i]["image"])
		v1:GetNamedChild("GuildMasterBtnLabel"):SetText(TamrielUnlimitedIT.GuildEPTemp[i]["guild_master"])
		v1:GetNamedChild("GuildMasterBtnLabel_UserID"):SetText(TamrielUnlimitedIT.GuildEPTemp[i]["guild_master"])

		preEP = v1
		i = i + 1
	end

	local ii = i
	while ii <= #TamrielUnlimitedIT.GuildEPTemp do
		local v1 = elEP:GetNamedChild("Dynamic_stampa_Gilda_EP" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end
end

-- CONVALIDA
function LoadConvalida()
	DettagliArray = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if DettagliArray ~= nil then
		if #DettagliArray ~= 0 then
			LoadRefusedValidations()
		else
			if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
				AlreadyActivated()
			else
				TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
			end
		end
	else
		if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
			AlreadyActivated()
		else
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
		end
	end
end

function ButtonSend()
	str = NomeUtenteForum:GetText():gsub("%s+", "")
	if str ~= "" then
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(1, 0.945, 0.109, 1)
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Invio in Corso...")
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(false)
		NomeUtenteForum:SetEditEnabled(false)
		local delay = 2000
		local NomeUtForumLocal = NomeUtenteForum:GetText()
		if TUitDataVar.Admins ~= nil then
			if #TUitDataVar.Admins ~= 0 then
				for i = 1, #TUitDataVar.Admins do
					NomeUtenteForum:SetText("")
					zo_callLater(function () SendMyMail(TUitDataVar.Admins[i], NomeUtForumLocal) end, delay)
					delay = delay + 2000
				end
				zo_callLater(function ()
						TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.121, 1, 0.054, 1)
						TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Invio Completato")
						TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(true)
						NomeUtenteForum:SetEditEnabled(true)
					end, delay)
			else
			NomeUtenteForum:SetText("")
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Impossibile inviare alcuna mail!\n\rAggiornare i file dati addon dall'app")
			end
		else
			NomeUtenteForum:SetText("")
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Impossibile inviare alcuna mail!\n\rAggiornare i file dati addon dall'app")
		end
	else
		NomeUtenteForum:SetText("")
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Inserire un Nome Utente valido")
	end
end

function SendMailConvalida()
	local DettagliArray = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if DettagliArray ~= nil then
		if #DettagliArray ~= 0 then
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
			ButtonSend()
		else
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
			ButtonSend()
		end
	else
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
		ButtonSend()
	end
end
function SendMyMail(NomeAdmin, NomeForum)
	RequestOpenMailbox()
	SendMail(NomeAdmin, "RA_Addon - " .. NomeForum, "Richiesta Attivazione per " .. NomeForum)
	CloseMailbox()
end

function LoadRefusedValidations()
	local pre = TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("Label")
	
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoRiga1"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetDimensions(800, (110 + (#DettagliArray*28)))
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):SetDimensions(800, #DettagliArray*50)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgLabelRefused"):SetText("Attenzione!")
	if #DettagliArray == 1 then
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgTextRefused"):SetText("Hai già realizzato un tentativo, sottocitato, che è fallito nel processo di convalida. Si prega di inserire il Nome Utente corretto del sito e cliccare RIPROVA!")
	else
		TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgTextRefused"):SetText("Hai già realizzato dei tentativi, sottocitati, che sono falliti nel processo di convalida. Si prega di inserire il Nome Utente corretto del sito e cliccare RIPROVA!")
	end
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvioLabel_Convalida"):SetText("Riprova")
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTesto"):SetAnchor(TOP, pre, BOTTOM, 0, 80 + #DettagliArray*25)
	local i = 1
		for key, value in pairs(DettagliArray) do
			ForumName = TamrielUnlimitedIT.TUitDataVar.RefusedValidations[i]["ForumName"]
			Reason = TamrielUnlimitedIT.TUitDataVar.RefusedValidations[i]["Reason"]
			
			if (value.ForumName ~= "" and value.Reason == "UnknowUsername" ) then
				value.Reason = "Il nome utente del sito, " .. value.ForumName .. ", non esiste"
			end
			
			if (value.ForumName == "" and value.Reason == "AccountAlreadyUsed" ) then
				value.Reason = "L'account " .. GetDisplayName() .. " risulta essere già in uso e convalidato da un altro nome utente"
			end
			
			TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):SetText(TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):GetText() .. "- " .. value.Reason .. "\r\n")
			i = i + 1
		end
end

function AlreadyActivated()
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoRiga1"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoTextBG"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetHidden(true)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetColor(0.121, 1, 0.054, 1)
	TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetText("Il tuo account è gia stato convalidato")
end

-- SALVATAGGIO DATI-VARIABILI

TamrielUnlimitedIT.UpdateAccountData = function ()

	Guilds = {}
	Guilds[1] = GetGuildName(1)
	Guilds[2] = GetGuildName(2)
	Guilds[3] = GetGuildName(3)
	Guilds[4] = GetGuildName(4)
	Guilds[5] = GetGuildName(5)
	TamrielUnlimitedIT.savedVariablesGlobal.Guilds = Guilds
	TamrielUnlimitedIT.savedVariablesGlobal.CP = GetUnitChampionPoints("player")

end

TamrielUnlimitedIT.UpdateCharacterData = function ()

	GetCompletTime = GetDate() .. " " .. GetTimeString()

	TamrielUnlimitedIT.savedVariables.lev = GetUnitLevel("player")
	TamrielUnlimitedIT.savedVariables.sex = GetUnitGender("player")
	TamrielUnlimitedIT.savedVariables.class = GetUnitClassId("player")
	TamrielUnlimitedIT.savedVariables.race = GetUnitRaceId("player")
	TamrielUnlimitedIT.savedVariables.alli = GetUnitAlliance("player")
	TamrielUnlimitedIT.savedVariables.last_update = GetCompletTime

end


-- ASSOCIAZIONI EVENTI

TamrielUnlimitedIT.ReloadUIFn = function ()
	ReloadUI()
end



-- Player entra in gioco
function TamrielUnlimitedIT.EventLoadPlayer(event, addonName)
	-- AddPreLoadEvent(PrintErrMessage())
	PrintErrMessage()
	-- Richiamo Messaggi Eventi
	for i = 1, #DebugArray.PreLoadEvent do
		DebugArray.PreLoadEvent[i]()
	end

	while #DebugArray.PreLoadEvent ~= 0 do
		table.remove(DebugArray.PreLoadEvent)
	end
	DebugArray.PlayerLoaded = true
end


-- ASSOCIAZIONI EVENTI / BIND ( STRINGHE )
ZO_CreateStringId("SI_BINDING_NAME_DEBUG_UI", "Reload UI")

EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_PLAYER_ACTIVATED, function() TamrielUnlimitedIT.PlayerNotification() end)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_ADD_ON_LOADED, TamrielUnlimitedIT.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_PLAYER_ACTIVATED, TamrielUnlimitedIT.EventLoadPlayer)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_PLAYER_ACTIVATED, TamrielUnlimitedIT.UpdateCharacterData)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_LEVEL_UPDATE, TamrielUnlimitedIT.UpdateCharacterData)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_LOGOUT_DEFERRED, TamrielUnlimitedIT.UpdateCharacterData)