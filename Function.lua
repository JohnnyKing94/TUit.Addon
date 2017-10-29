Week={}
Week[1]={"LU","MO"}
Week[2]={"MA","TU"}
Week[3]={"ME","WE"}
Week[4]={"GI","TH"}
Week[5]={"VE","FR"}
Week[6]={"SA","SA"}
Week[7]={"DO","SU"}


--TABLE
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        --[[for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))]]--
		ZO_DeepTableCopy(orig, copy)
    else
        copy = orig
    end
    return copy
end
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        --[[for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end]]--
		ZO_ShallowTableCopy(orig, copy)
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

--STRING
function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1))
    pos = sp + 1
  end
  table.insert(arr,string.sub(str,pos))
  return arr
end
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
function split_to_array(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--DATE
function TimestampToDate(ts)
	local s = ts%86400
	local ts = math.floor(ts/ 86400)
	local h = math.floor(s/3600)
	local m = math.floor(s/60)%60
	local s = s%60
	local x = math.floor((ts*4+102032)/146097)+15
	local b = ts+2442113+x-math.floor(x/4)
	local c = math.floor((b*20-2442)/7305)
	local dd = b-365*c-math.floor(c/4)
	local e = math.floor(dd*1000/30601)
	local f = dd-e*30-math.floor(e*601/1000)
	local arr={}
	if e < 14 then
		arr.anno=c-4716
		arr.mese=e-1
		arr.giorno=f
		arr.ora=h
		arr.minuto=m
		arr.secondo=s
	else  
		arr.anno=c-4715
		arr.mese=e-13
		arr.giorno=f
		arr.ora=h
		arr.minuto=m
		arr.secondo=s
	end
	return arr
end
function DateToTimestamp(dat)
	local s=dat.secondo
	local mi= dat.minuto
	local h=dat.ora
	local dd=dat.giorno
	local m=dat.mese
	local y=dat.anno
	if m <= 2 then
		y =y- 1
		m =m+ 12 
	end
	return (365*y +  math.floor(y/4) -  math.floor(y/100) +  math.floor(y/400) +  math.floor((3*(m+1))/5) + 30*m + dd - 719561) *  86400 + 3600 * h + 60 * mi + s
end
function days_in_month(month, year)
	if(month == 2 ) then
		if(year % 4 ==0) then
			if(year % 100 ==0) then
				if(year % 400 ==0) then
					return 29
				else
					return 28
				end
			else
				return 29
			end
		else
			return 28
		end
	else
		if((month - 1) % 7 % 2==0) then
			return 31
		else
			return 30
		end
	end
end
function day_of_the_week_by_date(dat)
	local gg=dat.giorno
	local mm=dat.mese
	local yy=dat.anno
	local t={0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if(mm<=2) then
		yy=yy-1
	end
    return ((((yy + math.floor(yy/4) - math.floor(yy/100) +math.floor(yy/400) + t[mm] + gg) % 7)+6)%7)+1;
end
function day_of_the_week_by_numeber(n)
    return Week[n%7]
end
-- 1 = ita | 2 = eng
function n_day_week_from_initials(initials,lang)
	for i=1,#Week do
		if(Week[i][lang]==initials ) then
			return i
		end
	end
	return -1
end
function DateToDayNumber(dat)
	local m=dat.mese
	local y=dat.anno
	local dd=dat.giorno
	local m = (m + 9) % 12
	local y = y - m/10
	return 365*y + math.floor(y/4) - math.floor(y/100) + math.floor(y/400) + math.floor((m*306 + 5)/10) + ( dd - 1 )
end
function isValidDate(dat)
	if(dat.mese<=0 or dat.mese>=13) then
		return false
	elseif(dat.secondo<0 or dat.secondo>=60) then
		return false
	elseif(dat.minuto<0 or dat.minuto>=60) then
		return false
	elseif(dat.ora<0 or dat.ora>=24) then
		return false
	elseif(dat.ora<0 or dat.ora>=24) then
		return false
	elseif(dat.giorno<0 or dat.giorno> days_in_month(dat.mese,dat.anno)) then
		return false
	end
	return true
end
function AddDay(dat,n)
	if isValidDate(dat) then 
		dat.giorno=dat.giorno+n
		while(isValidDate(dat)==false) do
			DiM=days_in_month(dat.mese,dat.anno)
			dat.giorno=dat.giorno-DiM
			AddMonth(dat,1)
		end
	end
end
function AddMonth(dat,n)
	if isValidDate(dat) then
		dat.mese=dat.mese+n
		while(not isValidDate(dat)) do
			if(dat.mese>12) then
				dat.mese=dat.mese-12
				AddYear(dat,1)
			else
				dat.mese=dat.mese+1
			end
		end
	end 
end
function AddYear(dat,n)
	if isValidDate(dat) then 
		dat.anno=dat.anno+n
		while(not isValidDate(dat)) do
			AddYear(dat,1)
		end
	end 
end
function StringToDate(date_str)
	local date_fixed = date_str:gsub("[/]", "-"):gsub("[.]", ":")
	local _,_,y,m,d=string.find(date_fixed, "(%d+)-(%d+)-(%d+)")
	return tonumber(y),tonumber(m),tonumber(d)
end
function StringToDateTime(date_str)
	local date_fixed = date_str:gsub("[/]", "-"):gsub("[.]", ":")
	local _,_,y,m,d,hh,mm=string.find(date_fixed, "(%d+)-(%d+)-(%d+) (%d+):(%d+)")
	return tonumber(y),tonumber(m),tonumber(d),tonumber(hh),tonumber(mm)
end
function StringToDateTimeSeconds(date_str)
	local date_fixed = date_str:gsub("[/]", "-"):gsub("[.]", ":")
	local _,_,y,m,d,hh,mm,ss=string.find(date_fixed, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
	return tonumber(y),tonumber(m),tonumber(d),tonumber(hh),tonumber(mm),tonumber(ss)
end
function GetMonthName(month)
	local months =
	{
		GetString(SI_TUIT_TEXT_MONTH_1),
		GetString(SI_TUIT_TEXT_MONTH_2),
		GetString(SI_TUIT_TEXT_MONTH_3),
		GetString(SI_TUIT_TEXT_MONTH_4),
		GetString(SI_TUIT_TEXT_MONTH_5),
		GetString(SI_TUIT_TEXT_MONTH_6),
		GetString(SI_TUIT_TEXT_MONTH_7),
		GetString(SI_TUIT_TEXT_MONTH_8),
		GetString(SI_TUIT_TEXT_MONTH_9),
		GetString(SI_TUIT_TEXT_MONTH_10),
		GetString(SI_TUIT_TEXT_MONTH_11),
		GetString(SI_TUIT_TEXT_MONTH_12)
	}
	return months[tonumber(month)]
end
function GetMonthNameAbbr(month)
	local months =
	{
		GetString(SI_TUIT_TEXT_MONTH_ABBR_1),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_2),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_3),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_4),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_5),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_6),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_7),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_8),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_9),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_10),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_11),
		GetString(SI_TUIT_TEXT_MONTH_ABBR_12)
	}
	return months[tonumber(month)]
end

-- GAME
function SetToolTip(ctrl, text)
	ctrl:SetHandler("OnMouseEnter", function(self)
		ZO_Tooltips_ShowTextTooltip(self, TOP, text)
	end)
	ctrl:SetHandler("OnMouseExit", function(self)
		ZO_Tooltips_HideTextTooltip()
	end)
end
function GetConfigRaceInfo(raceId)
	if TUIT_Config ~= nil then
		if TUIT_Config.Races ~= nil then
			for key, value in pairs(TUIT_Config.Races) do
				if value.id == raceId then
					return value
				end
			end
		end
	end
	return nil
end
function GetConfigClassInfo(classId)
	if TUIT_Config ~= nil then
		if TUIT_Config.Classes ~= nil then
			for key, value in pairs(TUIT_Config.Classes) do
				if value.id == classId then
					return value
				end
			end
		end
	end
	return nil
end
function GetConfigRoleInfo(roleId)
	if TUIT_Config and TUIT_Config.Roles then
		for i = 1, #TUIT_Config.Roles do
			if i == roleId then
				return TUIT_Config.Roles[i]
			end
		end
	end
	return nil
end
function GetRaceTexture(raceId)
	local raceInfo = GetConfigRaceInfo(raceId)
	if raceInfo ~= nil then
		return (raceInfo.texture ~= "" and "TamrielUnlimitedIT/textures/Race/" .. raceInfo.texture or "")
	end
	return ""
end
function GetClassTexture(classId)
	local classInfo = GetConfigClassInfo(classId)
	if classInfo ~= nil then
		return (classInfo.texture ~= "" and "TamrielUnlimitedIT/textures/Class/" .. classInfo.texture or "")
	end
	return ""
end
function GetRoleTexture(roleId)
	local roleInfo = GetConfigRoleInfo(roleId)
	if roleInfo ~= nil and roleInfo.texture ~= nil then
		return "TamrielUnlimitedIT/textures/Role/" .. roleInfo.texture
	end
	return ""
end
function GetRatingTextures(rating)
	local full = 0
	local half = 0
	for i = 0, 10, 1 do
		if i > 0 and i <= rating then
			half = half + 1
			if half == 2 then
				full = full + 1
				half = 0
			end
		end
	end
	local textures = {}
	local texture_index = 1
	if full > 0 then
		for i = 1, full do
			textures[texture_index] = "TamrielUnlimitedIT/textures/star-full.dds"
			texture_index = texture_index + 1
		end
	end
	if half > 0 then
		textures[texture_index] = "TamrielUnlimitedIT/textures/star-half.dds"
	end
	return textures
end
function CheckItemSetFlag( flags, flagToCheck )
	-- Lua is a scrub language with no native bitwise operators
	return(math.floor(flags / flagToCheck) % 2 == 1);
end
function MakeItemSetLink( id, flags )
	local quality = 364;
	local crafted = 0;
	local health = 10000;

	if (CheckItemSetFlag(flags, TUIT_Config.ItemData.flags.crafted)) then
		quality = 370;
		crafted = 1;
	elseif (CheckItemSetFlag(flags, TUIT_Config.ItemData.flags.jewelry)) then
		quality = 363;
		health = 0;
	elseif (CheckItemSetFlag(flags, TUIT_Config.ItemData.flags.weapon)) then
		health = 500;
	end

	local style = ITEMSTYLE_NONE;

	if (CheckItemSetFlag(flags, TUIT_Config.ItemData.flags.allianceStyle)) then
		local allianceStyles = {
			[ALLIANCE_NONE]                = ITEMSTYLE_NONE,
			[ALLIANCE_ALDMERI_DOMINION]    = ITEMSTYLE_ALLIANCE_ALDMERI,
			[ALLIANCE_EBONHEART_PACT]      = ITEMSTYLE_ALLIANCE_EBONHEART,
			[ALLIANCE_DAGGERFALL_COVENANT] = ITEMSTYLE_ALLIANCE_DAGGERFALL,
		};
		style = allianceStyles[GetUnitAlliance("player")];
	elseif (CheckItemSetFlag(flags, TUIT_Config.ItemData.flags.multiStyle)) then
		local multiStyle = GetUnitRaceId("player");
		if multiStyle == 10 then
			multiStyle = ITEMSTYLE_RACIAL_IMPERIAL
		end
		style = multiStyle;
	end

	local itemLink = string.format("|H1:item:%d:%d:50:0:0:0:0:0:0:0:0:0:0:0:0:%d:%d:0:0:%d:0|h|h", id, quality, style, crafted, health);

	if (crafted == 1) then
		-- Attach an enchantment to crafted gear
		local enchantments = {
			[ARMORTYPE_NONE]   = 0,
			[ARMORTYPE_HEAVY]  = 26580,
			[ARMORTYPE_LIGHT]  = 26582,
			[ARMORTYPE_MEDIUM] = 26588,
		};
		itemLink = itemLink:gsub("370:50:0:0:0", string.format("370:50:%d:370:50", enchantments[GetItemLinkArmorType(itemLink)]));
	end

	return(itemLink);
end
function GetColorForAlliance(alliance)
	if alliance == ALLIANCE_EBONHEART_PACT then
		return ZO_ColorDef:New("a4231a")
	elseif alliance == ALLIANCE_ALDMERI_DOMINION then
		return ZO_ColorDef:New("af9839")
	elseif alliance == ALLIANCE_DAGGERFALL_COVENANT then
		return ZO_ColorDef:New("285aa1")
	end
	return ZO_ColorDef:New("ffffff")
end
function GetColorForLevel(level)
	local colorPG = ZO_ColorDef:New("999999") --gray (default)
	if level >= 50 then
		--colorPG = ZO_ColorDef:New("EECA2A") --gold
		colorPG = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, ITEM_QUALITY_ARTIFACT))
	elseif level >= 40 then
		colorPG = ZO_ColorDef:New("3a92ff") --blue
	elseif level >= 20 then
		colorPG = ZO_ColorDef:New("39E600") --green
	end
	return colorPG
end
function GetColorForSex(sex)
	if sex == nil or sex < 1 then
		-- N.D.
		return ZO_ColorDef:New("999999")
	end
	if sex == 1 then
		-- Female
		return ZO_ColorDef:New("FB8CFF")
	end
	-- Male
	return ZO_ColorDef:New("8CCAFF")
end

-- SORT

function quicksort(t, FuncCheck, start, endi)
  start, endi = start or 1, endi or #t
  if(endi - start < 1) then return t end
  local pivot = start
  for i = start + 1, endi do
	--if t[i] <= t[pivot] then

	if FuncCheck(t[i],t[pivot]) then
	  local temp = t[pivot + 1]
	  t[pivot + 1] = t[pivot]
	  if(i == pivot + 1) then
		t[pivot] = temp
	  else
		t[pivot] = t[i]
		t[i] = temp
	  end
	  pivot = pivot + 1
	end
  end
  t = quicksort(t,FuncCheck, start, pivot - 1)
  return quicksort(t,FuncCheck, pivot + 1, endi)
end


-- PLAYER ARRAY
function CreatePlayerArray(arr)
	local copy = {}
	local c=1
	for key, value in pairs(arr) do
		for key1, value1 in pairs(value) do
			--if(key1~="Guilds" and key1~="CP") then
			if (key1 == "PG") then
				for key2, value2 in pairs(value1) do
					copy[c]={}
					copy[c].lev=value2.lev
					copy[c].CP=value.CP
					copy[c].real_sex=value.Sex
					copy[c].sex=value2.sex
					copy[c].pg_name=key2
					copy[c].race=value2.race
					copy[c].class=value2.class
					copy[c].alli=value2.alli
					copy[c].userid=key
					c=c+1
				end
			end
		end
    end
	return copy
end

-- GILDE ARRAY
function CreateGuildArray(arr)
	local copy = {}
	local c=1
	for key, value in pairs(arr) do
		copy[c]={}
		copy[c].guild_name=key
		copy[c].description=value.description
		copy[c].image=value.image
		copy[c].guild_master=value.guild_master
		c=c+1
    end
	return copy
end
