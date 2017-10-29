TUIT_Community = ZO_Object:Subclass()

function TUIT_Community:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUIT_Community:Initialize()
	self.Community = CreateControlFromVirtual("DynamicLabel_Community", self.control, "DynamicText_Community", 0)
	self.Community:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Community:SetHidden(false)
	local sc = self.Community:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageCommunity = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelCommunity", sc, "DynamicScrollPageCommunity", 0)
end

function TUIT_Community:CreateScene(TUIT_MENU_BAR)
	local TUIT_SCENE_COMMUNITY = ZO_Scene:New("TUit_Community", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_COMMUNITY:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_COMMUNITY:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_COMMUNITY:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_COMMUNITY:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUIT_COMMUNITY_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_COMMUNITY_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_COMMUNITY:AddFragment(TUIT_COMMUNITY_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUIT_COMMUNITY_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUIT_SCENE_COMMUNITY:AddFragment(TUIT_COMMUNITY_WINDOW)

	TUIT_SCENE_COMMUNITY:AddFragment(TUIT_MENU_BAR)

    return TUIT_SCENE_COMMUNITY
end
