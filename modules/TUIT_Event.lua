TUIT_Events = ZO_Object:Subclass()

function TUIT_Events:New(control)
    local myInstance = ZO_Object.New(self)
    myInstance.control = control
    return myInstance
end

function TUIT_Events:Initialize()
	self.Events = CreateControlFromVirtual("DynamicLabel_Event", self.control, "DynamicText_Event", 0)
	self.Events:SetAnchor(TOP, self.control, TOP, 0, 0)
	self.Events:SetHidden(false)
	local sc = self.Events:GetNamedChild("ContainerScrollChild")
	self.DynamicScrollPageEventi = CreateControlFromVirtual("Dynamic_print_ScrollPanelEvents", sc, "DynamicScrollPageEventi", 0)
	self.DynamicScrollPageEventiMessage = CreateControlFromVirtual("Dynamic_print_ScrollPanelEventsMessage", sc, "EventMessage", 0)
end

function TUIT_Events:CreateScene(TUIT_MENU_BAR)
	local TUIT_SCENE_EVENTI = ZO_Scene:New("TUit_Event", SCENE_MANAGER)

	-- Assegnazione Background e "componenti" grafici da visualizzare
	-- TUIT_SCENE_EVENTI:AddFragment(ZO_WindowSoundFragment:New(SOUNDS.BACKPACK_WINDOW_OPEN, SOUNDS.BACKPACK_WINDOW_CLOSE))
	TUIT_SCENE_EVENTI:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	TUIT_SCENE_EVENTI:AddFragmentGroup(FRAGMENT_GROUP.PLAYER_PROGRESS_BAR_KEYBOARD_CURRENT)
	TUIT_SCENE_EVENTI:AddFragment(TITLE_FRAGMENT)
	TUIT_SCENE_EVENTI:AddFragment(RIGHT_BG_FRAGMENT)
	TUIT_SCENE_EVENTI:AddFragment(TOP_BAR_FRAGMENT)

	-- Settaggio del titolo
	TUIT_EVENT_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_TUIT_EVENT_TITLE) -- The title at the left of the scene is the "global one" but we can change it
	TUIT_SCENE_EVENTI:AddFragment(TUIT_EVENT_TITLE_FRAGMENT)
	self.control:SetAnchor(TOPLEFT, TITLE_FRAGMENT.control, BOTTOMLEFT, 200, 0)

	-- Aggiunta codice XML alla Scena
	TUIT_EVENT_WINDOW = ZO_FadeSceneFragment:New(self.control)
	TUIT_SCENE_EVENTI:AddFragment(TUIT_EVENT_WINDOW)

	TUIT_SCENE_EVENTI:AddFragment(TUIT_MENU_BAR)

    self:LoadEvents()
    return TUIT_SCENE_EVENTI;
end

--[[function self:Sort()
	quicksort(TamrielUnlimitedIT.TUitDataVar.Events, function (v1, v2) return v1[1] <= v2[1] end)
end]]--

function TUIT_Events:LoadEvents()
	if TamrielUnlimitedIT.TUitDataVar.Events ~= nil and #TamrielUnlimitedIT.TUitDataVar.Events > 0 then
        TUIT_Events.CalculateRepeatsEvents()
        --Sort()
        self:LoadEventsList()
	else
		self:LoadNoEvents()
	end
end

function TUIT_Events:LoadNoEvents()
    local el1 = self.DynamicScrollPageEventi
    local eventMessage = self.DynamicScrollPageEventiMessage
	eventMessage:SetHidden(false)
	el1:SetHidden(true)
	eventMessage:GetNamedChild("Label"):SetText(GetString(SI_TUIT_TEXT_EVENTS_NOEVENTS))
end

function TUIT_Events:LoadEventsList()

    local el1 = self.DynamicScrollPageEventi
    local eventMessage = self.DynamicScrollPageEventiMessage
	local AltezzaComponente = 120
	
	eventMessage:SetHidden(true)
	el1:SetHidden(false)
	
	local pre = el1:GetNamedChild("Label")

	local CurrentTimeStamp = GetTimeStamp() + 7200

	local counterControl = 1

	for i = 1, #TamrielUnlimitedIT.TUitDataVar.Events do

		-- minore della fine
		if (CurrentTimeStamp < TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]) then

			local v1 = el1:GetNamedChild("Dynamic_print_Evento" .. counterControl)
			if v1 == nil then
				v1 = CreateControlFromVirtual("$(parent)Dynamic_print_Evento", el1, "DynamicEvento", counterControl)
			end

			v1:SetDimensions(710, AltezzaComponente)
			v1:SetHidden(false)
			v1:SetAnchor(TOP, pre, BOTTOM, 0, 10)

			DInizio = TimestampToDate(TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"] + 3600)
			DFine = TimestampToDate(TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"] + 3600)

			local OrariTxt = DInizio.ora .. ":"
			if (DInizio.minuto < 10) then
				OrariTxt = OrariTxt .. "0"
			end
			OrariTxt = OrariTxt .. DInizio.minuto .. " - " .. DFine.ora .. ":"
			if (DFine.minuto < 10) then
				OrariTxt = OrariTxt .. "0"
			end
			OrariTxt = OrariTxt .. DFine.minuto

			v1:GetNamedChild("DataLabelGiornoMese"):SetText(DInizio.giorno .. "/" .. DInizio.mese)
			v1:GetNamedChild("DataLabelOrario"):SetText(OrariTxt)
			v1:GetNamedChild("TitoloLabel"):SetText(TamrielUnlimitedIT.TUitDataVar.Events[i]["title"])
			v1:GetNamedChild("TestoRiga1"):SetText(TamrielUnlimitedIT.TUitDataVar.Events[i]["description"])

			pre = v1
			counterControl = counterControl + 1

			-- minore dell'inizio
			if (CurrentTimeStamp < TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]) then
				local diff = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"] - CurrentTimeStamp
				local DDiff = TimestampToDate(diff)
				-- Controllo che l'evento è nelle successive 24 ore
				TamrielUnlimitedIT.ciao = "asd"
				if (diff < 86400) then
					-- Controllo che l'evento non inizia in meno di un ora
					zo_callLater(function ()
							TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", GetString(SI_TUIT_TEXT_EVENTS_STARTED))
						end, diff * 1000)
					if (diff > 3600) then
						zo_callLater(function ()
								TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", GetString(SI_TUIT_TEXT_EVENTS_STARTING_1H))
							end, (diff - 3600) * 1000)
					end
					if (diff > 600) then
						zo_callLater(function ()
								TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", "L'evento inizierà tra 10 minuti!")
							end, (diff - 600) * 1000)
					end
					if ((diff > 661 and diff < 3600) or (diff > 60 and diff < 600)) then
						if (DDiff.minuto == 1) then
							AddPreLoadEvent(TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", GetString(SI_TUIT_TEXT_EVENTS_STARTING_IN_MINUTE)))
						else
							AddPreLoadEvent(TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", GetString(SI_TUIT_TEXT_EVENTS_STARTING_IN_MINUTES):gsub("{MINUTES}", DDiff.minuto)))
						end
					end
				end
			else
				AddPreLoadEvent(TUIT_Events.ShowEventMessage("|cffe823" .. TamrielUnlimitedIT.TUitDataVar.Events[i]["title"] .. "|r", GetString(SI_TUIT_TEXT_EVENTS_LIVENOW)))
			end
		end
	end

	self.DynamicScrollPageEventi:SetDimensions(900, AltezzaComponente * counterControl)

	local ii = counterControl
	while ii <= #TamrielUnlimitedIT.TUitDataVar.Events do
		local v1 = el1:GetNamedChild("Dynamic_print_Evento" .. ii)
		if v1 ~= nil then
			v1:SetDimensions(0, 0)
			v1:SetHidden(true)
		end
		ii = ii + 1
	end

    if counterControl <= 1 then
        self:LoadNoEvents()
    end
end

TUIT_Events.ShowEventMessage = function (Titolo, Corpo)
	CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_DISPLAY_ANNOUNCEMENT, CSA_EVENT_COMBINED_TEXT, SOUNDS.OBJECTIVE_COMPLETED, Titolo, Corpo, 'TamrielUnlimitedIT/textures/calendar.dds', nil, nil, nil, 6000, true)
end

TUIT_Events.CalculateRepeatsEvents = function ()

	local NumeroMaxRipetizioniSeNonSettate = 5
	ArrTemp = {}
	local CurrentTimeStamp = GetTimeStamp() + 7200

	for i = 1, #TamrielUnlimitedIT.TUitDataVar.Events do

		if (TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"] ~= "" and TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"] ~= nil) then
			local ArrRepTemp = {}
			local T1 = explode(";", TamrielUnlimitedIT.TUitDataVar.Events[i]["recurring"])
			for ii = 1, #T1 do
				local T2 = explode("=", T1[ii])
				ArrRepTemp[T2[1]] = T2[2]
			end

			if (ArrRepTemp["FREQ"] ~= nil) then

				if (ArrRepTemp["FREQ"] == "DAILY") then
					-- GIORNALIERO
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])

						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							while (lastITS < DataTermineTS) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end
							end

						elseif (ArrRepTemp["COUNT"] ~= nil) then

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end

							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddDay(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddDay(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "WEEKLY") then
					-- SETTIMANALE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])
						if (ArrRepTemp["BYDAY"] ~= nil) then
							ArrRepTemp["BYDAY"] = explode(",", ArrRepTemp["BYDAY"])

							if (ArrRepTemp["UNTIL"] ~= nil) then
								-- DATA TERMINE
								-- 20150729T220000
								DatTermine = {}
								DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
								DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
								DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
								DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
								DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
								DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

								DataTermineTS = DateToTimestamp(DatTermine)
								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								local cc = 1
								while (lastITS < DataTermineTS) do

									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)
									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)
									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end

									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end

							elseif (ArrRepTemp["COUNT"] ~= nil) then

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								local cc = 1
								-- NUMERO DI RIPETIZIONI
								for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)

									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end

									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end
							else

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]
								local cc = 1

								-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
								local iii = 1
								while (iii <= NumeroMaxRipetizioniSeNonSettate) do

									-- inizio evento
									tt1 = TimestampToDate(lastITS)

									dayCurrent = day_of_the_week_by_date(tt1)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt1, dayNext)
									lastITS = DateToTimestamp(tt1)

									-- fine evento
									tt2 = TimestampToDate(lastFTS)

									dayCurrent = day_of_the_week_by_date(tt2)
									dayNext = n_day_week_from_initials(ArrRepTemp["BYDAY"][cc], 2)

									if (dayCurrent >= dayNext) then
										dayNext = dayNext + 7
									end
									dayNext = dayNext - dayCurrent

									AddDay(tt2, dayNext)
									lastFTS = DateToTimestamp(tt2)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
										iii = iii + 1
									end

									if (cc >= #ArrRepTemp["BYDAY"]) then
										cc = 1
									else
										cc = cc + 1
									end
								end
							end

						else

							if (ArrRepTemp["UNTIL"] ~= nil) then
								-- DATA TERMINE
								-- 20150729T220000
								DatTermine = {}
								DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
								DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
								DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
								DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
								DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
								DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

								DataTermineTS = DateToTimestamp(DatTermine)
								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end

							elseif (ArrRepTemp["COUNT"] ~= nil) then

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								-- NUMERO DI RIPETIZIONI
								for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)

									-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end
							else

								lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
								lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

								-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
								local iii = 1
								while (iii <= NumeroMaxRipetizioniSeNonSettate) do

									tt1 = TimestampToDate(lastITS)
									AddDay(tt1, interval * 7)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddDay(tt2, interval * 7)
									lastFTS = DateToTimestamp(tt2)

									if (lastFTS > CurrentTimeStamp) then
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
										iii = iii + 1
									end
								end
							end
						end
					end

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "MONTHLY") then
					-- MENSILE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])
						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							if (DataTermineTS > CurrentTimeStamp) then
								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddMonth(tt1, interval)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddMonth(tt2, interval)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end
							end

						elseif (ArrRepTemp["COUNT"] ~= nil) then

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddMonth(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddMonth(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end
							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddMonth(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddMonth(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				elseif (ArrRepTemp["FREQ"] == "YEARLY") then
					-- ANNUALE
					if (ArrRepTemp["INTERVAL"] ~= nil) then
						local interval = tonumber(ArrRepTemp["INTERVAL"])
						if (ArrRepTemp["UNTIL"] ~= nil) then
							-- DATA TERMINE
							-- 20150729T220000
							DatTermine = {}
							DatTermine.anno = tonumber(string.sub(ArrRepTemp["UNTIL"], 1, 4))
							DatTermine.mese = tonumber(string.sub(ArrRepTemp["UNTIL"], 5, 6))
							DatTermine.giorno = tonumber(string.sub(ArrRepTemp["UNTIL"], 7, 8))
							DatTermine.ora = tonumber(string.sub(ArrRepTemp["UNTIL"], 10, 11))
							DatTermine.minuto = tonumber(string.sub(ArrRepTemp["UNTIL"], 12, 13))
							DatTermine.secondo = tonumber(string.sub(ArrRepTemp["UNTIL"], 14, 15))

							DataTermineTS = DateToTimestamp(DatTermine)
							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							if (DataTermineTS > CurrentTimeStamp) then
								while (lastITS < DataTermineTS) do

									tt1 = TimestampToDate(lastITS)
									AddYear(tt1, interval)
									lastITS = DateToTimestamp(tt1)

									tt2 = TimestampToDate(lastFTS)
									AddYear(tt2, interval)
									lastFTS = DateToTimestamp(tt2)

									if (lastITS < DataTermineTS and lastFTS > CurrentTimeStamp) then
										-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)
										ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									end
								end
							end

						elseif (ArrRepTemp["COUNT"] ~= nil) then

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI
							for iii = 1, tonumber(ArrRepTemp["COUNT"]) do

								tt1 = TimestampToDate(lastITS)
								AddYear(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddYear(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								-- AddErr(tt2.giorno.."/"..tt2.mese.."/"..tt2.anno)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
								end
							end
						else

							lastITS = TamrielUnlimitedIT.TUitDataVar.Events[i]["start_date"]
							lastFTS = TamrielUnlimitedIT.TUitDataVar.Events[i]["end_date"]

							-- NUMERO DI RIPETIZIONI CON VALORE DI DEFAULT (NumeroMaxRipetizioniSeNonSettate)
							local iii = 1
							while (iii <= NumeroMaxRipetizioniSeNonSettate) do

								tt1 = TimestampToDate(lastITS)
								AddYear(tt1, interval)
								lastITS = DateToTimestamp(tt1)

								tt2 = TimestampToDate(lastFTS)
								AddYear(tt2, interval)
								lastFTS = DateToTimestamp(tt2)

								if (lastFTS > CurrentTimeStamp) then
									ArrTemp[#ArrTemp + 1] = {lastITS, lastFTS, TamrielUnlimitedIT.TUitDataVar.Events[i]["title"], TamrielUnlimitedIT.TUitDataVar.Events[i]["description"], ""}
									iii = iii + 1
								end
							end
						end
					end
				end
			end
		end
	end


	for i = 1, #ArrTemp do
		TamrielUnlimitedIT.TUitDataVar.Events[#TamrielUnlimitedIT.TUitDataVar.Events + 1] = ArrTemp[i]
	end

	-- AddErr(TamrielUnlimitedIT.TUitDataVar.Events)
	-- zo_loadstring("d(\"test\"")()
end
