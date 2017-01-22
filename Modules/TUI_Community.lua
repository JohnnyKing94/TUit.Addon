TUI_Community = ZO_Object:Subclass()

function TUI_Community:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUI_Community:Initialize()
	self.Community = CreateControlFromVirtual("DynamicLabel_stampataCommunity", self.control, "DynamicTextCommunity", 0)
	self.Community:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Community:SetHidden(false)
	local sc = self.Community:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageCommunity = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelCommunity", sc, "DynamicScrollPageCommunity", 0)
end

function TUI_Community:CreateScene(TUI_MENU_BAR)
	local TUI_SCENE_COMMUNITY = ZO_Scene:New("TuiCommunity", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_COMMUNITY:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_COMMUNITY:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_COMMUNITY:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_COMMUNITY:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_COMMUNITY:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_COMMUNITY_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_COMMUNITY_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_COMMUNITY:AddFragment(TUI_COMMUNITY_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUI_COMMUNITY_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUI_SCENE_COMMUNITY:AddFragment(TUI_COMMUNITY_WINDOW)

	TUI_SCENE_COMMUNITY:AddFragment(TUI_MENU_BAR)

    return TUI_SCENE_COMMUNITY
end
