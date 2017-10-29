TUIT_Contributors = ZO_Object:Subclass()

function TUIT_Contributors:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUIT_Contributors:Initialize()
	self.Panel = CreateControlFromVirtual("DynamicLabel_Contributor", self.control, "DynamicText_Contributor", 0)
	self.Panel:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Panel:SetHidden(false)
	local sc = self.Panel:GetNamedChild("ContainerScrollChild")
	local el1 = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelContributori", sc, "DynamicScrollPageContributori", 0)
end

function TUIT_Contributors:CreateScene(TUIT_MENU_BAR)
	local TUIT_SCENE_CONTRIBUTORI = ZO_Scene:New("TuiContributori", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_CONTRIBUTORI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_CONTRIBUTORI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_CONTRIBUTORI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_CONTRIBUTORI:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_CONTRIBUTORI:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_CONTRIBUTORI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUIT_CONTRIBUTORI_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_CONTRIBUTORI) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_CONTRIBUTORI:AddFragment(TUIT_CONTRIBUTORI_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUIT_CONTRIBUTORI_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUIT_SCENE_CONTRIBUTORI:AddFragment(TUIT_CONTRIBUTORI_WINDOW)

	TUIT_SCENE_CONTRIBUTORI:AddFragment(TUIT_MENU_BAR)

    return TUIT_SCENE_CONTRIBUTORI
end
