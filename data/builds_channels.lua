TUitBuildsChannels =
{
	["owner"] =	-- canali creati dall'utente corrente "@gabry90"
	{
		[1] =
		{
			["name"] = "mio canale",
			["description"] = "descrizione mio canale bla bla bla",
			["members"] =
			{
				[1] = "@paperino",
				[2] = "@pluto",
			},
		},
	},
	["others"] = -- canali creati da altri utenti a cui si ha avuto accesso via invito
	{
		[1] =	-- "@gabry90" si trova nei members di questo canale
		{
			["name"] = "canale di pippo",
			["description"] = "descrizione canale di pippo bla bla bla buuurp",
			["owner"] = "@pippo",
			["members"] =
			{
				[1] = "@topolino",
				[2] = "@gabry90"
				[3] = "@qui",
				[4] = "@quo",
				[5] = "@qua",
			},
		},
	},
}