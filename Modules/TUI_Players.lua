
TUI_Players = ZO_Object:Subclass()

function TUI_Players:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    myInstance:ClearArrayPlayerTemp()
    return myInstance
end

function TUI_Players:Initialize()
    self.PlayerTemp = {}
    self.Panel = CreateControlFromVirtual("DynamicLabel_screenUtenti", self.control, "DynamicTextUtenti", 0)
	self.Panel:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Panel:SetHidden(false)
    local sc = self.Panel:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPagePlayer = CreateControlFromVirtual("Dynamic_print_ScrollPanelUtenti", sc, "DynamicScrollPageUtenti", 0)
	if self.PlayerTemp ~= nil then
		if #self.PlayerTemp ~= 0 then
			self:SortCP()
		else
			self:LoadNoPlayer()
		end
	else
		self:LoadNoPlayer()
	end

	SearchPlayer_edit:SetHandler("OnEnter", function (btn, key, ctrl, alt, shift, command)
			self:SearchPlayer(SearchPlayer_edit:GetText())
		end)
	self:LoadArrayPlayerTemp()
end

function TUI_Players:CreateScene(TUI_MENU_BAR)
	-- Creazione Scena Utenti
	local TUI_SCENE_UTENTI = ZO_Scene:New("TuiUtenti", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_UTENTI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_UTENTI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_UTENTI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_UTENTI:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_UTENTI:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_UTENTI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_UTENTI_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_UTENTI_TITLE)
	TUI_SCENE_UTENTI:AddFragment(TUI_UTENTI_TITLE_FRAGMENT)

	-- Aggiunta codice XML alla Scena
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	TUI_UTENTI_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUI_SCENE_UTENTI:AddFragment(TUI_UTENTI_WINDOW)

	TUI_SCENE_UTENTI:AddFragment(TUI_MENU_BAR)

	-- Access granted only to validated users
	if TamrielUnlimitedIT.Validator == nil or not TamrielUnlimitedIT.Validator.isValidated then
		self.DynamicScrollPagePlayer:SetHidden(true)
		local sc = self.Panel:GetNamedChild("ContainerScrollChild")
		CreateControlFromVirtual("PlayersRequireAccountValidationControlUsers", sc, "RequireAccountValidationControl", 0)
	else
    	self:Sort("pg_name", 1)
	end

    return TUI_SCENE_UTENTI;
end

function TUI_Players:LoadNoPlayer()
	local el1 = self.DynamicScrollPagePlayer:GetNamedChild("List")
	local pre = el1:GetNamedChild("print_Row0")
	--[[local searchcontrol = self.DynamicScrollPagePlayer:GetNamedChild("Search_control")
	local searchbtn = self.DynamicScrollPagePlayer:GetNamedChild("Search_btn")
	pre:GetNamedChild("NOPG"):SetHidden(false)
	searchcontrol:SetHidden(true)
	searchbtn:SetHidden(true)
	pre:GetNamedChild("Colonna0"):SetHidden(true)
	pre:GetNamedChild("Colonna1"):SetHidden(true)
	pre:GetNamedChild("Colonna2"):SetHidden(true)
	pre:GetNamedChild("Colonna3"):SetHidden(true)
	pre:GetNamedChild("Colonna4"):SetHidden(true)
	pre:GetNamedChild("Colonna5"):SetHidden(true)
	pre:GetNamedChild("Colonna6"):SetHidden(true)]]--
	pre:GetNamedChild("NOPGLabel"):SetText(GetString(SI_TUI_TEXT_NO_USERS))
end

function TUI_Players:Sort(field, sortDir)
    if self.PlayerTemp ~= nil and #self.PlayerTemp > 0 then
        if sortDir == nil then
			if self.SortDir == nil then
				self.SortDir = -1
			end
            sortDir = (self.SortField ~= field and 1 or (-1 * self.SortDir))
        end
        self.SortField = field
        self.SortDir = sortDir
        quicksort(self.PlayerTemp, function (v1, v2)
				if v1[field] == v2[field] then
					return (v1.lev <= v2.lev)
				end
				return (v1[field] <= v2[field])
			end)
        if self.SortDir < 0 then
            local sortDesc = {}
            local j = 1
            for i = #self.PlayerTemp, 1, -1 do
                sortDesc[j] = self.PlayerTemp[i]
                j = j + 1
            end
            self.PlayerTemp = sortDesc
        end
    end
    self:FillBuildsList()
end

function TUI_Players:ClearArrayPlayerTemp()
	--[[for k in pairs(self.PlayerTemp) do
		self.PlayerTemp[k] = nil
	end]]--
    self.PlayerTemp = {}
end
function TUI_Players:LoadArrayPlayerTemp()
	self:ClearArrayPlayerTemp()
	self.PlayerTemp = deepcopy(TUitDataVar.Player)
end

function TUI_Players:SearchPlayer(searchText)
	if searchText == "" then
		self:LoadArrayPlayerTemp()
	else
		self:ClearArrayPlayerTemp()
		local c = 1
        local insensitiveSearch = searchText:lower()
		for i = 1, #TUitDataVar.Player do
            if string.find(TUitDataVar.Player[i]["pg_name"]:lower(), insensitiveSearch) ~= nil then
				self.PlayerTemp[c] = deepcopy(TUitDataVar.Player[i])
				c = c + 1
			end
		end
	end
	self:Sort(self.SortField, self.SortDir)
end

function TUI_Players:FillBuildsList()
	ChiudiAddRemoveFriend()

	self.DynamicScrollPagePlayer:SetDimensions(900, 20 * #self.PlayerTemp + 50)
	self.DynamicScrollPagePlayer:GetNamedChild("List"):SetDimensions(900, 20 * #self.PlayerTemp + 50)

	local el1 = self.DynamicScrollPagePlayer:GetNamedChild("List")
	local pre = el1:GetNamedChild("print_Row0")
	local searchcontrol = self.DynamicScrollPagePlayer:GetNamedChild("Search_control")
	local searchbtn = self.DynamicScrollPagePlayer:GetNamedChild("Search_btn")
	
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
	while i <= #self.PlayerTemp do
		
		local v1 = el1:GetNamedChild("Dynamic_print_Row" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_print_Row", el1, "DynamicRow", i)
		end

		local colorPG = GetColorForLevel(self.PlayerTemp[i]["lev"])
		local raceTexture = GetRaceTexture(self.PlayerTemp[i]["race"])
		local classTexture = GetClassTexture(self.PlayerTemp[i]["class"])
		
		v1:SetDimensions(900, 40)
		v1:SetHidden(false)
		v1:SetAnchor(TOPLEFT, pre, BOTTOMLEFT, 0, 0)
		v1:GetNamedChild("Colonna0Label"):SetText(self.PlayerTemp[i]["lev"])
		v1:GetNamedChild("Colonna0Label"):SetColor(colorPG:UnpackRGBA())
		v1:GetNamedChild("Colonna1Label"):SetText(self.PlayerTemp[i]["CP"] > 0 and self.PlayerTemp[i]["CP"] or "")
		v1:GetNamedChild("Colonna1Label"):SetColor(colorPG:UnpackRGBA())
		--v1:GetNamedChild("Colonna2Label"):SetText(GetString("SI_GENDER", self.PlayerTemp[i]["sex"]) .. "(RL: " .. (self.PlayerTemp[i]["real_sex"] > 0 and string.sub(GetString("SI_GENDER", self.PlayerTemp[i]["real_sex"]), 1, 1) or "-") .. ")")
		v1:GetNamedChild("Colonna2Label"):SetText(GetString("SI_GENDER", self.PlayerTemp[i]["sex"]))
		v1:GetNamedChild("Colonna2Label"):SetColor(GetColorForSex(self.PlayerTemp[i]["sex"]):UnpackRGBA())
		v1:GetNamedChild("Colonna3Label"):SetText(self.PlayerTemp[i]["pg_name"])
		--v1:GetNamedChild("Colonna3Label"):SetColor(0, 186, 255, 1)
		v1:GetNamedChild("Colonna3Label"):SetColor(colorPG:UnpackRGBA())
		v1:GetNamedChild("Colonna3Label_UserID"):SetText(self.PlayerTemp[i]["userid"])
		if raceTexture ~= "" then
			local texture = v1:GetNamedChild("Colonna4RaceTexture")
			texture:SetTexture(raceTexture)
			texture:SetDimensions(24, 24)
			texture:SetHidden(false)
			SetToolTip(texture, GetString(SI_TUI_TEXT_RACE) .. ": " .. zo_strformat(SI_RACE_NAME, GetRaceName(self.PlayerTemp[i]["sex"], self.PlayerTemp[i]["race"])))
		else
			v1:GetNamedChild("Colonna4RaceTexture"):SetHidden(true)
		end
		if classTexture ~= "" then
			local texture = v1:GetNamedChild("Colonna5ClassTexture")
			texture:SetTexture(classTexture)
			texture:SetDimensions(24, 24)
			texture:SetHidden(false)
			SetToolTip(texture, GetString(SI_TUI_TEXT_CLASS) .. ": " .. zo_strformat(SI_CLASS_NAME, GetClassName(self.PlayerTemp[i]["sex"], self.PlayerTemp[i]["class"])))
		else
			v1:GetNamedChild("Colonna5ClassTexture"):SetHidden(true)
		end
		v1:GetNamedChild("Colonna6Label"):SetText(zo_strformat(GetString("SI_ALLIANCE", self.PlayerTemp[i]["alli"])))

		if self.PlayerTemp[i]["alli"] == 2 then
			v1:GetNamedChild("Colonna6Label"):SetColor(0.647, 0.141, 0.101, 1)
		elseif self.PlayerTemp[i]["alli"] == 1 then
			v1:GetNamedChild("Colonna6Label"):SetColor(0.686, 0.596, 0.223, 1)
		else
			v1:GetNamedChild("Colonna6Label"):SetColor(0.156, 0.352, 0.631, 1)
		end

		pre = v1
		i = i + 1
	end

	local ii = i
	while ii <= #TUitDataVar.Player do
		local v1 = el1:GetNamedChild("Dynamic_print_Row" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end

	if #self.PlayerTemp == 0 then
		self:LoadNoPlayer()
	end
end
