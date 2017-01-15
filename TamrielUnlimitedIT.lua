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
		--[[if TUitDataVar.Events ~= nil then
			TamrielUnlimitedIT.EventTemp = deepcopy(TUitDataVar.Events)
		end]]--
	
		if next(TamrielUnlimitedIT.TUitDataVar) ~= nil then
			if addonName == TamrielUnlimitedIT.name then
				TamrielUnlimitedIT:InitializeScene()
			end
		end
	else
		TamrielUnlimitedIT.TUitDataVar = {}
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
		CP = 0
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

	-- Utenti
	TamrielUnlimitedIT.Players = TUI_Players:New(UtentiPanelMainMenu)
	TamrielUnlimitedIT.Players:Initialize()

	-- Gilde
	TamrielUnlimitedIT.Guilds = TUI_Guilds:New(GildePanelMainMenu)
	TamrielUnlimitedIT.Guilds:Initialize()

	-- Eventi
	TamrielUnlimitedIT.Events = TUI_Events:New(EventiPanelMainMenu)
	TamrielUnlimitedIT.Events:Initialize()

	-- Community
	TamrielUnlimitedIT.Community = TUI_Community:New(CommunityPanelMainMenu)
	TamrielUnlimitedIT.Community:Initialize()

	-- Convalida
	TamrielUnlimitedIT.Validator = TUI_Validator:New(ConvalidaPanelMainMenu)
	TamrielUnlimitedIT.Validator:Initialize()

	-- Contributori
	TamrielUnlimitedIT.Contributors = TUI_Contributors:New(ContributoriPanelMainMenu)
	TamrielUnlimitedIT.Contributors:Initialize()

	-- DettagliUtente
	TamrielUnlimitedIT.DettagliUtente = CreateControlFromVirtual("DynamicLabel_stampataDettagliUtente", DettagliUtentePanelMainMenu, "DynamicTextDettagliUtente", 0)
	TamrielUnlimitedIT.DettagliUtente:SetAnchor(TOP, DettagliUtentePanelMainMenu, TOP, 0, 0)
	TamrielUnlimitedIT.DettagliUtente:SetHidden(false)
	local sc = DynamicLabel_stampataDettagliUtente0ContainerScrollChild
	TamrielUnlimitedIT.DynamicScrollPageDettagliUtente = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelDettagliUtente", sc, "DynamicScrollPageDettagliUtente", 0)

	-- Builds
	TamrielUnlimitedIT.Builds = TUI_Builds:New(BuildsPanelMainMenu)
	TamrielUnlimitedIT.Builds:Initialize()

	TamrielUnlimitedIT.CreateScene()
end
function TamrielUnlimitedIT.CreateScene()

	-- Creazione stringhe
	ZO_CreateStringId("SI_TUI_NOME_ADDON", "Tamriel Unlimited IT")
	ZO_CreateStringId("SI_TUI_UTENTI", "Utenti")
	ZO_CreateStringId("SI_TUI_UTENTI_TITLE", "Utenti Registrati")
	ZO_CreateStringId("SI_TUI_GILDE", "Gilde")
	ZO_CreateStringId("SI_TUI_GILDE_TITLE", "Gilde Registrate")
	ZO_CreateStringId("SI_TUI_EVENTI", "Eventi")
	ZO_CreateStringId("SI_TUI_EVENTI_TITLE", "Eventi in corso")
	ZO_CreateStringId("SI_TUI_COMMUNITY", "Community")
	ZO_CreateStringId("SI_TUI_COMMUNITY_TITLE", "Segui il Progetto")
	ZO_CreateStringId("SI_TUI_CONVALIDA", "Convalida")
	ZO_CreateStringId("SI_TUI_CONVALIDA_TITLE", "Convalida il tuo Account")
	ZO_CreateStringId("SI_TUI_CONTRIBUTORI", "Contributori")
	ZO_CreateStringId("SI_TUI_DETTAGLI_UTENTE", "Dettagli Utente")
	ZO_CreateStringId("SI_TUI_BUILDS", "Builds")
	ZO_CreateStringId("SI_TUI_BUILDS_TITLE", "Build Condivise")
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

	TUI_MENU_BAR = ZO_FadeSceneFragment:New(ZO_MainMenuCategoryBar)
	
	-- Scene creation - Players
	if TamrielUnlimitedIT.Players ~= nil then
		local TUI_SCENE_UTENTI = TamrielUnlimitedIT.Players:CreateScene(TUI_MENU_BAR)
		TUI_SCENE_UTENTI:RegisterCallback("StateChange", function (oldState, newState)
				if newState == SCENE_FRAGMENT_HIDDEN then
					ChiudiAddRemoveFriend()
				end
			end)
	end

	-- Scene creation - Guilds
	if TamrielUnlimitedIT.Guilds ~= nil then
		local TUI_SCENE_GILDE = TamrielUnlimitedIT.Guilds:CreateScene(TUI_MENU_BAR)
		TUI_SCENE_GILDE:RegisterCallback("StateChange", function (oldState, newState)
				if newState == SCENE_FRAGMENT_HIDDEN then
					ChiudiAddRemoveFriend()
				end
			end)
	end

	-- Scene creation - Events
	if TamrielUnlimitedIT.Events ~= nil then
		TamrielUnlimitedIT.Events:CreateScene(TUI_MENU_BAR)
	end

	-- Scene creation - Community
	if TamrielUnlimitedIT.Community ~= nil then
		TamrielUnlimitedIT.Community:CreateScene(TUI_MENU_BAR)
	end

	-- Scene creation - Validator
	if TamrielUnlimitedIT.Validator ~= nil then
		TamrielUnlimitedIT.Validator:CreateScene(TUI_MENU_BAR)
	end

	-- Scene creation - Contributors
	if TamrielUnlimitedIT.Contributors ~= nil then
		TamrielUnlimitedIT.Contributors:CreateScene(TUI_MENU_BAR)
	end

	-- Scene creation - DETTAGLI_UTENTE
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

	-- Scene creation - Builds
	if TamrielUnlimitedIT.Builds ~= nil then
		TamrielUnlimitedIT.Builds:CreateScene(TUI_MENU_BAR)
	end

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
				categoryName = SI_TUI_BUILDS, -- Titolo vicino ai bottoni
				descriptor = "TuiBuilds",
				normal = "EsoUI/art/mainmenu/menubar_skills_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_skills_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_skills_over.dds",
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
		SCENE_MANAGER:AddSceneGroup("TuiSceneGroup", ZO_SceneGroup:New("TuiUtenti", "TuiGilde", "TuiEventi", "TuiCommunity", "TuiConvalida", "TuiContributori", "TuiDettagliUtente", "TuiBuilds"))

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
		local MieTabNotBackToMainPage = {"TuiUtenti", "TuiGilde", "TuiEventi", "TuiCommunity", "TuiConvalida", "TuiBuilds"}

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

		BuildsPanelMainMenu:SetKeyboardEnabled(true)
		BuildsPanelMainMenu:SetHandler("OnKeyDown", function (self, key, ctrl, alt, shift, command)
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

-- PLAYERS LIST

function SearchPlayer(searchText)
	TamrielUnlimitedIT.Players:SearchPlayer(searchText)
end
function SortLiv()
	TamrielUnlimitedIT.Players:Sort("lev")
end
function SortCP()
	TamrielUnlimitedIT.Players:Sort("CP")
end
function SortSesso()
	TamrielUnlimitedIT.Players:Sort("sex")
end
function SortUser()
	TamrielUnlimitedIT.Players:Sort("pg_name")
end
function SortRace()
	TamrielUnlimitedIT.Players:Sort("race")
end
function SortClass()
	TamrielUnlimitedIT.Players:Sort("class")
end
function SortFazione()
	TamrielUnlimitedIT.Players:Sort("alli")
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
function GetCreditByUserID(userID)
	local credit = ""
	if TUitDataVar.Admins ~= nil then
		if #TUitDataVar.Admins ~= 0 then
			for i = 1, #TUitDataVar.Admins do
				if TUitDataVar.Admins[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|cff0000Amministratore|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Developers ~= nil then
		if #TUitDataVar.Developers ~= 0 then
			for i = 1, #TUitDataVar.Developers do
				if TUitDataVar.Developers[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|ca1d490Sviluppatore|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Translators ~= nil then
		if #TUitDataVar.Translators ~= 0 then
			for i = 1, #TUitDataVar.Translators do
				if TUitDataVar.Translators[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|cc390d4Traduttore|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Guildmasters ~= nil then
		if #TUitDataVar.Guildmasters ~= 0 then
			for i = 1, #TUitDataVar.Guildmasters do
				if TUitDataVar.Guildmasters[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|c90c3d4GuildMaster|r"
					break
				end
			end
		end
	end
	return credit
end
function ApriDettagliPlayer(self, BackPage)
	local DettagliArray = TamrielUnlimitedIT.TUitDataVar.PlayersData[self:GetNamedChild("Label_DettagliUserID"):GetText()]
	if (DettagliArray == nil) then
		d("Nessuna informazione trovata per questo valore")
	else
		TamrielUnlimitedIT.BackToMainPage = true

		local pre = TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTesto")
		local credit = GetCreditByUserID(self:GetNamedChild("Label_DettagliUserID"):GetText())

		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTesto"):SetDimensions(900, (tablelength(DettagliArray.PG) - 1) * 100)

		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoUserID"):SetText(self:GetNamedChild("Label_DettagliUserID"):GetText())
		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoSex"):SetText(DettagliArray.Sex > 0 and GetString("SI_GENDER", DettagliArray.Sex) or "N.D.")
		TamrielUnlimitedIT.DynamicScrollPageDettagliUtente:GetNamedChild("ContTestoCredit"):SetText(credit)
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
			--if (key~="Guilds" and key~="CP") then
			if (key == "PG") then
				for key1, value1 in pairs(value) do

					local v1 = el1:GetNamedChild("Dynamic_stampa_Row_User" .. i)

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



-- GILDE


-- CONVALIDA

function SendValidationMail()
	TamrielUnlimitedIT.Validator:SendValidationMail()
end

-- SHARED BUILDS

function SearchBuilds(searchText)
	do return end
	TamrielUnlimitedIT.Builds:SearchBuilds(searchText)
end
function SortBuildsById ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("id")
end
function SortBuildsByTarget ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("target")
end
function SortBuildsByOwner ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("owner")
end
function SortBuildsByName ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("name")
end
function SortBuildsByRating ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("rating")
end
function SortBuildsByDate ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("date")
end
function SortBuildsByRace ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("race")
end
function SortBuildsByClass ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("class")
end
function SortBuildsByRole ()
	do return end
    TamrielUnlimitedIT.Builds:SortBuilds("role")
end
local function SetListHighlightHidden(listPart, hidden)
	do return end
    if(listPart) then
        local highlight = listPart:GetNamedChild("Highlight")
        if(highlight and (highlight:GetType() == CT_TEXTURE)) then
            if not highlight.animation then
                highlight.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("ShowOnMouseOverLabelAnimation", highlight)
            end
            if hidden then
                highlight.animation:PlayBackward()
            else
                highlight.animation:PlayForward()
            end
        end
    end
end
function OnMouseEnterBuildRow(self)
	do return end
	self:GetNamedChild("Background"):SetHidden(true)
	SetListHighlightHidden(self, false)
end
function OnMouseExitBuildRow(self)
	do return end
	self:GetNamedChild("Background"):SetHidden(false)
	SetListHighlightHidden(self, true)
end
function OpenBuildDetails(self, backPage)
	do return end
	TamrielUnlimitedIT.Builds:ShowDetails(self:GetNamedChild("Label_BuildID"):GetText())
end
function BackToBuilds()
	do return end
	TamrielUnlimitedIT.Builds:CloseDetails()
end
function ShowMyBuild()
	do return end
	TamrielUnlimitedIT.Builds:ShowMyBuild()
end
function ShareBuild()
	do return end
	TamrielUnlimitedIT.Builds:Share()
end
function OnMouseEnterBuildRate(self)
	do return end
	local rating = tonumber(self:GetName():sub(self:GetName():len()))
	local el = TamrielUnlimitedIT.Builds.DynamicScrollPageBuildDetails
	for i = 1, 5, 1 do
		local tex = "star-empty.dds"
		if i <= rating then
			tex = "star-full.dds"
		end
		el:GetNamedChild("ContentRateRating" .. i):SetTexture("TamrielUnlimitedIT/Textures/" .. tex)
	end
end
function OnMouseExitBuildRate(self)
	do return end
	TamrielUnlimitedIT.Builds:SetMyRating()
end
function OnMouseDownBuildRate(self)
	do return end
	local rating = tonumber(self:GetName():sub(self:GetName():len()))
	TamrielUnlimitedIT.Builds:RateBuild(rating * 2)
end
function OnMouseEnterSlot(self, slot)
	do return end
	TamrielUnlimitedIT.Builds:PreviewSlot(self, slot)
end
function OnMouseExitSlot()
	do return end
	TamrielUnlimitedIT.Builds:PreviewSlot(nil)
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