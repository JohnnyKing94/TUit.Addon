TUIT_Validation = ZO_Object:Subclass()

local TUIT_ACCOUNT_VALIDATION_REQUIRED, TUIT_ACCOUNT_VALIDATION_ACTIVATED = 0, 1

function TUIT_Validation:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
	myInstance.isValidated = false
	myInstance.validationStatus = TUIT_ACCOUNT_VALIDATION_REQUIRED;
    return myInstance
end

function TUIT_Validation:Initialize()
	self.Panel = CreateControlFromVirtual("DynamicLabel_Validation", self.control, "DynamicText_Validation", 0)
	self.Panel:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Panel:SetHidden(false)
	local sc = self.Panel:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageConvalida = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelConvalida", sc, "DynamicScrollPageConvalida", 0)
	-- Get the current validation status
	self:LoadValidation()
end

function TUIT_Validation:CreateScene(TUIT_MENU_BAR)
	local TUIT_SCENE_CONVALIDA = ZO_Scene:New("TUit_Validation", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_CONVALIDA:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_CONVALIDA:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_CONVALIDA:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_CONVALIDA:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUIT_VALIDATION_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_VALIDATION_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_CONVALIDA:AddFragment(TUIT_VALIDATION_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUIT_VALIDATION_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUIT_SCENE_CONVALIDA:AddFragment(TUIT_VALIDATION_WINDOW)

	TUIT_SCENE_CONVALIDA:AddFragment(TUIT_MENU_BAR)

	if self.validationStatus == TUIT_ACCOUNT_VALIDATION_ACTIVATED then
		self:AlreadyActivated()
	elseif self.validationStatus == TUIT_ACCOUNT_VALIDATION_REQUIRED then
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
	end
    return TUIT_SCENE_CONVALIDA
end

function TUIT_Validation:LoadValidation()
	self.validationStatus = TUIT_ACCOUNT_VALIDATION_REQUIRED
	self.UserData = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if self.UserData ~= nil then
		if #self.UserData > 0 then
			if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
				self.isValidated = true
				self.validationStatus = TUIT_ACCOUNT_VALIDATION_ACTIVATED
			end
		end
	else
		if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
			self.isValidated = true
			self.validationStatus = TUIT_ACCOUNT_VALIDATION_ACTIVATED
		end
	end
end

function TUIT_Validation:ButtonSend()
	username = TUit_Username:GetText():gsub("%s+", "")
	if username ~= "" then
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(1, 0.945, 0.109, 1)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText(GetString(SI_TUIT_TEXT_VALIDATION_SENDING))
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(false)
		TUit_Username:SetEditEnabled(false)
		local Username_text = TUit_Username:GetText()
		TUit_Username:SetText("")
		self:SaveValidation(Username_text)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.121, 1, 0.054, 1)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText(GetString(SI_TUIT_TEXT_VALIDATION_SENT))
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(true)
		TUit_Username:SetEditEnabled(true)
	else
		TUit_Username:SetText("")
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText(GetString(SI_TUIT_TEXT_VALIDATION_VALID_NAME))
	end
end

function TUIT_Validation:SendValidation()
	self.UserData = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if self.UserData ~= nil then
		if #self.UserData ~= 0 then
			self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
			self:ButtonSend()
		else
			self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
			self:ButtonSend()
		end
	else
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
		self:ButtonSend()
	end
end

function TUIT_Validation:SaveValidation(Username)
	TamrielUnlimitedIT.savedVariablesGlobal.validationUsername = Username
	TamrielUnlimitedIT.ReloadUI_SaveValidation()
	--d(GetString(SI_TUIT_TEXT_VALIDATION_REQUEST_SENT))
end

function TUIT_Validation:AlreadyActivated()
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoRiga1"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoTextBG"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetColor(0.121, 1, 0.054, 1)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetText(GetString(SI_TUIT_TEXT_VALIDATION_VALIDATED))
end
