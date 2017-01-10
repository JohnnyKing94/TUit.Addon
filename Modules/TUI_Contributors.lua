TUI_Contributors = ZO_Object:Subclass()

function TUI_Contributors:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUI_Contributors:Initialize()
	self.Panel = CreateControlFromVirtual("DynamicLabel_stampataContributori", self.control, "DynamicTextContributori", 0)
	self.Panel:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Panel:SetHidden(false)
	local sc = self.Panel:GetNamedChild("ContainerScrollChild")
	local el1 = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelContributori", sc, "DynamicScrollPageContributori", 0)
end

function TUI_Contributors:CreateScene(TUI_MENU_BAR)
	local TUI_SCENE_CONTRIBUTORI = ZO_Scene:New("TuiContributori", SCENE_MANAGER)

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
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUI_CONTRIBUTORI_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUI_SCENE_CONTRIBUTORI:AddFragment(TUI_CONTRIBUTORI_WINDOW)

	TUI_SCENE_CONTRIBUTORI:AddFragment(TUI_MENU_BAR)

    return TUI_SCENE_CONTRIBUTORI
end
