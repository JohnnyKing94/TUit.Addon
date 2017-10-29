TUIT_Guilds = ZO_Object:Subclass()

function TUIT_Guilds:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUIT_Guilds:Initialize()
	self.Guilds = CreateControlFromVirtual("DynamicLabel_Guild", self.control, "DynamicText_Guild", 0)
	self.Guilds:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Guilds:SetHidden(false)
	local sc = self.Guilds:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageGilde = CreateControlFromVirtual("Dynamic_print_ScrollPanelGuilds", sc, "DynamicScrollPageGilde", 0)
end

function TUIT_Guilds:CreateScene(TUIT_MENU_BAR)
	local TUIT_SCENE_GUILD = ZO_Scene:New("TUit_Guild", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_GUILD:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_GUILD:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_GUILD:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_GUILD:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_GUILD:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_GUILD:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUIT_GUILD_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_GUILD_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_GUILD:AddFragment(TUIT_GUILD_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUIT_GUILD_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUIT_SCENE_GUILD:AddFragment(TUIT_GUILD_WINDOW)

	TUIT_SCENE_GUILD:AddFragment(TUIT_MENU_BAR)

	self:LoadGuilds()
    return TUIT_SCENE_GUILD;
end

function TUIT_Guilds:LoadGuilds()
	--local GuildTemp = deepcopy(TUitDataVar.Guild)

    self.GuildADTemp = (TUitDataVar.Guild_AD ~= nil and deepcopy(TUitDataVar.Guild_AD) or {})
	self.GuildDCTemp = (TUitDataVar.Guild_DC ~= nil and deepcopy(TUitDataVar.Guild_DC) or {})
	self.GuildEPTemp = (TUitDataVar.Guild_EP ~= nil and deepcopy(TUitDataVar.Guild_EP) or {})

    local preNoGuilds = self.DynamicScrollPageGilde:GetNamedChild("NOGuilds")

    if #self.GuildADTemp < 1 and #self.GuildDCTemp < 1 and #self.GuildEPTemp < 1 then
        preNoGuilds:SetHidden(false)
        self.DynamicScrollPageGilde:GetNamedChild("AD"):SetHidden(true)
        self.DynamicScrollPageGilde:GetNamedChild("DC"):SetHidden(true)
        self.DynamicScrollPageGilde:GetNamedChild("EP"):SetHidden(true)
        self.DynamicScrollPageGilde:GetNamedChild("NOGuildsLabel"):SetText(GetString(SI_TUIT_TEXT_GUILDS_NOGUILDS))
        do return end
    end

	self.ComponentHeight = 180
	self.PaddingPost = 20
	self.TotalHeight = 0

	preNoGuilds:SetHidden(true)

	-- ALDMERI DOMINION
	local elAD = self.DynamicScrollPageGilde:GetNamedChild("AD")
	elAD:SetHidden(false)
	local preAD = elAD:GetNamedChild("Label")
	preAD:SetColor(0.686, 0.596, 0.223, 1)
	if self.GuildADTemp ~= nil and #self.GuildADTemp > 0 then
        self:LoadGuild(elAD, ALLIANCE_ALDMERI_DOMINION)
	else
		self:LoadNoGuild(elAD, ALLIANCE_ALDMERI_DOMINION)
	end

	-- DAGGERFALL COVENANT
	local elDC = self.DynamicScrollPageGilde:GetNamedChild("DC")
	local preDC = elDC:GetNamedChild("Label")
	preDC:SetColor(0.156, 0.352, 0.631, 1)
	if self.GuildDCTemp ~= nil and #self.GuildDCTemp > 0 then
        self:LoadGuild(elDC, ALLIANCE_DAGGERFALL_COVENANT)
	else
		self:LoadNoGuild(elDC, ALLIANCE_DAGGERFALL_COVENANT)
	end

	-- EBONHEART PACT
	local elEP = self.DynamicScrollPageGilde:GetNamedChild("EP")
	local preEP = elEP:GetNamedChild("Label")
	preEP:SetColor(0.647, 0.141, 0.101, 1)
	if self.GuildEPTemp ~= nil and #self.GuildEPTemp > 0 then
        self:LoadGuild(elEP, ALLIANCE_EBONHEART_PACT)
	else
		self:LoadNoGuild(elEP, ALLIANCE_EBONHEART_PACT)
	end

	-- 280 somma delle altezze dei component prima di quelli dinamici
	self.DynamicScrollPageGilde:SetDimensions(900, self.TotalHeight + 280)
end

function TUIT_Guilds:LoadNoGuild(el, alliance)
	el:GetNamedChild("NoGuild"):SetHidden(false)
	--el:GetNamedChild("NoGuildLabel"):SetText(GetString(SI_TUIT_TEXT_GUILDS_NOGUILDS_IN_ALLIANCE) .. " " .. zo_strformat(SI_ALLIANCE_NAME, GetAllianceName(alliance)))
	el:GetNamedChild("NoGuildLabel"):SetText(GetString(SI_TUIT_TEXT_GUILDS_NOGUILDS_IN_ALLIANCE))
end

function TUIT_Guilds:LoadGuild(el, alliance)
	el:GetNamedChild("NoGuild"):SetHidden(true)
    local pre = el:GetNamedChild("Label")
    local tempList
    if alliance == ALLIANCE_ALDMERI_DOMINION then
        tempList = self.GuildADTemp
    elseif alliance == ALLIANCE_DAGGERFALL_COVENANT then
        tempList = self.GuildDCTemp
    elseif alliance == ALLIANCE_EBONHEART_PACT then
        tempList = self.GuildEPTemp
    end
	self.TotalHeight = self.TotalHeight + (self.ComponentHeight * #tempList) + pre:GetHeight() + self.PaddingPost
	el:SetDimensions(710, (self.ComponentHeight * #tempList) + pre:GetHeight() + self.PaddingPost)

	local i = 1
	while i <= #tempList do
		local v1 = el:GetNamedChild("Dynamic_print_Gilda_" .. alliance .. "_" .. i)
		if v1 == nil then
			v1 = CreateControlFromVirtual("$(parent)Dynamic_print_Gilda_" .. alliance .. "_", el, "DynamicGilda", i)
		end

		v1:SetDimensions(710, self.ComponentHeight)
		v1:SetHidden(false)
		v1:SetAnchor(TOP, pre, BOTTOM, 0, 10)

		v1:GetNamedChild("TitoloLabel"):SetText(tempList[i]["guild_name"])
		v1:GetNamedChild("TitoloLabel"):SetColor(GetColorForAlliance(alliance):UnpackRGBA())
		v1:GetNamedChild("TestoEditBox"):SetText(tempList[i]["description"])
		v1:GetNamedChild("LogoTexture"):SetTexture(tempList[i]["image"])
		v1:GetNamedChild("GuildMasterBtnLabel"):SetText(tempList[i]["guild_master"])
		v1:GetNamedChild("GuildMasterBtnLabel_UserID"):SetText(tempList[i]["guild_master"])

		pre = v1
		i = i + 1
	end

	local ii = i
	while ii <= #tempList do
		local v1 = el:GetNamedChild("Dynamic_print_Gilda_" .. alliance .. "_" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end
end
