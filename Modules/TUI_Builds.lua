TUI_Builds = {}
TUI_Builds.Builds = {}
TUI_Builds.Filter = ""
TUI_Builds.Sort = "id"

local TUI_Builds_Target = { "PVE", "PVP", "PVP/PVE" }

function TUI_Builds:Get(buildId)
	if self.Builds ~= nil then
		for i = 1, #self.Builds do
			if self.Builds[i].id == buildId then
				return self.Builds[i]
			end
		end
	end
	return nil
end

function TUI_Builds:Initialize ()
    -- Initialize UI for Builds screen
    self.BuildsUI = CreateControlFromVirtual("DynamicLabel_screenBuilds", BuildsPanelMainMenu, "DynamicTextBuilds", 0)
	self.BuildsUI:SetAnchor(TOP, BuildsPanelMainMenu, TOP, 0, 0)
	self.BuildsUI:SetHidden(false)
	local sc = DynamicLabel_screenBuilds0ContainerScrollChild
	self.DynamicScrollPageBuilds = CreateControlFromVirtual("Dynamic_print_ScrollPanelBuilds", sc, "DynamicScrollPageBuilds", 0)

	SearchBuild_edit:SetHandler("OnEnter", function (self, key, ctrl, alt, shift, command)
			TUI_Builds:SearchBuilds(SearchBuild_edit:GetText())
		end)
end

function TUI_Builds:CreateScene ()
	-- Creazione stringhe
	ZO_CreateStringId("SI_TUI_BUILDS", "Builds")

	TUI_SCENE_BUILDS = ZO_Scene:New("TuiBuilds", SCENE_MANAGER)

	-- Assign background and UI components
	-- TUI_SCENE_BUILDS:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_BUILDS:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_BUILDS:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_BUILDS:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_BUILDS:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_BUILDS:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_BUILDS_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_BUILDS)
	TUI_SCENE_BUILDS:AddFragment(TUI_BUILDS_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	BuildsPanelMainMenu:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	TUI_BUILDS_WINDOW = ZO_FadeSceneFragment:New(BuildsPanelMainMenu)
	TUI_SCENE_BUILDS:AddFragment(TUI_BUILDS_WINDOW)

	TUI_MENU_BAR = ZO_FadeSceneFragment:New(ZO_MainMenuCategoryBar)
	TUI_SCENE_BUILDS:AddFragment(TUI_MENU_BAR)

	-- Fill the builds list
	self:SearchBuilds("")
end

function TUI_Builds:FillBuildsList ()
	self.DynamicScrollPageBuilds:SetDimensions(900, 20 * #self.Builds + 50)
	self.DynamicScrollPageBuilds:GetNamedChild("Tabella"):SetDimensions(900, 20 * #self.Builds + 50)

	local el1 = self.DynamicScrollPageBuilds:GetNamedChild("Tabella")
	local pre = el1:GetNamedChild("print_Row0")
	local searchcontrol = self.DynamicScrollPageBuilds:GetNamedChild("SearchBuild_control")
	local searchbtn = self.DynamicScrollPageBuilds:GetNamedChild("SearchBuild_btn")
	
	pre:GetNamedChild("NoBuilds"):SetHidden(true)
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

	if #self.Builds > 0 then
		while i <= #self.Builds do
			local v1 = el1:GetNamedChild("Dynamic_print_BuildsRow" .. i)
			if v1 == nil then
				v1 = CreateControlFromVirtual("$(parent)Dynamic_print_BuildsRow", el1, "BuildsDynamicRow", i)
			end

			local raceTexture = GetRaceTexture(self.Builds[i].race)
			local classTexture = GetClassTexture(self.Builds[i].class)

			d("Race tex: " .. raceTexture)
			d("Class tex: " .. classTexture)

			v1:SetDimensions(900, 20)
			v1:SetHidden(false)
			v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 0)
			v1:GetNamedChild("Colonna0Label"):SetText(self.Builds[i].date)
			v1:GetNamedChild("Colonna1Label"):SetText(TUI_Builds.GetBuildTarget(self.Builds[i].target))
			v1:GetNamedChild("Colonna2Label"):SetText(self.Builds[i].owner)
			v1:GetNamedChild("Colonna3NameButtonLabel"):SetText(self.Builds[i].name)
			v1:GetNamedChild("Colonna3NameButtonLabel"):SetColor(0, 186, 255, 1)
			v1:GetNamedChild("Colonna3NameButtonLabel_BuildID"):SetText(self.Builds[i].id)
			v1:GetNamedChild("Colonna4Label"):SetText(zo_strformat(SI_RACE_NAME, GetRaceName(2, self.Builds[i].race)))
			--[[
			if raceTexture ~= "" then
				v1:GetNamedChild("Colonna4RaceTexture"):SetTexture(raceTexture)
				v1:GetNamedChild("Colonna4RaceTexture"):SetHidden(false)
			else
				v1:GetNamedChild("Colonna4RaceTexture"):SetHidden(true)
			end
			--v1:GetNamedChild("Colonna4RaceTooltip"):SetText(zo_strformat(SI_RACE_NAME, GetRaceName(2, self.Builds[i].race)))
			]]--
			v1:GetNamedChild("Colonna5Label"):SetText(zo_strformat(SI_CLASS_NAME, GetClassName(2, self.Builds[i].class)))
			--[[
			if classTexture ~= "" then
				v1:GetNamedChild("Colonna5ClassTexture"):SetTexture(classTexture)
				v1:GetNamedChild("Colonna5ClassTexture"):SetHidden(false)
			else
				v1:GetNamedChild("Colonna5ClassTexture"):SetHidden(true)
			end
			--v1:GetNamedChild("Colonna5ClassTooltip"):SetText(zo_strformat(SI_CLASS_NAME, GetClassName(2, self.Builds[i].class)))
			]]--
			v1:GetNamedChild("Colonna6Label"):SetText(self.Builds[i].rating)

			pre = v1
			i = i + 1
		end
	else
		pre:GetNamedChild("NoBuilds"):SetHidden(false)
	end

	local ii = i
	while el1:GetNamedChild("Dynamic_print_BuildsRow" .. ii) ~= nil do
		local v1 = el1:GetNamedChild("Dynamic_print_BuildsRow" .. ii)
		v1:SetDimensions(0, 0)
		v1:SetHidden(true)
		ii = ii + 1
	end

	--[[
	if #SharedBuildDataVar > 0 and #self.Builds < #SharedBuildDataVar then
		--local ii = i
		--while ii <= #SharedBuildDataVar do
		for ii = i, #SharedBuildDataVar do
			local v1 = el1:GetNamedChild("Dynamic_print_BuildsRow" .. ii)
			if v1 ~= nil then
				v1:SetDimensions(0, 0)
				v1:SetHidden(true)
			end
			ii = ii + 1
		end
	end
	]]--
end

function TUI_Builds:SearchBuilds (searchText)
	self.Filter = searchText
	self.Builds = {}
	local searchTextInsensitive = ""
	if searchText ~= nil and searchText ~= "" then
		searchTextInsensitive = string.lower(searchText)
	end
	local i = 1
    for key, value in pairs(SharedBuildDataVar) do
		local addToBuilds = false
		if searchTextInsensitive == "" then
			addToBuilds = true
		elseif string.find(string.lower(value.owner), searchTextInsensitive) or string.find(string.lower(value.name), searchTextInsensitive) then
			addToBuilds = true
		end
		if addToBuilds then
			self.Builds[i] =
			{
				id = key,
				owner = value.owner,
				name = value.name,
				description = value.description,
				rating = value.rating,
				target = value.target,
				items = value.items,
				race = value.race,
				class = value.class,
				date = value.date
			}
			i = i + 1
		end
    end
	self.SortBuilds(self.Sort)
end

function TUI_Builds.GetBuildTarget (target)
    target = tonumber(target)
    if target > 0 and target <= #TUI_Builds_Target then
        return TUI_Builds_Target[target]
    end
    return "N.D."
end

function TUI_Builds:SortBuilds (field)
	if self.Builds ~= nil and #self.Builds > 0 then
		quicksort(self.Builds, function (v1, v2)
				if v1[field] == v2[field] then
					return v1.rating == v2.rating and (v1.id <= v2.id) or (v1.rating <= v2.rating)
				end
				return (v1[field] <= v2[field])
			end)
	end
    TUI_Builds:FillBuildsList()
end

function TUI_Builds:ShowDetails (buildId, backPage)

	local build = self:Get(buildId)

	--[[
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
	]]--
end