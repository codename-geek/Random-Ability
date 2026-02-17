function _OnInit()
GameVersion = 0
end

function GetVersion() --Define anchor addresses
if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
	GameVersion = -1
	print("Emulator version not supported, please delete this mod.")
elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
	OnPC = true
	if ReadString(0x9A9330,4) == 'KH2J' then --EGS
		GameVersion = 2
		print('GoA Epic Version - Random Ability Lua')
		continue = 0x29FB500
		Now = 0x0716DF8
		Save = 0x09A9330
		IsLoaded = 0x09BA310
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam Global
		GameVersion = 3
		print('GoA Steam Global Version - Random Ability Lua')
		continue = 0x29FB580
		Now = 0x0717008
		Save = 0x09A98B0
		IsLoaded = 0x7134A0
	elseif ReadString(0x9A98B0,4) == 'KH2J' then --Steam JP (same as Global for now)
		GameVersion = 4
		print('GoA Steam JP Version - Random Ability Lua')
		continue = 0x29FA500
		Now = 0x0717008
		Save = 0x09A98B0
		IsLoaded = 0x09B9850
	elseif ReadString(0x9A7070,4) == "KH2J" or ReadString(0x9A70B0,4) == "KH2J" or ReadString(0x9A92F0,4) == "KH2J" then
		GameVersion = -1
		print("Epic Version is outdated. Please update the game.")
	elseif ReadString(0x9A9830,4) == "KH2J" then
		GameVersion = -1
		print("Steam Global Version is outdated. Please update the game.")
	elseif ReadString(0x9A8830,4) == "KH2J" then
		GameVersion = -1
		print("Steam JP Version is outdated. Please update the game.")
	end
end
end

function BitOr(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
function BitNot(Address,Bit,Abs)
	WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

function keepAbilities()
	local isLoaded = ReadByte(IsLoaded)
	local doubleNegCount = 0
    if ReadInt(continue+0xC) ~= prevContinue and isLoaded == 0 then
		for Slot = 0,68 do
			local Current = Save + 0x2544 + 2*Slot
			local Ability = ReadShort(Current) & 0x0FFF
			local Initial = ReadShort(Current) & 0xF000

			--these abilities have adjusted odds during superbosses
			if Ability == 0x0052		--Guard
				or Ability == 0x010F	--Hori
				or Ability == 0x010B	--Finishing Leap
				or Ability == 0x0111	--Retaliating Slash
				or Ability == 0x022F	--Flash Step
				or Ability == 0x0108	--Slide Dash
				or Ability == 0x0109	--Guard Break
				or Ability == 0x010A	--Explosion
				or Ability == 0x0230	--Aerial Dive
				or Ability == 0x010E	--Aerial Spiral
				or Ability == 0x0231	--Magnet Burst
				or Ability == 0x010C	--Counterguard
				or Ability == 0x009E	--Aerial Recovery
				or Ability == 0x0186	--Combo Boost
				or Ability == 0x0187	--Air Combo Boost
				or Ability == 0x0188	--Reaction Boost
				or Ability == 0x0189	--Finishing Plus
				or Ability == 0x0192	--Leaf Bracer
				or Ability == 0x019F	--Second Chance
				or Ability == 0x01A0	--Once More
			   then

				if temp > 33 then
					WriteShort(Current,Ability+0x8000)
				else
					WriteShort(Current,Ability)
				end
			end

			--these abilities are always 50/50
			if Ability == 0x0089		--Upper Slash
				or Ability == 0x0106	--Slapshot
				or Ability == 0x0107	--Dodge Slash
				or Ability == 0x0232	--Vicinity Break
				or Ability == 0x010D	--Aerial Sweep
				or Ability == 0x0110	--Aerial Finish
				or Ability == 0x0181	--Auto Valor
				or Ability == 0x0182	--Auto Wisdom
				or Ability == 0x0238	--Auto Limit
				or Ability == 0x0183	--Auto Master
				or Ability == 0x0184	--Auto Final
				or Ability == 0x0185	--Auto Summon
				or Ability == 0x00C6	--Trinity
				or Ability == 0x008A	--Scan
				or Ability == 0x021B	--Combo Master
				or Ability == 0x00A2	--Combo Plus
				or Ability == 0x00A3	--Air Combo Plus
				or Ability == 0x018A	--Negative Combo
				or Ability == 0x018B	--Berserk Charge
				or Ability == 0x018C	--Damage Drive
				or Ability == 0x018D	--Drive Boost
				or Ability == 0x018E	--Form Boost
				or Ability == 0x018F	--Summon Boost
				or Ability == 0x0190	--Combination Boost
				or Ability == 0x0191	--Experience Boost
				or Ability == 0x0193	--Magic Lock-On
				or Ability == 0x021D	--Light & Darkness
				or Ability == 0x0195	--Draw
				or Ability == 0x0196	--Jackpot
				or Ability == 0x0197	--Lucky Lucky
				or Ability == 0x021C	--Drive Converter
				or Ability == 0x0198	--Fire Boost
				or Ability == 0x0199	--Blizzard Boost
				or Ability == 0x019A	--Thunder Boost
				or Ability == 0x019B	--Item Boost
				or Ability == 0x019C	--MP Rage
				or Ability == 0x019D	--MP Haste
				or Ability == 0x01A5	--MP Hastera
				or Ability == 0x01A6	--MP Hastega
				or Ability == 0x019E	--Defender
				or Ability == 0x021E	--Damage Control
			   then

				temp = math.random(1, 100)

				if temp > 50 then
					if Ability == 0x018A and doubleNegCount < 2 then
						WriteShort(Current,Ability+0x8000)
					elseif Ability ~= 0x018A then
						WriteShort(Current,Ability+0x8000)
					end
				else
					WriteShort(Current,Ability)
				end

				if Ability == 0x018A then
					doubleNegCount = doubleNegCount + 1
				end
			end

			-- Adjust odds of No Exp being randomly equipped to 1 in 10
			if Ability == 0x0194 then --No Experience
				temp = math.random(1, 100)
	
				if temp > 95 then
					WriteShort(Current,Ability+0x8000)
				else
					WriteShort(Current,Ability)
				end
			end
		end

		--Individually roll odds for each growth
		if ReadShort(Save+0x25CE) ~= 0 then --High Jump
			temp = math.random(1, 100)
	
			if temp > 50 or keepGrowth then
				BitOr(Save+0x25CF,0x80)
			else
				BitNot(Save+0x25CF,0x80)
			end
		end
		if ReadShort(Save+0x25D0) ~= 0 then --Quick Run
			temp = math.random(1, 100)
	
			if temp > 50 or keepGrowth then
				BitOr(Save+0x25D1,0x80)
			else
				BitNot(Save+0x25D1,0x80)
			end
		end
		if ReadShort(Save+0x25D2) ~= 0 then --Dodge Roll
			temp = math.random(1, 100)
	
			if temp > 50 or keepGrowth then
				BitOr(Save+0x25D3,0x80)
			else
				BitNot(Save+0x25D3,0x80)
			end
		end
		if ReadShort(Save+0x25D4) ~= 0 then --Aerial Dodge
			temp = math.random(1, 100)
	
			if temp > 50 or keepGrowth then
				BitOr(Save+0x25D5,0x80)
			else
				BitNot(Save+0x25D5,0x80)
			end
		end
		if ReadShort(Save+0x25D6) ~= 0 then --Glide
			temp = math.random(1, 100)
	
			if temp > 50 or keepGrowth then
				BitOr(Save+0x25D7,0x80)
			else
				BitNot(Save+0x25D7,0x80)
			end
		end
    end

	prevContinue = ReadInt(continue+0xC)
end

function KeepGrowth()
	-- Set GoA to always have growth equipped
	if World == 4 and Room == 26 then --GoA
		keepGrowth = true
	--STT/TT
	elseif World == 2 and Room == 2 then --Usual Spot
		keepGrowth = true
	elseif World == 2 and Room == 9 then --Central Station
		keepGrowth = true
	elseif World == 2 and Room == 11 then --Sunset Station
		keepGrowth = true
	elseif World == 2 and Room == 18 then --Namine's Room
		keepGrowth = true
	elseif World == 2 and Room == 21 then --Computer Room
		keepGrowth = true
	elseif World == 2 and Room == 26 then --Tower Entryway
		keepGrowth = true
	elseif World == 2 and Room == 27 then --Sorcerer's Loft
		keepGrowth = true
	elseif World == 2 and Room == 28 then --Wardrobe Room
		keepGrowth = true
	elseif World == 2 and Room == 32 then --Station of Serenity
		keepGrowth = true
	elseif World == 2 and Room == 33 then --Station of Calling
		keepGrowth = true
	--HB
	elseif World == 4 and Room == 3 then --Crystal Fissure
		keepGrowth = true
	elseif World == 4 and Room == 5 then --Ansem's Study
		keepGrowth = true
	elseif World == 4 and Room == 6 then --Postern
		keepGrowth = true
	elseif World == 4 and Room == 13 then --Merlin's House
		keepGrowth = true
	--BC
	elseif World == 5 and Room == 1 then --Parlor
		keepGrowth = true
	elseif World == 5 and Room == 2 then --Belle's Room
		keepGrowth = true
	elseif World == 5 and Room == 3 then --Beast's Room
		keepGrowth = true
	elseif World == 5 and Room == 10 then --Dungeon
		keepGrowth = true
	--OC
	elseif World == 6 and Room == 4 then --Coliseum Foyer
		keepGrowth = true
	elseif World == 6 and Room == 12 then --The Lock
		keepGrowth = true
	elseif World == 6 and Room == 10 then --Inner Chamber
		keepGrowth = true
	--AG
	elseif World == 7 and Room == 2 then --Peddler's Shop Old
		keepGrowth = true
	elseif World == 7 and Room == 6 then --Palace Walls
		keepGrowth = true
	elseif World == 7 and Room == 11 then --Ruined Chamber
		keepGrowth = true
	elseif World == 7 and Room == 15 then --Peddler's Shop New
		keepGrowth = true
	--LoD
	elseif World == 8 and Room == 0 then --Bamboo Grove
		keepGrowth = true
	elseif World == 8 and Room == 4 then --Village Intact
		keepGrowth = true
	elseif World == 8 and Room == 11 then --Throne Room
		keepGrowth = true
	elseif World == 8 and Room == 12 then --Village Destroyed
		keepGrowth = true
	--100AW
	elseif World == 9 and Room == 0 then --Book Overworld
		keepGrowth = true
	--DC
	elseif World == 12 and Room == 1 then --Library
		keepGrowth = true
	elseif World == 12 and Room == 4 then --Hall of the Cornerstone (Dark)
		keepGrowth = true
	elseif World == 12 and Room == 5 then --Hall of the Cornerstone (Light)
		keepGrowth = true
	elseif World == 12 and Room == 6 then --Gummi Hangar
		keepGrowth = true
	--TR
	elseif World == 13 and Room == 0 then --Cornerstone Hill
		keepGrowth = true
	--HT
	elseif World == 14 and Room == 1 then --Finkelstein's Lab
		keepGrowth = true
	elseif World == 14 and Room == 5 then --Yuletide Hill
		keepGrowth = true
	elseif World == 14 and Room == 8 then --Santa's House
		keepGrowth = true
	--PR
	elseif World == 16 and Room == 0 then --Rampart
		keepGrowth = true
	elseif World == 16 and Room == 4 then --Interceptor: Ship's Hold
		keepGrowth = true
	elseif World == 16 and Room == 6 then --Black Pearl: Captain's Stateroom
		keepGrowth = true
	elseif World == 16 and Room == 8 then --Isla de Muerta: Rock Face 1st Visit
		keepGrowth = true
	elseif World == 16 and Room == 11 then --Ship Graveyard: Interceptor's Hold
		keepGrowth = true
	elseif World == 16 and Room == 16 then --Isla de Muerta: Rock Face 2nd Visit
		keepGrowth = true
	--SP
	elseif World == 17 and Room == 0 then --Pit Cell
		keepGrowth = true
	elseif World == 17 and Room == 5 then --Communications Room
		keepGrowth = true
	elseif World == 17 and Room == 8 then --Central Computer Core
		keepGrowth = true
	--TWTNW
	elseif World == 18 and Room == 1 then --Alley to Between
		keepGrowth = true
	elseif World == 18 and Room == 4 then --Brink of Despair
		keepGrowth = true
	elseif World == 18 and Room == 9 then --Twilight's View
		keepGrowth = true
	elseif World == 18 and Room == 13 then --Proof of Existence
		keepGrowth = true
	elseif World == 18 and Room == 18 then --Altar of Naught
		keepGrowth = true
	else
		keepGrowth = false
	end
end

function _OnFrame()
if GameVersion == 0 then --Get anchor addresses
	GetVersion()
	return
elseif GameVersion < 0 then --Incompatible version
	return
end
if true then --Define current values for common addresses
	World  = ReadByte(Now+0x00)
	Room   = ReadByte(Now+0x01)
	Place  = ReadShort(Now+0x00)
	Door   = ReadShort(Now+0x02)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)
	PrevPlace = ReadShort(Now+0x30)
end

keepAbilities()
KeepGrowth()
end