local sortedtable_arguments = {
	"Value", 
	"Cars"
}
local arguments = {
	{
		{"Building", nil, }, 
		{"Brand", nil, }, 
		{"Price", -1, }, 
	}, 
	{
		{"Wheel Drive", nil, }, 
		{"Fuel Type", nil, }, 
		{"Seats", 1, },
		{"Probe Capacity", 1, }, 
	}, 
	{
		{"Speed", 1, }, 
		{"Off-Road", 1, }, 
		{"Acceleration", 1, }, 
		{"Fuel Economy", 1, }, 
		{"Fuel Capacity", 1, }, 
		{"Deployment Speed", -1, }, 
		{"Wind Resistance Low", 1, }, 
		{"Wind Resistance High", 1, }, 
	}, 
}
local carfilterproperties = {
	["Building"] = {
		"Dealership", 
		"Warehouse", 
		"EMS", 
	}, 
	["Wheel Drive"] = {
		"FWD", 
		"AWD", 
		"RWD", 
	}, 
	["Fuel Type"] = {
		"Gasoline", 
		"Diesel", 
	}, 
}
local brands = {
	"Dominator Series", --Ford, aka Falcon in-game, --General Motors, aka Brawnson in-game, --and Chevrolet, aka Chevlon in-game
	"Tornado Intercept Vehicle Series", --Ford, aka Falcon in-game
	"Doppler on Wheels", --Ford, aka Falcon in-game
	"Rapid X-band Polarimetric Radar", --Chevrolet (aka Chevlon in-game
	"Dodge", --aka Bullhorn in-game
	"Honda", --aka Elysion in-game
	"Subaru", --aka Sumo in-game
	"Ford", --aka Falcon in-game
	"Toyota", --aka Vellfire in-game
	"Saturn", --aka Combi in-game
	"Chevrolet", --aka Chevlon in-game
	"General Motors", --aka Brawnson in-game
	"Nissan", --aka Navara in-game
}

local function Reiteration(CarTable, aNumber, Direction, SortedCars)
	local CarTablev, SortedCarsv = CarTable, SortedCars

	local ClosestValue, AddedSpecificValueCars
	for Car, Specifics in pairs(CarTablev) do
		local Specific = Specifics[aNumber[1]][aNumber[2]]
		local Value = Direction * math.log10(Specific)

		local function Reset()
			ClosestValue = Value
			AddedSpecificValueCars = {}
		end

		if ClosestValue == nil then
			Reset()
			table.insert(AddedSpecificValueCars, Car)
		elseif Value >= ClosestValue then
			if Value > ClosestValue then
				Reset()
			end
			table.insert(AddedSpecificValueCars, Car)
		end
	end

	for CarNumber, Car in ipairs(AddedSpecificValueCars) do
		CarTablev[Car] = nil
	end

	ClosestValue = 10 ^ (Direction * ClosestValue)
	table.insert(SortedCarsv, {[sortedtable_arguments[1]] = ClosestValue, [sortedtable_arguments[2]] = AddedSpecificValueCars})

	return CarTablev, SortedCarsv
end
local function TranslateArgument(Argument, aTable)
	for PropertyGroupIndex, Specific in ipairs(aTable) do
		for Index, Value in ipairs(Specific) do
			if Argument == Value then
				return {PropertyGroupIndex, Index}
			end
		end
	end
end
local function Round(Number)
	if 2 * math.abs(math.ceil(Number) - Number) > 1 then
		return math.floor(Number)
	else
		return math.ceil(Number)
	end
end
local function PrintSortedTable(TTable, aNumber)
	print(aNumber.."\n")
	for TableNumber, OrderedTable in ipairs(TTable) do
		local v_1 = tostring(Round(OrderedTable[sortedtable_arguments[1]] * 10))
		local printing = string.sub(v_1, 1, -2).."."..string.sub(v_1, -1)
		for CarNumber, Car in ipairs(OrderedTable[sortedtable_arguments[2]]) do
			printing = printing.."\n\t"..Car
		end
		print(printing)
	end
end
local function SortByArgument(aIndex, aTable, CarTable, Direction)
	local CarTablev = CarTable 
	local SortedCars = {}

	while true do
		CarTablev, SortedCars = Reiteration(CarTablev, TranslateArgument(aTable[aIndex[1]][aIndex[2]], aTable), Direction, SortedCars)

		local c = 0
		for i, v in pairs(CarTablev) do
			c = c + 1
		end

		if c == 0 then
			break
		end
	end

	return SortedCars, aTable[aIndex[1]][aIndex[2]]
end
local function GetCarList(requirements, vehicles)
	local Checksout = {}
	for Vehicle, Statistics in pairs(vehicles) do
		local Enter = true
		for sortedReq, sortedReqs in ipairs(requirements) do
			for reqNumber, Requirement in ipairs(sortedReqs) do
        for potNumber, Potential in ipairs(Requirement) do
          if Potential then
            if Potential ~= Statistics[sortedReq][reqNumber] then
              Enter = not ((not Enter) or Potential == Statistics[sortedReq][reqNumber]) 
            end
          end
        end
				if Requirement then
				  if Requirement ~= Statistics[sortedReq][reqNumber] then
					  Enter = false
					end
				end
			end
		end

		if Enter then
			Checksout[Vehicle]  = Statistics
		end
	end

	return Checksout
end
local cars = {
	["Dominator 1"] = {{2, 1, 100000,}, {2, 1, 4, 2,}, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
	["2009 Dominator 1"] = {{2, 1, 125000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
	["2011 Dominator 1"] = {{2, 1, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
	["2012 Dominator 1"] = {{2, 1, 130000, }, {2, 1, 4, 2, }, {105, 65, 400, 9, 26, 4, 140, 170, }}, 
	["2013 Dominator 1"] = {{2, 1, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
	["2014 Dominator 1"] = {{2, 1, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
	["Dominator 2"] = {{2, 1, 150000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
	["2012 Dominator 2"] = {{2, 1, 185000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
	["2013 Dominator 2"] = {{2, 1, 185000, }, {2, 1, 4, 1, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
	["2014 Dominator 2"] = {{2, 1, 185000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
	["Dominator 3"] = {{2, 1, 250000, }, {2, 2, 5, 2, }, {110, 65, 265, 16, 35, 9, 155, 210, }}, 
	["2013 Dominator 3"] = {{2, 1, 260000, }, {2, 2, 5, 2, }, {110, 60, 225, 16, 35, 9, 155, 210, }}, 

	["TIV 1"] = {{2, 2, 100000, }, {3, 2, 4, 2, }, {95, 50, 180, 12, 92, 9, 150, 175, }}, 
	["2025 TIV 1"] = {{2, 2, 110000, }, {3, 2, 4, 2, }, {95, 50, 100, 12, 92, 9, 150, 175, }}, 
	["TIV 2"] = {{2, 2, 300000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
	["2008 TIV 2"] = {{2, 2, 370000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 21, 155, 210, }}, 
	["2009 TIV 2"] = {{2, 2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 23, 155, 235, }}, 
	["2010 TIV 2"] = {{2, 2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 23, 155, 235, }}, 
	["2012 TIV 2"] = {{2, 2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 150, 230, }}, 
	["2012 Tornado Alley TIV 2"] = {{2, 2, 400000,}, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
	["2015 TIV 2"] = {{2, 2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
	["2020 TIV 2"] = {{2, 2, 320000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 150, 200, }}, 
	["2023 TIV 2"] = {{2, 2, 400000, }, {2, 2, 3, 2, }, {110, 75, 185, 8, 92, 20, 150, 220, }}, 
	["2024 TIV 2"] = {{2, 2, 425000, }, {2, 2, 3, 2, }, {110, 75, 185, 8, 92, 20, 150, 220, }}, 

	["DOW 3"] = {{2, 3, 500000, }, {3, 2, 3, 0, }, {95, 50, 560, 5, 60, 112, 120, 105, }}, 
	["DOW 6"] = {{2, 3, 750000, }, {3, 2, 3, 2, }, {100, 55, 700, 9, 100, 141, 120, 105, }}, 

	["RaXPol"] = {{2, 4, 550000, }, {3, 2, 4, 0, }, {110, 65, 500, 5, 40, 38, 120, 115, }}, 


	["2006 Bullhorn Buffalo 1500"] = {{1, 5, 24000, }, {2, 1, 4, 3, }, {110, 65, 375, 17, 34, 0.5, 90, 105, }}, 
	["2006 Bullhorn Buffalo 2500"] = {{1, 5, 32000, }, {2, 2, 4, 3, }, {110, 65, 375, 17, 35, 0.5, 90, 105, }}, 
	["1995 Bullhorn Buffalo 3500"] = {{1, 5, 19000, }, {2, 1, 4, 3, }, {100, 65, 180, 14, 35, 0.5, 90, 105, }}, 
	["2006 Bullhorn Buffalo 3500"] = {{1, 5, 37000, }, {2, 2, 4, 3, }, {110, 65, 375, 13, 35, 0.5, 90, 105, }}, 
	["2017 BullHorn Buffalo 3500"] = {{1, 5, 40000, }, {2, 2, 4, 4, }, {110, 70, 465, 13, 35, 0.5, 90, 105, }}, 
	["2017 BullHorn Prancer SXT"] = {{1, 5, 41500, }, {3, 1, 4, 1, }, {140, 55, 285, 23, 18.5, 0.5, 90, 105, }}, 
	["2009 Doghouse"] = {{1, 5, 24500, }, {2, 2, 4, 3, }, {110, 65, 375, 15, 35, 0.5, 90, 105, }}, 
	["Early 2010 Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 0.5, 90, 105, }}, 
	["2010 Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 65, 375, 13, 35, 0.5, 90, 105, }}, 
	["2010 Bullhorn Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 0.5, 90, 105, }}, 
	["2010 Filming Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 0.5, 90, 105, }}, 
	["2012 Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 14, 35, 0.5, 90, 105, }}, 
	["2014 Doghouse"] = {{1, 5, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 14, 35, 0.5, 90, 105, }}, 
	["2015 Doghouse"] = {{1, 5, 54000, }, {2, 2, 5, 3, }, {110, 70, 375, 14, 35, 0.5, 90, 105, }}, 
	["Vortex 2 Probe Truck"] = {{1, 5, 69000, }, {2, 1, 4, 4, }, {110, 65, 375, 17, 34, 0.5, 90, 105, }}, 
	["Twister Tamer"] = {{1, 5, 120000, }, {2, 2, 4, 3, }, {110, 85, 500, 100, 35, 0.5, 90, 105, }}, 

	["2006 Elysion Slick Si"] = {{1, 6, 7400, }, {1, 1, 5, 2, }, {100, 55, 139, 25, 13.2, 0.5, 90, 105, }}, 

	["2018 Sumo Woodlands XT"] = {{1, 7, 13000, }, {2, 1, 4, 3, }, {110, 55, 258, 28, 15.9, 0.5, 90, 105, }},
	["Dominator Fore"] = {{1, 7, 26000, }, {2, 1, 4, 2, }, {110, 55, 258, 28, 15.9, 0.5, 90, 105, }},

	["1997 Falcon Traveller XLT"] = {{1, 8, 7500, }, {2, 1, 4, 3, }, {100, 55, 290, 15, 30, 0.5, 90, 105, }},
	["2017 Flacon Advance Lariat"] = {{1, 8, 29000, }, {2, 1, 4, 3, }, {105, 65, 400, 17, 23, 0.5, 90, 105, }},

	["2011 Vellfire Prairie Grade"] = {{1, 9, 27000, }, {2, 1, 4, 3, }, {105, 65, 401, 14, 26, 0.5, 90, 105, }},

	["2021 Combi Kuma GT-Line"] = {{1, 10, 25490, }, {1, 1, 4, 2, }, {125, 55, 195, 30, 14, 0.5, 90, 105, }},
	["Grizzly"] = {{1, 10, 50980, }, {1, 1, 4, 2, }, {125, 55, 195, 30, 14, 0.5, 90, 105, }},

	["1992 Chevlon 454 SS"] = {{1, 11, 0, }, {3, 1, 2, 3, }, {108, 50, 405, 11, 25, 0.5, 90, 105, }},
	["2008 Chevlon Camion EXT"] = {{1, 11, 16000, }, {2, 1, 4, 3, }, {105, 60, 380, 16, 31, 0.5, 90, 105, }},
	["Discovery Support Vehicle"] = {{1, 11, 21500, }, {2, 1, 4, 3, }, {105, 60, 380, 16, 31, 0.5, 90, 105, }},
	["2017 Chevlon Platoro 1500"] = {{1, 11, 30000, }, {2, 1, 4, 3, }, {115, 70, 383, 20, 26, 0.5, 90, 105, }},
	["2006 Chevlon Zafiro"] = {{1, 11, 13000, }, {1, 1, 2, 2, }, {100, 40, 214, 28, 13, 0.5, 90, 105, }},

	["2011 Brawnson Arlington"] = {{1, 12, 14000, }, {2, 1, 7, 3, }, {105, 60, 380, 18, 26, 0.5, 90, 105, }},
	["Ole Blue"] = {{1, 12, 28000, }, {2, 1, 7, 3, }, {105, 60, 380, 18, 26, 0.5, 90, 105, }},

	["1991 Navara Territory"] = {{1, 13, 4500, }, {2, 1, 5, 3, }, {115, 65, 180, 14, 21, 0.5, 90, 105, }},
	["Scout"] = {{1, 13, 9300, }, {2, 1, 5, 4, }, {115, 65, 180, 14, 21, 0.5, 90, 105, }},
}

local categories = {
  {{2}, {nil}, {nil}, }, 
  {{1, 2}, {nil}, {nil}, {nil}, }, 
  {{nil}, {nil}, {nil}, {nil}, {nil}, {nil}, {nil}, {nil}, }
}

PrintSortedTable(SortByArgument({3, 1}, arguments, GetCarList(categories, cars), 1))
