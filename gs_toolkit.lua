
--   █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ █ ▀▀▀▀▀▀▀▀▀
--   █ ▀▀█ █▀▀▀█ █▀▀▀█ █▀▀▀▀ █   █ █▀▀▀█ █▀▀▀▀ 
--   █   █ █ ▄▀  █   █ ▀▀▀▀█ █   █ █   █ ▀▀▀▀█
--   ▀▀▀▀▀ ▀▀▀▀▀ ▀   ▀ ▀▀▀▀▀ ▀▀▀▀▀ ▀▀▀▀▀ ▀▀▀▀▀   				       

script_name = "GS Toolkit"
script_description = "Užitečná sada nástrojů pro líné překladatele a korektory ^_^"
script_author = "KDan"
script_version = "1.0"

include("karaskel.lua")

gs_folder_path = os.getenv("userprofile").."\\Documents\\GS Toolkit"
mkvtoolnix_path = "C:\\Program Files\\MKVToolNix"

os.execute('icacls '.. os.getenv("userprofile") .. "\\Documents") --získání práv k zápisu do složky pro gay operační systémy, háže chybu, ale funguje, takže w/e

function smazatConfig()
	os.remove(gs_folder_path .. "\\GS_Toolkit.cfg")
end

function smazatKor()
	local datum = os.date("*t")
	local log_path = gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".txt"
	local soubor = io.open(log_path)
	if soubor == nil then
		aegisub.debug.out("Jo, to by ale ještě musel existovat...")
	else
		local dialog=
		{
			{
				class="label",
				x=0,y=0,width=2,height=2,
				label='Fakt, jo?'
			}
		}
		local buttons={"Jo, neotravuj", "Nakonec ne"}
		local tlacitko, results = aegisub.dialog.display(dialog,buttons)
		if tlacitko == "Jo, neotravuj" then
			io.close(soubor)
			os.remove(log_path)
		end
	end
end

function zapsatConfig() 
	config_soubor = io.open(gs_folder_path .. "\\GS_Toolkit.cfg", "w")
	io.output(config_soubor)
	io.write("--Konfigurační soubor GS toolkitu--", "\n")
	io.write("[mkvtoolnix]", "\n")
	io.write("path=" .. tostring(mkvtoolnix_path), "\n")
	io.write("[podpisy]", "\n")
	io.write("nazev=" .. nazevValue:gsub("\n", " "), "\n")
	io.write("prekladatel=" .. prekladatelValue:gsub("\n", " "), "\n")
	io.write("korektor=" .. korektorValue:gsub("\n", " "), "\n")
	io.write("casovac=" .. casovacValue:gsub("\n", " "), "\n")
	io.write("release=" .. releaseValue:gsub("\n", " "))
	io.close(config_soubor)
end

--definice tlačítek dialogů
dialogVlozeni_buttons={"Nastaveni delky", "Pleskni to tam"}
dialogCasovani_buttons={"Oki", "Vychozi"}
dialogStyly_buttons={"Pleskni to tam"}
--dialogPodpis_buttons={"Podepsat", "Ulozit", "Nacist"}
dialogPodpis_buttons={"Podepsat"}
dialogKorektura_buttons={"Okorektit", "Pouze okomentovat", "Smazat posledni radek"}
dialogNastaveni_buttons={"Ulozit"}
dialogPorovnani_buttons={"Predchozi", "Dalsi", "Posun-", "Posun+", "Vychozi"}

function cistConfig()
	config_soubor = io.open(gs_folder_path .. "\\GS_Toolkit.cfg", "r")
	if config_soubor == nil then --vytvoří novej config soubor, pokud neexistuje
		os.execute('md "' .. gs_folder_path .. '"')
		config_soubor = io.open(gs_folder_path .. "\\GS_Toolkit.cfg", "w")
		io.output(config_soubor)
		io.write("--Konfigurační soubor GS toolkitu--", "\n")
		io.write("[mkvtoolnix]", "\n")
		io.write("path=" .. tostring(mkvtoolnix_path), "\n")
		io.write("[podpisy]", "\n")
		io.write("nazev=", "\n")
		io.write("prekladatel=", "\n")
		io.write("korektor=", "\n")
		io.write("casovac=", "\n")
		io.write("release=")
		io.close(config_soubor)
		config_soubor = io.open(gs_folder_path .. "\\GS_Toolkit.cfg", "r")
	end
	io.input(config_soubor) --přečte hodnoty z configu 
	configInfo=io.read("*line")
	configIndex=io.read("*line")
	configMKVpath=io.read("*line")
	configIndex=io.read("*line")
	configPodpisNazev=io.read("*line")
	configPodpisPrekladatel=io.read("*line")
	configPodpisKorektor=io.read("*line")
	configPodpisCasovac=io.read("*line")
	configPodpisRelease=io.read("*line")
	io.close(config_soubor)
	
	--zápis přečtených hodnot pro proměnných dialogových oken
	mkvtoolnix_path = configMKVpath:gsub("path=", "")
	nazevValue = configPodpisNazev:gsub("nazev=", "")
	prekladatelValue = configPodpisPrekladatel:gsub("prekladatel=", "")
	korektorValue = configPodpisKorektor:gsub("korektor=", "")
	casovacValue = configPodpisCasovac:gsub("casovac=", "")
	releaseValue = configPodpisRelease:gsub("release=", "")
	
	--definice dialogových oken


	dialogNastaveni_config=
	{
		{
			class="label",
			x=0,y=0,width=1,height=1,
			label="Pracovní složka:"
		},
		{
			class="label",
			x=0,y=1,width=15,height=1,
			label=gs_folder_path
		},
		{
			class="label",
			x=0,y=2,width=1,height=1,
			label="(z technických důvodů lze změnit pouze v souboru skriptu)"
		},
		{
			class="label",
			x=0,y=4,width=1,height=1,
			label="MKVToolNix složka:"
		},
		{
			class="textbox",name="path_mkv",
			x=0,y=5,width=15,height=1,
			value=mkvtoolnix_path
		}
	}
	

	dialogPodpis_config=
	{
		{
			class="label",
			x=0,y=0,width=1,height=1,
			label='Název: '
		},
		{
			class="textbox",name="nazev",
			x=1,y=0,width=15,height=1,
			value=nazevValue
		},
		{
			class="label",
			x=0,y=1,width=1,height=1,
			label='Překladatel: '
		},
		{
			class="textbox",name="prekladatel",
			x=1,y=1,width=15,height=1,
			value=prekladatelValue
		},
		{
			class="label",
			x=0,y=2,width=1,height=1,
			label='Korektor: '
		},
		{
			class="textbox",name="korektor",
			x=1,y=2,width=15,height=1,
			value=korektorValue
		},
		{
			class="label",
			x=0,y=3,width=1,height=1,
			label='Časovač: '
		},
		{
			class="textbox",name="casovac",
			x=1,y=3,width=15,height=1,
			value=casovacValue
		},
		{
			class="label",
			x=0,y=4,width=1,height=1,
			label='Release: '
		},
		{
			class="textbox",name="release",
			x=1,y=4,width=15,height=1,
			value=releaseValue
		}
	}
	dialogPodpisUlozeni_config=
	{
		{
			class="label",
			x=0,y=0,width=1,height=1,
			label='Název předvolby: '
		},
		{
			class="textbox",name="preset",
			x=0,y=1,width=15,height=1,
			value=""
		}
	}
end

--zápis výstupních hodnot z dialogových oken do globálních proměnných
function zapsatDialog(typOkna)
	if typOkna == 5 then --okno podpisu titulků	
		nazevValue = results4["nazev"]	
		prekladatelValue = results4["prekladatel"]
		korektorValue = results4["korektor"]
		casovacValue = results4["casovac"]
		releaseValue = results4["release"]
	elseif typOkna == 6 then --okno podpisu titulků(uložení presetu)
		local cudl, vyst = aegisub.dialog.display(dialogPodpisUlozeni_config,dialogStyly_buttons)
		if cudl == "Pleskni to tam" then
			nazevPresetuValue = vyst["preset"]:gsub("\n", " ")
			nazevValue = results4["nazev"]
			prekladatelValue = results4["prekladatel"]
			korektorValue = results4["korektor"]
			casovacValue = results4["casovac"]
			releaseValue = results4["release"]
			for i=1, #podpisPresety do
				tempPreset = podpisPresety[i]
				if tempPreset["presetName"] == results4["preset"] then
					poslPresetValue = i
				end
			end
		end
		vlozitInfo()
	end
end

function vlozitInfo(subs)
	cistConfig()
	tlacitko4, results4 = aegisub.dialog.display(dialogPodpis_config,dialogPodpis_buttons)
	if tlacitko4=="Podepsat" then
		zapsatDialog(5)
		zapsatConfig()
		cistConfig()
		local titleExistuje = false
		local releaseExistuje = false
		local preklExistuje = false
		local korExistuje = false
		local casExistuje = false
		
		local rozsah = 30
		if subs.n < 30 then rozsah = subs.n end
		for i=1, rozsah do
			if subs[i].key == "Title" then
				tempLine = subs[i]		
				tempLine.value = nazevValue
				subs[i] = tempLine
				titleExistuje = true
			end
			if subs[i].key == "Original Script" then
				tempLine = subs[i]	
				if releaseValue ~= nil then
					tempLine.value = releaseValue
				end
				subs[i] = tempLine
				releaseExistuje = true
			end
			if subs[i].key == "Original Translation" then
				tempLine = subs[i]		
				tempLine.value = prekladatelValue
				subs[i] = tempLine
				preklExistuje = true
			end
			if subs[i].key == "Original Editing" then
				tempLine = subs[i]		
				tempLine.value = korektorValue
				subs[i] = tempLine
				korExistuje = true
			end
			if subs[i].key == "Original Timing" then
				tempLine = subs[i]		
				tempLine.value = casovacValue
				subs[i] = tempLine
				casExistuje = true
			end
		end
		
		if titleExistuje == false then
			tempLine = subs[1]
			tempLine.key = "Title"
			tempLine.value = nazevValue
			subs[0] = tempLine
		end
		if releaseExistuje == false then
			tempLine = subs[1]
			tempLine.key = "Original Script"
			tempLine.value = releaseValue
			subs[0] = tempLine
		end
		if preklExistuje == false then
			tempLine = subs[1]
			tempLine.key = "Original Translation"
			tempLine.value = prekladatelValue
			subs[0] = tempLine
		end
		if korExistuje == false then
			tempLine = subs[1]
			tempLine.key = "Original Editing"
			tempLine.value = korektorValue
			subs[0] = tempLine
		end
		if casExistuje == false then
			tempLine = subs[1]
			tempLine.key = "Original Timing"
			tempLine.value = casovacValue
			subs[0] = tempLine
		end
	end
	if tlacitko4 == "Ulozit" then
		zapsatConfig()
		zapsatDialog(6)
	end
	if tlacitko4 == "Nacist" then
		zapsatConfig()
		zapsatDialog(5)
		vlozitInfo()
	end
	aegisub.set_undo_point("Podepsat titulky")
end

function korektorLog(subs, sel, act)
	cistConfig()
	local radekKor = subs[act]
	local pocetRadku = 0
		for i=1, subs.n do
			if subs[i].class == "dialogue" then 
				pocetRadku = pocetRadku + 1
			end
		end
	local radekAct = act - (subs.n - pocetRadku)
	local datum = os.date("*t")
	dialogKorektorLog_config=
	{
		{
			class="label",
			x=0,y=0,width=10,height=1,
			label='Původní řádek: '
		},
		{
			class="textbox",name="puvodni",
			x=0,y=1,width=30,height=4,
			value=radekKor.text
		},
		{
			class="label",
			x=0,y=5,width=1,height=1,
			label='Upravený řádek: '
		},
		{
			class="textbox",name="upraveny",
			x=0,y=6,width=30,height=4,
			value=radekKor.text
		},
		{
			class="label",
			x=0,y=11,width=1,height=1,
			label='Komentář k úpravě: '
		},
		{
			class="textbox",name="komentar",
			x=0,y=12,width=30,height=4,
			value=""
		},
		{
			class="checkbox",name="zvyraznit",
			x=0,y=16,width=1,height=1,
			label="Zvýraznit ve výpisu",
			value=false
		}
	}
	but_korektor, res_korektor = aegisub.dialog.display(dialogKorektorLog_config, dialogKorektura_buttons)
	local radekKom = ""
	local radekInfo = tostring(radekAct)
	if res_korektor["zvyraznit"] then
		radekInfo = "**"..tostring(radekAct)
	end
	if but_korektor == "Okorektit" then
		if res_korektor["komentar"] ~= "" then
			radekKom = "\n    (" .. res_korektor["komentar"] .. ")" 
		end
		log_soubor = io.open(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log", "a+")
		io.output(log_soubor)
		io.write(radekInfo..") "..res_korektor["puvodni"].. " -> "..res_korektor["upraveny"]..radekKom.."\n")
		io.close(log_soubor)
		radekKor.text = tostring(res_korektor["upraveny"])
		subs[act] = radekKor
	elseif but_korektor == "Pouze okomentovat" then
		if res_korektor["komentar"] == "" then
			aegisub.debug.out("Já to za tebe komentovat nebudu.\nZkus to znovu...\n")
		else
			radekKom = "\n    (" .. res_korektor["komentar"] .. ")" 
			log_soubor = io.open(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log", "a+")
			io.output(log_soubor)
			io.write(radekInfo..") "..res_korektor["puvodni"]..radekKom.."\n")
			io.close(log_soubor)
		end
	elseif but_korektor == "Smazat posledni radek" then
		log_soubor = io.open(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log", "r")
		io.input(log_soubor)
		local radekCount = 0
		logTemp={}
		for line in log_soubor:lines() do
			table.insert(logTemp, line)
			radekCount = radekCount + 1
		end
		io.close(log_soubor)
		log_soubor = io.open(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log", "w")
		--for index, hod in ipairs(logTemp) do
		--	log_soubor:write(hod..'\n')
		--end
		for i=1, radekCount-1 do
			log_soubor:write(logTemp[i]..'\n')
		end
		io.close(log_soubor)
		if logTemp[radekCount] == nil then
			aegisub.debug.out("Nebylo co mazat, výpis je prázdnej... \n\n(jako ty ^_^)")
		else
			aegisub.debug.out("Smazaný řádek: \n" .. logTemp[radekCount])
		end
	end
	aegisub.set_undo_point("Korektura")
end

function korektorLogOpen()
	local datum = os.date("*t")
	os.execute(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log")
end

function mkvextract()	
	local video = aegisub.project_properties().video_file
	local command = tostring('"' .. mkvtoolnix_path .. '\\mkvextract.exe" "' .. video .. '" tracks 2:' .. gs_folder_path .. '\\eng_subs.ass')
	engsubs_pole = {}
	os.remove(gs_folder_path .. "\\extract.bat")
	local toolnix = io.open(mkvtoolnix_path .. "\\mkvextract.exe")
	if toolnix == nil then
		aegisub.debug.out("Nebyl nalezen nástroj mkvextract. \nNainstaluj MKVToolNix, nebo změň složku v nastavení.\nOdkaz na stažení:\nhttps://www.fosshub.com/MKVToolNix.html")
	else
		io.close(toolnix)
		if video == "" then
			aegisub.debug.out("Nejdřív načti video.")
		else
			local bat = io.open(gs_folder_path .. "\\extract.bat", "a+")
			io.output(bat)
			io.write("echo off\n")
			io.write("cls\n")
			io.write(command)
			io.close(bat)
			aegisub.debug.out("Spouštím mkvextract...\n")
			aegisub.progress.title("Extrahování titulků...")
			os.execute(gs_folder_path .. "\\extract.bat")
			aegisub.debug.out("Dokončeno... Možná i úspěšně...")
			local engsubs_ass = io.open(gs_folder_path .. "\\eng_subs.ass", "r")
			aegisub.progress.title("Otevírám titulky...")

			
			aegisub.debug.out("\n")

			for radek in engsubs_ass:lines() do
				if radek.find (radek, "Dialogue: ") ~= nil then
					table.insert(engsubs_pole, radek)
				end
			end
			
			--for i, l in ipairs(engsubs_pole) do aegisub.debug.out(i .. ": " .. l .. "\n") end
			aegisub.progress.title("Hotovo")
		end
	end
end

function subsLoad()
	local dialog = aegisub.dialog.open("Otevřít titulky...", "", "", "Titulky ASS (*.ass)|*.ass", false, true)
	if dialog ~= nil then
		local engsubs_ass = io.open(dialog, "r")
		engsubs_pole = {}
		aegisub.progress.title("Otevírám titulky...")
		for radek in engsubs_ass:lines() do
			if radek.find (radek, "Dialogue: ") ~= nil then
				table.insert(engsubs_pole, radek)
			end
		end
		
		--for i, l in ipairs(engsubs_pole) do aegisub.debug.out(i .. ": " .. l .. "\n") end
		aegisub.progress.title("Hotovo")
	end
end

function toolkitSetup()
	cistConfig()
	setButtons, setResults = aegisub.dialog.display(dialogNastaveni_config, dialogNastaveni_buttons)
	if setButtons=="Ulozit" then
		mkvtoolnix_path = setResults["path_mkv"]
		zapsatConfig()
	end
end

porovnani_offset = 0
porovnani_posun = 0

function porovnani(subs, sel, act)

	if engsubs_pole == nil then
		aegisub.debug.out("Nejsou načteny titulky k porovnání...")
	else
		local pocetRadku = 0
			for i=1, subs.n do
				if subs[i].class == "dialogue" then 
					pocetRadku = pocetRadku + 1
				end
			end
		local radekAct = act - (subs.n - pocetRadku) + porovnani_offset + porovnani_posun
		local puvRadek = engsubs_pole[radekAct]
		local spl = puvRadek
		local carkaCount = 0
		if spl==nil then spl = "[Řádek neexistuje]" end
		for i in string.gmatch(spl, "([^,]+)") do
			if carkaCount ~= 9 then
				puvRadek = i
				carkaCount = carkaCount + 1
			else
				puvRadek = puvRadek .. "," .. i
			end
		end
	
		dialogPorovnani_config=
		{
			{
				class="label",
				x=0,y=0,width=1,height=1,
				label="Původní:"
			},
			{
				class="textbox",name="puv",
				x=0,y=1,width=50,height=4,
				value=puvRadek
			},
			{
				class="label",
				x=0,y=5,width=1,height=1,
				label="Současný:"
			},
			{
				class="textbox",name="sou",
				x=0,y=6,width=50,height=4,
				value=subs[act+porovnani_offset].text
			},
			{
				class="label",
				x=0,y=7,width=1,height=1,
				label="Řádek: " .. radekAct .. " | Posun řádků: " .. porovnani_posun
			}
		}
		
		porButtons, porResults = aegisub.dialog.display(dialogPorovnani_config, dialogPorovnani_buttons)
		if porButtons=="Predchozi" then
			porovnani_offset = porovnani_offset - 1
			porovnani(subs, sel, act)
		elseif porButtons=="Dalsi" then
			porovnani_offset = porovnani_offset + 1
			porovnani(subs, sel, act)
		elseif porButtons=="Posun-" then
			porovnani_posun = porovnani_posun - 1
			porovnani(subs, sel, act)
		elseif porButtons=="Posun+" then
			porovnani_posun = porovnani_posun + 1
			porovnani(subs, sel, act)
		elseif porButtons=="Vychozi" then
			porovnani_offset = 0
			porovnani_posun = 0
			porovnani(subs, sel, act)
		end
	end
end

function selfTest()
	local pracSlozka = ""
	local conf = ""
	local kor = ""
	local datum = os.date("*t")
	local file,err = io.open(gs_folder_path .. "\\test.hmm",'w')
    local file2,err2 = io.open(gs_folder_path .. "\\GS_Toolkit.cfg",'r') 
    local file3,err3 = io.open(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log",'r')
    
	if file then
        io.output(file)
		io.write("Test")
		io.close(file)
		local temp = io.open(gs_folder_path .. "\\test.hmm",'r')
		io.input(temp)
		local rdTest = io.read("*line")
		if rdTest == "Test" then
			pracSlozka = "Úspěšný"
		else
			pracSlozka = "Chyba"
		end
        io.close(temp)
    else
        pracSlozka = "Chyba (" .. err .. ")"
    end
	
	if file2 then
		conf = "Existuje"
	else
		conf = "Něco je blbě (" .. err2 .. ")"
	end
	
	if file3 then
		kor = "Existuje"
	else
		kor = "Jejda (" .. err3 .. ")"
	end
	
	dialogSelfTest_config=
	{
		{
			class="label",
			x=0,y=0,width=1,height=1,
			label="Pokus o zápis do pracovní složky: " .. pracSlozka
		},
		{
			class="label",
			x=0,y=1,width=15,height=1,
			label="Konfigurační soubor: " .. conf
		},
		{
			class="label",
			x=0,y=2,width=1,height=1,
			label="Korektura - dnešní výpis: " .. kor
		}
	}
	local testButtons, testResults = aegisub.dialog.display(dialogSelfTest_config, {"OK", "Otevrit vypis zmen", "Otevrit konfiguracni soubor", "Otevrit pracovni slozku"})
	if testButtons == "Otevrit konfiguracni soubor" then
		os.execute(gs_folder_path .. "\\GS_Toolkit.cfg")
		selfTest()
	elseif testButtons == "Otevrit vypis Korektura" then
		os.execute(gs_folder_path .. "\\Korektura_" .. datum["day"] .. "." .. datum["month"] .. "." .. datum["year"] .. ".log")
		selfTest()
	elseif testButtons == "Otevrit pracovni slozku" then
		os.execute('explorer "' .. gs_folder_path .. '"')
		selfTest()
	end
end

function gsfolderOpen()
	os.execute('explorer "' .. gs_folder_path .. '"')
end

aegisub.register_macro("GS Toolkit/Korektura/Zápis změny", "Zapíše úpravu řádku do výpisu", korektorLog)
aegisub.register_macro("GS Toolkit/Korektura/Otevřít výpis změn", "Otevře výpis změn", korektorLogOpen)
aegisub.register_macro("GS Toolkit/Korektura/Smazat dnešní výpis změn", "Odstraní dnešní výpis změn", smazatKor)
aegisub.register_macro("GS Toolkit/Korektura/Načíst titulky z videa", "Extrahuje titulky z videa a načte je do porovnávače", mkvextract)
aegisub.register_macro("GS Toolkit/Korektura/Načíst vlastní titulky", "Načte titulky do porovnávače", subsLoad)
aegisub.register_macro("GS Toolkit/Korektura/Porovnávač titulků", "Otevře porovnávač titulků", porovnani)
aegisub.register_macro("GS Toolkit/Podepsat titulky", "Otevře okno podpisu titulků", vlozitInfo)
aegisub.register_macro("GS Toolkit/Nastavení", "Otevře okno nastavení", toolkitSetup)
aegisub.register_macro("GS Toolkit/Otevřít pracovní složku", "Otevře pracovní složku", gsfolderOpen)
aegisub.register_macro("GS Toolkit/Je všechno OK?", "Zkontroluje přítomnost souborů", selfTest)
aegisub.register_macro("GS Toolkit/Smazat konfigurační soubor", "Odstraní konfigurační soubor", smazatConfig)