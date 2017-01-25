TUI_Validator = ZO_Object:Subclass()

local TUI_ACCOUNT_VALIDATION_REQUIRE, TUI_ACCOUNT_VALIDATION_REFUSED, TUI_ACCOUNT_VALIDATION_ACTIVATED = 0, 1, 2

function TUI_Validator:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
	myInstance.isValidated = false
	myInstance.validationStatus = TUI_ACCOUNT_VALIDATION_REQUIRE;
    return myInstance
end

function TUI_Validator:Initialize()
	self.Panel = CreateControlFromVirtual("DynamicLabel_stampataConvalida", self.control, "DynamicTextConvalida", 0)
	self.Panel:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Panel:SetHidden(false)
	local sc = self.Panel:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageConvalida = CreateControlFromVirtual("Dynamic_stampa_ScrollPanelConvalida", sc, "DynamicScrollPageConvalida", 0)
	-- Get the current validation status
	self:LoadValidation()
end

function TUI_Validator:CreateScene(TUI_MENU_BAR)
	local TUI_SCENE_CONVALIDA = ZO_Scene:New("TuiConvalida", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUI_SCENE_CONVALIDA:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUI_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUI_SCENE_CONVALIDA:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUI_SCENE_CONVALIDA:AddFragment(TITLE_FRAGMENT)
	TUI_SCENE_CONVALIDA:AddFragment(RIGHT_BG_FRAGMENT)
	TUI_SCENE_CONVALIDA:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUI_CONVALIDA_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUI_CONVALIDA_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUI_SCENE_CONVALIDA:AddFragment(TUI_CONVALIDA_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUI_CONVALIDA_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUI_SCENE_CONVALIDA:AddFragment(TUI_CONVALIDA_WINDOW)

	TUI_SCENE_CONVALIDA:AddFragment(TUI_MENU_BAR)

	if self.validationStatus == TUI_ACCOUNT_VALIDATION_REFUSED then
		self:LoadRefusedValidations()
	elseif self.validationStatus == TUI_ACCOUNT_VALIDATION_ACTIVATED then
		self:AlreadyActivated()
	elseif self.validationStatus == TUI_ACCOUNT_VALIDATION_REQUIRE then
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(true)
	end
    
    return TUI_SCENE_CONVALIDA
end

function TUI_Validator:LoadValidation()
	self.validationStatus = TUI_ACCOUNT_VALIDATION_REQUIRE
	self.DettagliArray = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if self.DettagliArray ~= nil then
		if #self.DettagliArray ~= 0 then
			self.validationStatus = TUI_ACCOUNT_VALIDATION_REFUSED
		else
			if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
				self.isValidated = true
				self.validationStatus = TUI_ACCOUNT_VALIDATION_ACTIVATED
			end
		end
	else
		if (TUitDataVar.PlayersData[GetDisplayName()] ~= nil) then
			self.isValidated = true
			self.validationStatus = TUI_ACCOUNT_VALIDATION_ACTIVATED
		end
	end
end

function TUI_Validator:ButtonSend()
	str = NomeUtenteForum:GetText():gsub("%s+", "")
	if str ~= "" then
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(1, 0.945, 0.109, 1)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Invio in Corso...")
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(false)
		NomeUtenteForum:SetEditEnabled(false)
		local delay = 2000
		local NomeUtForumLocal = NomeUtenteForum:GetText()
		if TUitDataVar.Admins ~= nil then
			if #TUitDataVar.Admins ~= 0 then
				for i = 1, #TUitDataVar.Admins do
					NomeUtenteForum:SetText("")
					zo_callLater(function () self:SendMyMail(TUitDataVar.Admins[i], NomeUtForumLocal) end, delay)
					delay = delay + 2000
				end
				zo_callLater(function ()
						self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.121, 1, 0.054, 1)
						self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Invio Completato")
						self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetEnabled(true)
						NomeUtenteForum:SetEditEnabled(true)
					end, delay)
			else
			NomeUtenteForum:SetText("")
			self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
			self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Impossibile inviare alcuna mail!\n\rAggiornare i file dati addon dall'app")
			end
		else
			NomeUtenteForum:SetText("")
			self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
			self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Impossibile inviare alcuna mail!\n\rAggiornare i file dati addon dall'app")
		end
	else
		NomeUtenteForum:SetText("")
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetColor(0.996, 0.062, 0.062, 1)
		self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaLabelMsg"):SetText("Inserire un Nome Utente valido")
	end
end

function TUI_Validator:SendValidationMail()
	self.DettagliArray = TamrielUnlimitedIT.TUitDataVar.RefusedValidations
	if self.DettagliArray ~= nil then
		if #self.DettagliArray ~= 0 then
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

function TUI_Validator:SendMyMail(NomeAdmin, NomeForum)
	RequestOpenMailbox()
	SendMail(NomeAdmin, "RA_Addon - " .. NomeForum, "Richiesta Attivazione per " .. NomeForum)
	CloseMailbox()
end

function TUI_Validator:LoadRefusedValidations()
	local pre = self.DynamicScrollPageConvalida:GetNamedChild("Label")
	
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoRiga1"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetDimensions(800, (110 + (#self.DettagliArray*28)))
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):SetDimensions(800, #self.DettagliArray*50)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgLabelRefused"):SetText("Attenzione!")
	if #self.DettagliArray == 1 then
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgTextRefused"):SetText("Hai già realizzato un tentativo, sottocitato, che è fallito nel processo di convalida. Si prega di inserire il Nome Utente corretto del sito e cliccare RIPROVA!")
	else
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgTextRefused"):SetText("Hai già realizzato dei tentativi, sottocitati, che sono falliti nel processo di convalida. Si prega di inserire il Nome Utente corretto del sito e cliccare RIPROVA!")
	end
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvioLabel_Convalida"):SetText("Riprova")
	self.DynamicScrollPageConvalida:GetNamedChild("ContTesto"):SetAnchor(TOP, pre, BOTTOM, 0, 80 + #self.DettagliArray*25)
	local i = 1
	for key, value in pairs(self.DettagliArray) do
		ForumName = TamrielUnlimitedIT.TUitDataVar.RefusedValidations[i]["ForumName"]
		Reason = TamrielUnlimitedIT.TUitDataVar.RefusedValidations[i]["Reason"]
		
		if (value.ForumName ~= "" and value.Reason == "UnknowUsername" ) then
			value.Reason = "Il nome utente del sito, " .. value.ForumName .. ", non esiste"
		end
		
		if (value.ForumName == "" and value.Reason == "AccountAlreadyUsed" ) then
			value.Reason = "L'account " .. GetDisplayName() .. " risulta essere già in uso e convalidato da un altro nome utente"
		end
		
		self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):SetText(TamrielUnlimitedIT.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgRefusedValidations"):GetText() .. "- " .. value.Reason .. "\r\n")
		i = i + 1
	end
end

function TUI_Validator:AlreadyActivated()
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsg"):SetHidden(false)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoRiga1"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoTextBG"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ContTestoConvalidaButtonInvio"):SetHidden(true)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetColor(0.121, 1, 0.054, 1)
	self.DynamicScrollPageConvalida:GetNamedChild("ConvalidaMsgAlreadyActivated"):SetText("Il tuo account è gia stato convalidato")
end
