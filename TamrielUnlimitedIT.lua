-- INIT VARIABILI
TamrielUnlimitedIT = {}
TamrielUnlimitedIT.name = "TamrielUnlimitedIT"
TamrielUnlimitedIT.LMM = LibStub("LibMainMenu")

TamrielUnlimitedIT.err = {}
TamrielUnlimitedIT.PreLoadEvent = {}
TamrielUnlimitedIT.BackToMainPage = false

local playerNotified = false

-- ESO Dialogs
ESO_Dialogs["TUIT_DIALOG_RELOADING_UI_DEFAULT"] =
{
	title =
	{
		text = SI_TUIT_DIALOG_RELOADING_UI_DEFAULT_TITLE,
	},
	mainText =
	{
		text = SI_TUIT_DIALOG_RELOADING_UI_DEFAULT_TEXT,
	},
}
ESO_Dialogs["SI_TUIT_DIALOG_VALIDATION_REQUEST"] =
{
	title =
	{
		text = SI_TUIT_DIALOG_VALIDATION_REQUEST_TITLE,
	},
	mainText =
	{
		text = SI_TUIT_DIALOG_VALIDATION_REQUEST_TEXT,
	},
}
ESO_Dialogs["TUIT_DIALOG_CHANGE_LANGUAGE"] =
{
	title =
	{
		text = SI_TUIT_DIALOG_CHANGELANG_UI_TITLE,
	},
	mainText =
	{
		text = SI_TUIT_DIALOG_CHANGELANG_UI_TEXT,
	},
}

--[[DebugArray = {}
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
end]]--


-- Local functions

local function UpdateAccountData ()
	Guilds = {}
	Guilds[1] = GetGuildName(1)
	Guilds[2] = GetGuildName(2)
	Guilds[3] = GetGuildName(3)
	Guilds[4] = GetGuildName(4)
	Guilds[5] = GetGuildName(5)
	TamrielUnlimitedIT.savedVariablesGlobal.Guilds = Guilds
	TamrielUnlimitedIT.savedVariablesGlobal.CP = GetUnitChampionPoints("player")
end

local function UpdateCharacterData ()
	GetCompletTime = GetDate() .. " " .. GetTimeString()
	TamrielUnlimitedIT.savedVariables.lev = GetUnitLevel("player")
	TamrielUnlimitedIT.savedVariables.sex = GetUnitGender("player")
	TamrielUnlimitedIT.savedVariables.class = GetUnitClassId("player")
	TamrielUnlimitedIT.savedVariables.race = GetUnitRaceId("player")
	TamrielUnlimitedIT.savedVariables.alli = GetUnitAlliance("player")
	TamrielUnlimitedIT.savedVariables.last_update = GetCompletTime
end

local function InitializeSavedVars()
	AccountData = {
		Guilds = {},
		CP = 0,
		validationUsername = "",
	}
	CharacterData = {
		lev = 0,
		sex = 1,
		class = "",
		alli = 1,
		race = "",
		last_update = "",
	}
	TamrielUnlimitedIT.savedVariablesGlobal = ZO_SavedVars:NewAccountWide("TUitData", 1, nil, AccountData)
	TamrielUnlimitedIT.savedVariables = ZO_SavedVars:New("TUitData", 1, nil, CharacterData)
	UpdateAccountData()
	UpdateCharacterData()
end

local function OnAddOnLoaded(event, addonName)
	if addonName ~= TamrielUnlimitedIT.name then
		do return end
	end
	-- Unregister the event handler for optimization
	EVENT_MANAGER:UnregisterForEvent(TamrielUnlimitedIT.name, EVENT_ADD_ON_LOADED)

	if not TUitDataVar then
		TUitDataVar = {}
	end
	if not TUitDataVar.PlayersData then
		TUitDataVar.PlayersData = {}
	end
	if not TUitDataVar.Guilds then
		TUitDataVar.Guilds = {}
	end
	if not TUitDataVar.Guilds.AD then
		TUitDataVar.Guilds.AD = {}
	end
	if not TUitDataVar.Guilds.DC then
		TUitDataVar.Guilds.DC = {}
	end
	if not TUitDataVar.Guilds.EP then
		TUitDataVar.Guilds.EP = {}
	end

	InitializeSavedVars()
	TamrielUnlimitedIT.TUitDataVar = deepcopy(TUitDataVar)
	TUitDataVar.Player = CreatePlayerArray(TUitDataVar.PlayersData)

	TUitDataVar.Guild = CreateGuildArray(TUitDataVar.Guilds)
	TUitDataVar.GuildAD = CreateGuildArray(TUitDataVar.Guilds.AD)
	TUitDataVar.GuildDC = CreateGuildArray(TUitDataVar.Guilds.DC)
	TUitDataVar.GuildEP = CreateGuildArray(TUitDataVar.Guilds.EP)

	TamrielUnlimitedIT:InitializeScene()
end

local function RegisterKeyBinding(control, ListaKeyBinding)
	control:SetKeyboardEnabled(true)
	control:SetHandler("OnKeyDown", function (sender, key, ctrl, alt, shift, command)
			if ZO_Dialogs_IsShowingDialog() then
				return true
			end
			if (ListaKeyBinding[key] ~= nil) then
				SCENE_MANAGER:ShowBaseScene()
				ChiudiAddRemoveFriend()
			end
			return false
		end)
end

local function SetListHighlightHidden(listPart, hidden)
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

local function PlayerNotification()
	if TUitDataVar ~= nil then
		if next(TamrielUnlimitedIT.TUitDataVar) ~= nil then
			d(GetString(SI_TUIT_TEXT_NOTIFICATION_ADDONLOADED_SUCCESS))
			--EVENT_MANAGER:UnregisterForEvent(TamrielUnlimitedIT.name .. " PlayerNotification", EVENT_PLAYER_ACTIVATED)
			local UserData = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
			if UserData ~= nil and #UserData ~= 0 then
				d(GetString(SI_TUIT_TEXT_NOTIFICATION_ADDONLOADED_NEWVALIDATIONREQUESTS))
			end
		else
			d(GetString(SI_TUIT_TEXT_NOTIFICATION_ADDONLOADED_FAILED))
		end
	else
		d(GetString(SI_TUIT_TEXT_NOTIFICATION_ADDONLOADED_FAILED))
	end
end

-- Class methods

function TamrielUnlimitedIT:InitializeScene()
	self.Hidden = true;
	self.InPausa = IsReticleHidden();

	-- Utenti
	self.Players = TUIT_Players:New(UtentiPanelMainMenu)
	self.Players:Initialize()

	-- Gilde
	self.Guilds = TUIT_Guilds:New(GildePanelMainMenu)
	self.Guilds:Initialize()

	-- Eventi
	self.Events = TUIT_Events:New(EventiPanelMainMenu)
	self.Events:Initialize()

	-- Community
	self.Community = TUIT_Community:New(CommunityPanelMainMenu)
	self.Community:Initialize()

	-- Convalida
	self.Validation = TUIT_Validation:New(ConvalidaPanelMainMenu)
	self.Validation:Initialize()

	-- Contributori
	self.Contributors = TUIT_Contributors:New(ContributoriPanelMainMenu)
	self.Contributors:Initialize()

	-- UserDetail
	self.UserDetail = CreateControlFromVirtual("DynamicLabel_UserDetail", UserDetailPanelMainMenu, "DynamicText_UserDetail", 0)
	self.UserDetail:SetAnchor(TOP, UserDetailPanelMainMenu, TOP, 0, 0)
	self.UserDetail:SetHidden(false)
	local sc = DynamicLabel_UserDetail0ContainerScrollChild
	self.DynamicScrollPageUserDetail = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelUserDetail", sc, "DynamicScrollPageUserDetail", 0)

	-- Builds
	self.Builds = TUIT_Builds:New(BuildsPanelMainMenu)
	self.Builds:Initialize()

	self:CreateScene()
end

function TamrielUnlimitedIT:CreateScene()

	-- Creazione Array dati per icona nel menu
	local TUIT_MAIN_MENU_CATEGORY_DATA =
	{
		descriptor = 1,
		binding = "TUIT_SHOW_PANEL",
		categoryName = SI_TUIT_ADDON_NAME,
		normal = "TamrielUnlimitedIT/textures/TamrielUnlimited_up.dds",
		pressed = "TamrielUnlimitedIT/textures/TamrielUnlimited_down.dds",
		highlight = "TamrielUnlimitedIT/textures/TamrielUnlimited_over.dds",
		callback = function ()
			ZO_MenuBar_ClearSelection(MAIN_MENU_KEYBOARD.categoryBar)

			if (self.BackToMainPage) then
				self.LMM:Update(TamrielUnlimitedIT.MENU_CATEGORY_TUI, "TUit_User")
				self.BackToMainPage = false
			else
				self.LMM:ToggleCategory(TamrielUnlimitedIT.MENU_CATEGORY_TUI)
			end
			ZO_MainMenuCategoryBarButton1:SetMouseEnabled(false)
		end
	}

	local TUIT_MENU_BAR = ZO_FadeSceneFragment:New(ZO_MainMenuCategoryBar)
	
	-- Scene creation - Players
	if self.Players ~= nil then
		local TUIT_SCENE_UTENTI = self.Players:CreateScene(TUIT_MENU_BAR)
		TUIT_SCENE_UTENTI:RegisterCallback("StateChange", function (oldState, newState)
				if newState == SCENE_FRAGMENT_HIDDEN then
					ChiudiAddRemoveFriend()
				end
			end)
	end

	-- Scene creation - Guilds
	if self.Guilds ~= nil then
		local TUIT_SCENE_GILDE = self.Guilds:CreateScene(TUIT_MENU_BAR)
		TUIT_SCENE_GILDE:RegisterCallback("StateChange", function (oldState, newState)
				if newState == SCENE_FRAGMENT_HIDDEN then
					ChiudiAddRemoveFriend()
				end
			end)
	end

	-- Scene creation - Events
	if self.Events ~= nil then
		self.Events:CreateScene(TUIT_MENU_BAR)
	end

	-- Scene creation - Community
	if self.Community ~= nil then
		self.Community:CreateScene(TUIT_MENU_BAR)
	end

	-- Scene creation - Validation
	if self.Validation ~= nil then
		self.Validation:CreateScene(TUIT_MENU_BAR)
	end

	-- Scene creation - Contributors
	if self.Contributors ~= nil then
		self.Contributors:CreateScene(TUIT_MENU_BAR)
	end

	-- Scene creation - DETTAGLI_UTENTE
	local TUIT_SCENE_DETTAGLI_UTENTE = ZO_Scene:New("TUit_UserDetail", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	local TUIT_USER_DETAIL_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_USER_DETAIL) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(TUIT_USER_DETAIL_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	UserDetailPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)
	local TUIT_USER_DETAIL_WINDOW = ZO_FadeSceneFragment:New(UserDetailPanelMainMenu)
	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(TUIT_USER_DETAIL_WINDOW)

	TUIT_SCENE_DETTAGLI_UTENTE:AddFragment(TUIT_MENU_BAR)

	-- Scene creation - Builds
	if self.Builds ~= nil then
		self.Builds:CreateScene(TUIT_MENU_BAR)
	end

	do
		local iconData = {
			{
				categoryName = SI_TUIT_USER, -- Titolo vicino ai bottoni
				descriptor = "TUit_User",
				normal = "EsoUI/art/mainmenu/menubar_social_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_social_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_social_over.dds",
			},
			{
				categoryName = SI_TUIT_GUILD, -- Titolo vicino ai bottoni
				descriptor = "TUit_Guild",
				normal = "EsoUI/art/mainmenu/menubar_guilds_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_guilds_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_guilds_over.dds",
			},
			{
				categoryName = SI_TUIT_BUILD, -- Titolo vicino ai bottoni
				descriptor = "TUit_Build",
				normal = "EsoUI/art/mainmenu/menubar_skills_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_skills_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_skills_over.dds",
			},
			{
				categoryName = SI_TUIT_EVENT, -- Titolo vicino ai bottoni
				descriptor = "TUit_Event",
				normal = "EsoUI/art/guild/tabicon_roster_up.dds",
				pressed = "EsoUI/art/guild/tabicon_roster_down.dds",
				highlight = "EsoUI/art/guild/tabicon_roster_over.dds",
			},
			{
				categoryName = SI_TUIT_COMMUNITY, -- Titolo vicino ai bottoni
				descriptor = "TUit_Community",
				normal = "EsoUI/art/mainmenu/menubar_voip_up.dds",
				pressed = "EsoUI/art/mainmenu/menubar_voip_down.dds",
				highlight = "EsoUI/art/mainmenu/menubar_voip_over.dds",
			},
			{
				categoryName = SI_TUIT_VALIDATION, -- Titolo vicino ai bottoni
				descriptor = "TUit_Validation",
				normal = "EsoUI/art/guild/guildheraldry_indexicon_finalize_up.dds",
				pressed = "EsoUI/art/guild/guildheraldry_indexicon_finalize_down.dds",
				highlight = "EsoUI/art/guild/guildheraldry_indexicon_finalize_over.dds",
			},
		}

		-- Registrazione scene in gruppo
		SCENE_MANAGER:AddSceneGroup("TUit_SceneGroup", ZO_SceneGroup:New("TUit_User", "TUit_Guild", "TUit_Event", "TUit_Community", "TUit_Validation", "TuiContributori", "TUit_UserDetail", "TUit_Build"))

		-- Aggiunge la categoria al menu in alto ( in teoria )
		self.MENU_CATEGORY_TUI = self.LMM:AddCategory(TUIT_MAIN_MENU_CATEGORY_DATA)

		-- Registra il gruppo e aggiunge i bottoni/label
		self.LMM:AddSceneGroup(self.MENU_CATEGORY_TUI, "TUit_SceneGroup", iconData)


		local LMMXML = WINDOW_MANAGER:CreateControl("LMMXML2", ZO_MainMenuCategoryBar, CT_BUTTON)
		LMMXML:SetAnchor(CENTER, ZO_MainMenuCategoryBar, nil, 0, 28)
		self.categoryBar = CreateControlFromVirtual("$(parent)CategoryBar", LMMXML2, "ZO_MenuBarTemplate")
		self.categoryBar:SetAnchor(RIGHT, ZO_MainMenuCategoryBarButton1, LEFT, -70, 0)

		local categoryBarData =
		{
			buttonPadding = 16,
			normalSize = 51,
			downSize = 64,
			animationDuration = DEFAULT_SCENE_TRANSITION_TIME,
			buttonTemplate = "ZO_MainMenuCategoryBarButton",
		}
		ZO_MenuBar_SetData(self.categoryBar, categoryBarData)

		ZO_MenuBar_AddButton(self.categoryBar, TUIT_MAIN_MENU_CATEGORY_DATA)

		local MieTab = SCENE_MANAGER:GetSceneGroup("TUit_SceneGroup").scenes
		local MieTabNotBackToMainPage = {"TUit_User", "TUit_Guild", "TUit_Event", "TUit_Community", "TUit_Validation", "TUit_Build"}

		local ListaKeyBinding = {}
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

		-- OnKeyDown event handlers
		RegisterKeyBinding(UtentiPanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(GildePanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(EventiPanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(CommunityPanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(ConvalidaPanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(ContributoriPanelMainMenu, ListaKeyBinding)
		RegisterKeyBinding(BuildsPanelMainMenu, ListaKeyBinding)

		--- Scene state change event handler
		SCENE_MANAGER:RegisterCallback("SceneStateChanged", function (scene, oldState, newState)
				if (inTable(MieTabNotBackToMainPage, scene.name) and newState == SCENE_FRAGMENT_SHOWING) then
					self.BackToMainPage = false
				end
				if not inTable(MieTab, scene.name) and newState == SCENE_FRAGMENT_SHOWING then
					ZO_MainMenuCategoryBarButton1:SetMouseEnabled(true)
					ZO_MenuBar_ClearSelection(self.categoryBar)
				end
			end)
	end
end

function TamrielUnlimitedIT:SendToChat(text)
	d("|cff0000[" .. self.name .. "]|r |cffff00" .. text .. "|r")
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
function OnMouseEnterUserRow(self)
	self:GetNamedChild("Background"):SetHidden(true)
	SetListHighlightHidden(self, false)
end
function OnMouseExitUserRow(self)
	self:GetNamedChild("Background"):SetHidden(false)
	SetListHighlightHidden(self, true)
end

-- USER CONTEXT MENU

function ApriMenuPlayer(self, button, BackPage)
	if button ~= 2 then
		-- Close the context menu if right mouse button was not pressed
		ChiudiAddRemoveFriend()
		do return end
	end
	local namePG, nameUser, levelPG = nil, nil, nil
	if BackPage == "TUit_User" then
		namePG = self:GetNamedChild("Colonna3Label"):GetText()
		nameUser = self:GetNamedChild("Colonna3Label_UserID"):GetText()
		levelPG = tonumber("0" .. self:GetNamedChild("Colonna0Label"):GetText())
	elseif BackPage == "TUit_Guild" then
		nameUser = self:GetNamedChild("Label_UserID"):GetText()
		namePG = nameUser
		levelPG = 50
	end
	if not namePG then
		do return end
	end
	local isMyself = (GetDisplayName():lower() == nameUser:lower())
	AddRemoveControl:SetHidden(false)
	if isMyself then
		AddRemoveControlAddFriend:SetEnabled(false)
		AddRemoveControlAddFriendLabel_AddFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlRemoveFriend:SetEnabled(false)
		AddRemoveControlRemoveFriendLabel_RemoveFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlInviaMail:SetEnabled(false)
		AddRemoveControlInviaMailLabel_SendMailFriend:SetColor(0.5, 0.5, 0.5, 1)
		AddRemoveControlBisbiglia:SetEnabled(false)
		AddRemoveControlBisbigliaLabel_WhisperFriend:SetColor(0.5, 0.5, 0.5, 1)
	else
		if IsFriend(nameUser) then
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
		AddRemoveControlInviaMail:SetEnabled(true)
		AddRemoveControlInviaMailLabel_SendMailFriend:SetColor(1, 1, 1, 1)
		AddRemoveControlBisbiglia:SetEnabled(true)
		AddRemoveControlBisbigliaLabel_WhisperFriend:SetColor(1, 1, 1, 1)
	end
	AddRemoveControlLabel_NomeAdd:SetText(namePG) -- Aggiunge il nome PG
	AddRemoveControlLabel_NomeAdd:SetColor(GetColorForLevel(levelPG):UnpackRGBA())
	AddRemoveControlUserDetailIDLabel_UserDetailID:SetText(nameUser) -- Aggiunge UserID alla voce dettagli
	AddRemoveControl:ClearAnchors()
	local mouseX, mouseY = GetUIMousePosition()
	AddRemoveControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, mouseX, mouseY)
	AddRemoveControlLabel_CallPage:SetText(BackPage)
	--[[if button == 1 or GetUnitName("player") == nameUser then
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
		AddRemoveControlLabel_NomeAdd:SetText(namePG) -- Aggiunge il nome PG
		AddRemoveControlUserDetailIDLabel_UserDetailID:SetText(nameUser) -- Aggiunge UserID alla voce dettagli
		AddRemoveControl:ClearAnchors()
		local mouseX, mouseY = GetUIMousePosition()
		AddRemoveControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, mouseX, mouseY)
		AddRemoveControlLabel_CallPage:SetText(BackPage)
	else
		AddRemoveControl:SetHidden(false)
		if IsFriend(nameUser) then
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
		AddRemoveControlLabel_NomeAdd:SetText(namePG) -- Aggiunge il nome PG
		AddRemoveControlUserDetailIDLabel_UserDetailID:SetText(nameUser) -- Aggiunge UserID alla voce dettagli
		AddRemoveControl:ClearAnchors()
		local mouseX, mouseY = GetUIMousePosition()
		AddRemoveControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, mouseX, mouseY)
		AddRemoveControlLabel_CallPage:SetText(BackPage)
	end]]--
end
function MouseDownGenerale()
	ChiudiAddRemoveFriend()
end
function ChiudiAddRemoveFriend()
	AddRemoveControl:SetHidden(true)
end
function AggiungiAmico(self)
	RequestFriend(self:GetParent():GetNamedChild("Label_NomeAdd"):GetText(), "")
	TamrielUnlimitedIT:SendToChat(GetString(SI_TUIT_TEXT_ADDED_FRIEND))
	ChiudiAddRemoveFriend()
end
function RimuoviAmico(self)
	RemoveFriend(self:GetParent():GetNamedChild("Label_NomeAdd"):GetText())
	TamrielUnlimitedIT:SendToChat(GetString(SI_TUIT_TEXT_REMOVED_FRIEND))
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
					credit = credit .. (credit == "" and "" or ", ") .. "|cff0000" .. GetString(SI_TUIT_TEXT_TUIROLE_ADMINISTRATOR) .. "|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Developers ~= nil then
		if #TUitDataVar.Developers ~= 0 then
			for i = 1, #TUitDataVar.Developers do
				if TUitDataVar.Developers[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|ca1d490" .. GetString(SI_TUIT_TEXT_TUIROLE_DEVELOPER) .. "|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Translators ~= nil then
		if #TUitDataVar.Translators ~= 0 then
			for i = 1, #TUitDataVar.Translators do
				if TUitDataVar.Translators[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|cc390d4" .. GetString(SI_TUIT_TEXT_TUIROLE_TRANSLATOR) .. "|r"
					break
				end
			end
		end
	end
	if TUitDataVar.Guildmasters ~= nil then
		if #TUitDataVar.Guildmasters ~= 0 then
			for i = 1, #TUitDataVar.Guildmasters do
				if TUitDataVar.Guildmasters[i] == userID then
					credit = credit .. (credit == "" and "" or ", ") .. "|c90c3d4" .. GetString(SI_TUIT_TEXT_TUIROLE_GUILDMASTER) .. "|r"
					break
				end
			end
		end
	end
	return credit
end
function ApriDettagliPlayer(self, BackPage)
	local UserData = TamrielUnlimitedIT.TUitDataVar.PlayersData[self:GetNamedChild("Label_UserDetailID"):GetText()]
	if (UserData == nil) then
		TamrielUnlimitedIT:SendToChat(GetString(SI_TUIT_TEXT_INVALID_USER))
	else
		TamrielUnlimitedIT.BackToMainPage = true

		local pre = TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTesto")
		local credit = GetCreditByUserID(self:GetNamedChild("Label_UserDetailID"):GetText())
		credit = credit:gsub(", ", "   ")

		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTesto"):SetDimensions(900, (tablelength(UserData.PG) - 1) * 100)

		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoUserID"):SetText(self:GetNamedChild("Label_UserDetailID"):GetText())
		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoSex"):SetText(GetString(SI_TUIT_TEXT_SEX) .. ": " .. (UserData.Sex > 0 and GetString("SI_GENDER", UserData.Sex) or "N.D."))
		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoSex"):SetColor(GetColorForSex(UserData.Sex):UnpackRGBA())
		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoCredit"):SetText(credit)
		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoRiga5Label_BackPage"):SetText(BackPage)

		TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoGildeList"):SetText("")

		if (tablelength(UserData["Guilds"]) ~= 0) then
			for key, value in pairs(UserData["Guilds"]) do
				--TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoGilde"):SetText("Gilde")
				TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoGildeList"):SetText(TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoGildeList"):GetText() .. "- " .. value .. "\r\n")
			end
		else
			TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoGildeList"):SetText(GetString(SI_TUIT_TEXT_USER_NO_GUILDS))
		end

		local el1 = TamrielUnlimitedIT.DynamicScrollPageUserDetail:GetNamedChild("ContTestoContUserDinamici")
		local pre = el1:GetNamedChild("pre")

		--[[ for key, value in pairs(UserData) do
		d(key, value) end ]]--
		-- #Test per verificare il corretto costruttore di tabelle

		local i = 1

		for key, value in pairs(UserData) do
			--if (key~="Guilds" and key~="CP") then
			if (key == "PG") then
				for key1, value1 in pairs(value) do

					local v1 = el1:GetNamedChild("Dynamic_stampa_Row_User" .. i)
					if v1 == nil then
						v1 = CreateControlFromVirtual("$(parent)Dynamic_stampa_Row_User", el1, "DynamicRowUserDetail", i)
					end

					local colorPG = GetColorForLevel(value1.lev)

					v1:SetDimensions(800, 80)
					v1:SetHidden(false)
					v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 20)

					v1:GetNamedChild("NomePG"):SetText(key1)
					v1:GetNamedChild("NomePG"):SetColor(colorPG:UnpackRGBA())
					v1:GetNamedChild("Alleanza"):SetText(zo_strformat(GetString("SI_ALLIANCE", value1.alli)))
					v1:GetNamedChild("Alleanza"):SetColor(GetColorForAlliance(value1.alli):UnpackRGBA())
					v1:GetNamedChild("Liv"):SetText("|cEECA2A" .. GetString(SI_TUIT_TEXT_LEVEL) .. "|r: " .. value1.lev)
					v1:GetNamedChild("CP"):SetText("|cEECA2A" .. GetString(SI_TUIT_TEXT_CP) .. "|r: " .. UserData.CP)
					v1:GetNamedChild("Sex"):SetText("|cEECA2A" .. GetString(SI_TUIT_TEXT_SEX) .. "|r: " .. GetString("SI_GENDER", value1.sex))
					v1:GetNamedChild("Race"):SetText("|cEECA2A" .. GetString(SI_TUIT_TEXT_RACE) .. "|r: " .. zo_strformat(SI_RACE_NAME, GetRaceName(value1.sex, value1.race)))
					v1:GetNamedChild("Class"):SetText("|cEECA2A" .. GetString(SI_TUIT_TEXT_CLASS) .. "|r: " .. zo_strformat(SI_CLASS_NAME, GetClassName(value1.sex, value1.class)))

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

		TamrielUnlimitedIT.LMM:Update(TamrielUnlimitedIT.MENU_CATEGORY_TUI, "TUit_UserDetail")
	end
end



-- GUILDS


-- ACCOUNT VALIDATION

function SendValidationMail()
	TamrielUnlimitedIT.Validation:SendValidation()
end

-- SHARED BUILDS

function SearchBuilds(searchText)
	TamrielUnlimitedIT.Builds:SearchBuilds(searchText)
end
function SortBuildsById ()
    TamrielUnlimitedIT.Builds:SortBuilds("id")
end
function SortBuildsByTarget ()
    TamrielUnlimitedIT.Builds:SortBuilds("target")
end
function SortBuildsByOwner ()
    TamrielUnlimitedIT.Builds:SortBuilds("owner")
end
function SortBuildsByName ()
    TamrielUnlimitedIT.Builds:SortBuilds("name")
end
function SortBuildsByRating ()
    TamrielUnlimitedIT.Builds:SortBuilds("rating")
end
function SortBuildsByDate ()
    TamrielUnlimitedIT.Builds:SortBuilds("date")
end
function SortBuildsByRace ()
    TamrielUnlimitedIT.Builds:SortBuilds("race")
end
function SortBuildsByClass ()
    TamrielUnlimitedIT.Builds:SortBuilds("class")
end
function SortBuildsByRole ()
    TamrielUnlimitedIT.Builds:SortBuilds("role")
end
function OnMouseEnterBuildRow(self)
	self:GetNamedChild("Background"):SetHidden(true)
	SetListHighlightHidden(self, false)
end
function OnMouseExitBuildRow(self)
	self:GetNamedChild("Background"):SetHidden(false)
	SetListHighlightHidden(self, true)
end
function OpenBuildDetails(self, backPage)
	TamrielUnlimitedIT.Builds:ShowDetails(self:GetNamedChild("Label_BuildID"):GetText())
end
function BackToBuilds()
	TamrielUnlimitedIT.Builds:CloseDetails()
end
function ShowMyBuild()
	TamrielUnlimitedIT.Builds:ShowMyBuild()
end
function ShareBuild()
	TamrielUnlimitedIT.Builds:Share()
end
function OnMouseEnterBuildRate(self)
	local rating = tonumber(self:GetName():sub(self:GetName():len()))
	local el = TamrielUnlimitedIT.Builds.DynamicScrollPageBuildDetails
	for i = 1, 5, 1 do
		local tex = "star-empty.dds"
		if i <= rating then
			tex = "star-full.dds"
		end
		el:GetNamedChild("ContentRateRating" .. i):SetTexture("TamrielUnlimitedIT/textures/" .. tex)
	end
end
function OnMouseExitBuildRate(self)
	TamrielUnlimitedIT.Builds:SetMyRating()
end
function OnMouseDownBuildRate(self)
	local rating = tonumber(self:GetName():sub(self:GetName():len()))
	TamrielUnlimitedIT.Builds:RateBuild(rating * 2)
end
function OnMouseEnterSlot(self, slot)
	TamrielUnlimitedIT.Builds:PreviewSlot(self, slot)
end
function OnMouseExitSlot()
	TamrielUnlimitedIT.Builds:PreviewSlot(nil)
end

-- ADDON GLOBAL EVENTS

function TamrielUnlimitedIT:ScheduleTimer(callback, seconds)
	zo_callLater(callback, seconds * 1000)
end

function TamrielUnlimitedIT.ReloadUI()
	TamrielUnlimitedIT:ScheduleTimer(function()
		ZO_Dialogs_ShowDialog("TUIT_DIALOG_RELOADING_UI_DEFAULT", nil, nil, false)
		TamrielUnlimitedIT:ScheduleTimer(function() ReloadUI() end, 3)
	end, 0.1)
end

function TamrielUnlimitedIT.ReloadUI_ChangeLang()
	TamrielUnlimitedIT:ScheduleTimer(function()
		ZO_Dialogs_ShowDialog("TUIT_DIALOG_CHANGE_LANGUAGE", nil, nil, false)
		TamrielUnlimitedIT:ScheduleTimer(function() SetCVar("language.2", "it")	end, 3)
	end, 0.1)
end

function TamrielUnlimitedIT.ReloadUI_SaveValidation()
	TamrielUnlimitedIT:ScheduleTimer(function()
		ZO_Dialogs_ShowDialog("SI_TUIT_DIALOG_VALIDATION_REQUEST", nil, nil, false)
		TamrielUnlimitedIT:ScheduleTimer(function() ReloadUI() end, 3)
	end, 0.1)
end

-- ASSOCIAZIONI EVENTI / BIND ( STRINGHE )
ZO_CreateStringId("SI_BINDING_NAME_DEBUG_UI", "Reload UI")

EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_PLAYER_ACTIVATED, function()
		if not playerNotified then
			if TUitDataVar.Options ~= nil and not TamrielUnlimitedIT.savedVariablesGlobal.changedLanguage then
				if TUitDataVar.Options.SteamMode == 1 then
					TamrielUnlimitedIT.savedVariablesGlobal.changedLanguage = true
					TamrielUnlimitedIT:ScheduleTimer(function()
							ZO_Dialogs_ShowDialog("TUIT_DIALOG_CHANGE_LANGUAGE", nil, nil, false)
							TamrielUnlimitedIT:ScheduleTimer(function()
									SetCVar("language.2", "it")
								end, 3)
						end, 0.1)
				end
			end
			PlayerNotification()
			playerNotified = true
		end
		--EventLoadPlayer()
		UpdateCharacterData()
	end)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_LEVEL_UPDATE, UpdateCharacterData)
EVENT_MANAGER:RegisterForEvent(TamrielUnlimitedIT.name, EVENT_LOGOUT_DEFERRED, UpdateCharacterData)
