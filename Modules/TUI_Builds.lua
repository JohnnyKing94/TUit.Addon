TUI_Builds = {}
TUI_Builds.Builds = {}
TUI_Builds.Filter = ""
TUI_Builds.Sort = "id"
TUI_Builds.MaxBuilds = 10
TUI_Builds.LAM = LibStub("LibAddonMenu-2.0")

local TUI_Builds_Target = { "PVE", "PVP", "PVP/PVE" }

ESO_Dialogs["TUIT_DIALOG_SHAREBUILD_NAME"] = 
{
	title =
	{
		text = "Condividi Build",
	},
	mainText = 
	{
		text = "Assegna un Titolo alla build",
	},
	buttons =
	{
		[1] =
		{
			text = SI_OK
		}
	}
}
ESO_Dialogs["TUIT_DIALOG_SHAREBUILD_MAXBUILDS"] = 
{
	title =
	{
		text = "Condividi Build",
	},
	mainText = 
	{
		text = "Hai raggiunto il numero massimo di build condivisibili",
	},
	buttons =
	{
		[1] =
		{
			text = SI_OK
		}
	}
}

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
	-- Initialize SavedVars
	if TamrielUnlimitedIT.savedVariablesGlobal.Builds == nil then
		TamrielUnlimitedIT.savedVariablesGlobal.Builds = { Created = {}, Evaluated = {} }
	else
		if TamrielUnlimitedIT.savedVariablesGlobal.Builds.Created == nil then
			TamrielUnlimitedIT.savedVariablesGlobal.Builds.Created = {}
		end
		if TamrielUnlimitedIT.savedVariablesGlobal.Builds.Evaluated == nil then
			TamrielUnlimitedIT.savedVariablesGlobal.Builds.Evaluated = {}
		end
	end
    -- Initialize UI for Builds screen
    self.BuildsUI = CreateControlFromVirtual("DynamicLabel_screenBuilds", BuildsPanelMainMenu, "DynamicTextBuilds", 0)
	self.BuildsUI:SetAnchor(TOP, BuildsPanelMainMenu, TOP, 0, 0)
	self.BuildsUI:SetHidden(false)
	local container = DynamicLabel_screenBuilds0ContainerScrollChild
	self:InitializeScreenList(container)
	self:InitializeScreenDetails(container)
	self:InitializeScreenShare(container)
end

function TUI_Builds:InitializeScreenList(container)
	self.DynamicScrollPageBuilds = CreateControlFromVirtual("Dynamic_print_ScrollPanelBuilds", container, "DynamicScrollPageBuilds", 0)

	SearchBuild_edit:SetHandler("OnEnter", function (self, key, ctrl, alt, shift, command)
			TUI_Builds:SearchBuilds(SearchBuild_edit:GetText())
		end)
	
	self.FilterTargetDropdown = ZO_ComboBox:New(GetControl(self.DynamicScrollPageBuilds, "TargetDropdown"))
	self.FilterTargetDropdown:SetSortsItems(false)
	self.FilterTargetDropdownSelected = 0
	local function OnFilterTargetChanged(comboBox, name, entry)
		self.FilterTargetDropdownSelected = entry.id
	end
	self.FilterTargetDropdown:AddItem({ name = "<Tutti>", callback = OnFilterTargetChanged, id = 0 }, ZO_COMBOBOX_SUPRESS_UPDATE)
	for i = 1, #TUI_Builds_Target do
		self.FilterTargetDropdown:AddItem({ name = TUI_Builds_Target[i], callback = OnFilterTargetChanged, id = i }, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	self.FilterTargetDropdown:UpdateItems()
	self.FilterTargetDropdown:SelectFirstItem()

	self.FilterRoleDropdown = ZO_ComboBox:New(GetControl(self.DynamicScrollPageBuilds, "RoleDropdown"))
	self.FilterRoleDropdown:SetSortsItems(false)
	self.FilterRoleDropdownSelected = 0
	local function OnFilterRoleChanged(comboBox, name, entry)
		self.FilterRoleDropdownSelected = entry.id
	end
	self.FilterRoleDropdown:AddItem({ name = "<Tutti>", callback = OnFilterRoleChanged, id = 0 }, ZO_COMBOBOX_SUPRESS_UPDATE)
	for i = 1, #TUI_Config.Roles do
		self.FilterRoleDropdown:AddItem({ name = TUI_Config.Roles[i].name, callback = OnFilterRoleChanged, id = i }, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	self.FilterRoleDropdown:UpdateItems()
	self.FilterRoleDropdown:SelectFirstItem()
end

function TUI_Builds:InitializeScreenDetails(container)
	self.DynamicScrollPageBuildDetails = CreateControlFromVirtual("Dynamic_print_ScrollPanelBuildDetails", container, "DynamicScrollPageBuildDetails", 0)
	self.DynamicScrollPageBuildDetails:SetHidden(true)

	self.RateDropdown = ZO_ComboBox:New(GetControl(self.DynamicScrollPageBuildDetails:GetNamedChild("Content"), "RateDropdown"))
	self.RateDropdown:SetSortsItems(false)
	self.RateDropdownSelected = 0
	local function OnRateChanged(comboBox, name, entry)
		self.RateDropdownSelected = entry.id
	end
	for i = 1, 10, 1 do
		self.RateDropdown:AddItem({ name = i, callback = OnRateChanged, id = i }, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	self.RateDropdown:UpdateItems()
	self.RateDropdown:SelectFirstItem()
end

function TUI_Builds:InitializeScreenShare(container)
	self.DynamicScrollPageBuildShare = CreateControlFromVirtual("Dynamic_print_ScrollPanelBuildShare", container, "DynamicScrollPageBuildShare", 0)
	self.DynamicScrollPageBuildShare:SetHidden(true)

	local shareContent = self.DynamicScrollPageBuildShare:GetNamedChild("Content")

	self.ShareTargetDropdown = ZO_ComboBox:New(GetControl(shareContent, "TargetDropdown"))
	self.ShareTargetDropdown:SetSortsItems(false)
	self.ShareTargetDropdownSelected = 0
	local function OnShareTargetChanged(comboBox, name, entry)
		self.ShareTargetDropdownSelected = entry.id
	end
	for i = 1, #TUI_Builds_Target do
		self.ShareTargetDropdown:AddItem({ name = TUI_Builds_Target[i], callback = OnShareTargetChanged, id = i }, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	self.ShareTargetDropdown:UpdateItems()

	self.ShareRoleDropdown = ZO_ComboBox:New(GetControl(shareContent, "RoleDropdown"))
	self.ShareRoleDropdown:SetSortsItems(false)
	self.ShareRoleDropdownSelected = 0
	local function OnShareRoleChanged(comboBox, name, entry)
		self.ShareRoleDropdownSelected = entry.id
	end
	for i = 1, #TUI_Config.Roles do
		self.ShareRoleDropdown:AddItem({ name = TUI_Config.Roles[i].name, callback = OnShareRoleChanged, id = i }, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	self.ShareRoleDropdown:UpdateItems()
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

function TUI_Builds:GetFormattedDateAbbr(date)
	local y,m,d,hh,mm = StringToDateTime(date)
	return d .. " " .. string.upper(GetMonthNameAbbr(m)) .. " " .. y
end

function TUI_Builds:GetFormattedDate(date)
	local y,m,d,hh,mm = StringToDateTime(date)
	return d .. " " .. GetMonthName(m) .. " " .. y
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
			local roleTexture = GetRoleTexture(self.Builds[i].role)

			v1:SetDimensions(900, 40)
			v1:SetHidden(false)
			v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 0)
			v1:GetNamedChild("Colonna0Label"):SetText(self:GetFormattedDateAbbr(self.Builds[i].date))
			v1:GetNamedChild("Colonna1Label"):SetText(TUI_Builds.GetBuildTarget(self.Builds[i].target))
			v1:GetNamedChild("Colonna2Label"):SetText(self.Builds[i].owner)
			v1:GetNamedChild("Colonna3NameButtonLabel"):SetText(self.Builds[i].name)
			v1:GetNamedChild("Colonna3NameButtonLabel"):SetColor(0, 186, 255, 1)
			v1:GetNamedChild("Colonna3NameButtonLabel_BuildID"):SetText(self.Builds[i].id)
			if raceTexture ~= "" then
				local texture = v1:GetNamedChild("Colonna4RaceTexture")
				texture:SetTexture(raceTexture)
				texture:SetDimensions(24, 24)
				texture:SetHidden(false)
				SetToolTip(texture, zo_strformat(SI_RACE_NAME, GetRaceName(2, self.Builds[i].race)))
			else
				v1:GetNamedChild("Colonna4RaceTexture"):SetHidden(true)
			end
			if classTexture ~= "" then
				local texture = v1:GetNamedChild("Colonna5ClassTexture")
				texture:SetTexture(classTexture)
				texture:SetDimensions(24, 24)
				texture:SetHidden(false)
				SetToolTip(texture, zo_strformat(SI_CLASS_NAME, GetClassName(2, self.Builds[i].class)))
			else
				v1:GetNamedChild("Colonna5ClassTexture"):SetHidden(true)
			end
			if roleTexture ~= "" then
				local texture = v1:GetNamedChild("Colonna6RoleTexture")
				texture:SetTexture(roleTexture)
				texture:SetDimensions(24, 24)
				texture:SetHidden(false)
				SetToolTip(texture, GetConfigRoleInfo(self.Builds[i].role).name)
			else
				v1:GetNamedChild("Colonna6RoleTexture"):SetHidden(true)
			end

			self:SetRatingTextures(v1, "Colonna7", self.Builds[i].rating)

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
		local addToBuilds = true
		if searchTextInsensitive ~= "" and not (string.find(string.lower(value.owner), searchTextInsensitive) or string.find(string.lower(value.name), searchTextInsensitive)) then
			addToBuilds = false
		end
		if self.FilterTargetDropdownSelected ~= 0 and value.target ~= self.FilterTargetDropdownSelected then
			addToBuilds = false
		end
		if self.FilterRoleDropdownSelected ~= 0 and value.role ~= self.FilterRoleDropdownSelected then
			addToBuilds = false
		end
		if addToBuilds then
			self.Builds[i] = deepcopy(value)
			self.Builds[i].id = key
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
		if field ~= self.Sort then
			self.Sort = field
			self.SortDir = 1
		else
			self.SortDir = self.SortDir * -1
		end
		quicksort(self.Builds, function (v1, v2)
				if v1[field] == v2[field] then
					return v1.rating == v2.rating and (v1.id <= v2.id) or (v1.rating <= v2.rating)
				end
				return (v1[field] <= v2[field])
			end)
		if self.SortDir < 0 then
			local sortDesc = {}
			local j = 1
			for i = #self.Builds, 1, -1 do
				sortDesc[j] = self.Builds[i]
				j = j + 1
			end
			self.Builds = sortDesc
		end
	end
    TUI_Builds:FillBuildsList()
end

function TUI_Builds:CloseDetails ()
	self.DynamicScrollPageBuildDetails:SetHidden(true)
	self.DynamicScrollPageBuildShare:SetHidden(true)
	self.DynamicScrollPageBuilds:SetHidden(false)
	--ReloadUI()
end

function TUI_Builds:SetRatingTextures(elementUI, ratingRootName, rating)
	local rating_textures = GetRatingTextures(rating)
	for j = 1, 5, 1 do
		local tex = elementUI:GetNamedChild(ratingRootName .. "Rating" .. j)
		if tex ~= nil then
			if j <= #rating_textures then
				tex:SetTexture(rating_textures[j])
				tex:SetHidden(false)
			else
				tex:SetHidden(true)
			end
		end
	end
end

function TUI_Builds:SetupEquipSlot(elementUI, equipSlot, texture, label)
	local slot = elementUI:GetNamedChild("SlotsSlot" .. equipSlot);
	if slot ~= nil then
		if texture ~= nil and texture ~= "" then
			slot:GetNamedChild("Texture"):SetTexture(texture)
		end
		if label == nil or label == "" then
			slot:GetNamedChild("Label"):SetText("")
			slot:GetNamedChild("Texture"):SetAlpha(0.5)
		else
			slot:GetNamedChild("Texture"):SetAlpha(1)
			slot:GetNamedChild("Label"):SetText(label)
		end
	end
end

function TUI_Builds:ShowDetails (buildId)

	local build = self:Get(buildId)

	if build ~= nil then
		
		self.currentBuild = build
		self.DynamicScrollPageBuilds:SetHidden(true)

		local el1 = self.DynamicScrollPageBuildDetails:GetNamedChild("Content")

		-- Load the build data
		el1:GetNamedChild("Name"):SetText(build.name)
		self:SetRatingTextures(el1, "Rating", build.rating)
		el1:GetNamedChild("Author"):SetText("Condivisa da |c885533" .. build.owner .. "|r il |c885533" .. self:GetFormattedDate(build.date) .. "|r")
		if build.description then
			el1:GetNamedChild("Description"):SetText(build.description)
			el1:GetNamedChild("Description"):SetHidden(false)
		else
			el1:GetNamedChild("Description"):SetHidden(true)
		end
		el1:GetNamedChild("RaceTexture"):SetTexture(GetRaceTexture(build.race))
		el1:GetNamedChild("RaceLabel"):SetText(zo_strformat(SI_RACE_NAME, GetRaceName(2, build.race)))
		el1:GetNamedChild("ClassTexture"):SetTexture(GetClassTexture(build.class))
		el1:GetNamedChild("ClassLabel"):SetText(zo_strformat(SI_CLASS_NAME, GetClassName(2, build.class)))
		el1:GetNamedChild("RoleTexture"):SetTexture(GetRoleTexture(build.role))
		el1:GetNamedChild("RoleLabel"):SetText(GetConfigRoleInfo(build.role).name)

		-- Reset the equip slots
		for i = EQUIP_SLOT_MIN_VALUE + 1, EQUIP_SLOT_MAX_VALUE, 1 do
			self:SetupEquipSlot(el1, i, ZO_Character_GetEmptyEquipSlotTexture(i), "")
		end

		-- Load the items in the slots
		if build.items ~= nil then
			for i = 1, #build.items do
				--[[local item = GetItemSetData(build.items[i].code)
				if item ~= nil then
					local slot = TUI_Config.ItemData.slots[build.items[i].slot]
					if slot ~= nil then
						--local text = string.format( "|cBA5AC4%s|r |cC4855A[%s]|r   |c5A99C4%s|r", item.name, item.itemType, item.source )
						local text = item.name
						local icon = GetItemLinkInfo(item.itemLink)
						if icon == nil or icon == "" then
							icon = ZO_Character_GetEmptyEquipSlotTexture(build.items[i].slot)
						end
						self:SetupEquipSlot(el1, build.items[i].slot, icon, text);
					end
				end]]--
				local slot = TUI_Config.ItemData.slots[build.items[i].slot]
				if slot ~= nil then
					--local text = string.format( "|cBA5AC4%s|r |cC4855A[%s]|r   |c5A99C4%s|r", item.name, item.itemType, item.source )
					local text = build.items[i].link
					local icon = GetItemLinkInfo(build.items[i].link)
					if icon == nil or icon == "" then
						icon = ZO_Character_GetEmptyEquipSlotTexture(build.items[i].slot)
					end
					self:SetupEquipSlot(el1, build.items[i].slot, icon, text);
				end
			end
		end

		self.RateDropdown:SelectFirstItem()
		for key, value in pairs(TamrielUnlimitedIT.savedVariablesGlobal.Builds.Evaluated) do
			if key == tostring(buildId) then
				self.RateDropdown:SetSelectedItem(value.rating)
				break
			end
		end

		self.DynamicScrollPageBuildDetails:SetHidden(false)

	end
end

function TUI_Builds:RateBuild()
	if self.currentBuild then
		TamrielUnlimitedIT.savedVariablesGlobal.Builds.Evaluated[tostring(self.currentBuild.id)] = { rating = self.RateDropdownSelected }
		ReloadUI()
	end
end

function TUI_Builds:GetItemDataFromLink(link)
	local name,col,typID,id,qual,levelreq,enchant,ench1,ench2,un1,un2,un3,un4,un5,un6,un7,un8,un9,style,un10,bound,charge,un11=ZO_LinkHandler_ParseLink(link)		
	id = tonumber(id)
	name = zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
	return id,name,enchant,qual,levelreq,typID,ench1,ench2,col,un1,un2,un3,un4,un5,un6,un7,un8,un9,style,un10,bound,charge,un11
end

function TUI_Builds:GetCurrentEquipment ()
	local items = {}
	local itemsId = 0
	for i = EQUIP_SLOT_MIN_VALUE + 1, EQUIP_SLOT_MAX_VALUE, 1 do
		local slot = TUI_Config.ItemData.slots[i];
		if slot and GetItemInstanceId(BAG_WORN, i) then
			itemsId = itemsId + 1
			local itemLink = GetItemLink(BAG_WORN, i)
			local id,name,enchant,qual,levelreq,typID,ench1,ench2,col,un1,un2,un3,un4,un5,un6,un7,un8,un9,style,un10,bound,charge,un11 = self:GetItemDataFromLink(itemLink)
			items[itemsId] = { code = id, slot = i, link = itemLink }
		end
	end
	return items
end

function TUI_Builds:ShowMyBuild ()
	self.DynamicScrollPageBuilds:SetHidden(true)

	local el1 = self.DynamicScrollPageBuildShare:GetNamedChild("Content")

	-- Reset the build data
	ShareBuild_Name:SetText("")
	ShareBuild_Description:SetText("")
	el1:GetNamedChild("RaceTexture"):SetTexture(GetRaceTexture(GetUnitRaceId("player")))
	SetToolTip(el1:GetNamedChild("RaceTexture"), zo_strformat(SI_RACE_NAME, GetRaceName(2, GetUnitRaceId("player"))))
	--el1:GetNamedChild("RaceLabel"):SetText(zo_strformat(SI_RACE_NAME, GetRaceName(2, GetUnitRaceId("player"))))
	el1:GetNamedChild("ClassTexture"):SetTexture(GetClassTexture(GetUnitClassId("player")))
	SetToolTip(el1:GetNamedChild("ClassTexture"), zo_strformat(SI_CLASS_NAME, GetClassName(2, GetUnitClassId("player"))))
	--el1:GetNamedChild("ClassLabel"):SetText(zo_strformat(SI_CLASS_NAME, GetClassName(2, GetUnitClassId("player"))))
	
	self.ShareTargetDropdown:SelectFirstItem()
	self.ShareRoleDropdown:SelectFirstItem()

	-- Reset the equip slots
	for i = EQUIP_SLOT_MIN_VALUE + 1, EQUIP_SLOT_MAX_VALUE, 1 do
		self:SetupEquipSlot(el1, i, ZO_Character_GetEmptyEquipSlotTexture(i), "")
	end

	-- Load the items in the slots
	local items = self:GetCurrentEquipment()
	for i = 1, #items do
		--local item = GetItemSetData(items[i].code)
		local slot = TUI_Config.ItemData.slots[items[i].slot]
		if slot ~= nil then
			local icon = GetItemLinkInfo(items[i].link)
			if icon == nil or icon == "" then
				icon = ZO_Character_GetEmptyEquipSlotTexture(items[i].slot)
			end
			self:SetupEquipSlot(el1, items[i].slot, icon, items[i].link)
		end
	end

	self.DynamicScrollPageBuildShare:SetHidden(false)
end

function TUI_Builds:Share ()
	local name = zo_strtrim(ShareBuild_Name:GetText())
	if name == "" then
		ZO_Dialogs_ShowDialog("TUIT_DIALOG_SHAREBUILD_NAME", nil, nil, false)
	elseif #TamrielUnlimitedIT.savedVariablesGlobal.Builds.Created >= self.MaxBuilds then
		ZO_Dialogs_ShowDialog("TUIT_DIALOG_SHAREBUILD_MAXBUILDS", nil, nil, false)
	else
		local buildId = 1 + #TamrielUnlimitedIT.savedVariablesGlobal.Builds.Created
		TamrielUnlimitedIT.savedVariablesGlobal.Builds.Created[buildId] = {
			name = ShareBuild_Name:GetText(),
			description = zo_strtrim(ShareBuild_Description:GetText()),
			target = self.ShareTargetDropdownSelected,
			race = GetUnitRaceId("player"),
			class = GetUnitClassId("player"),
			role = self.ShareRoleDropdownSelected,
			game_version = GetESOVersionString(),
			items = self:GetCurrentEquipment()
		}
		ReloadUI()
	end
end
