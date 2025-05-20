local sortedtable_arguments = {
  "Value", 
  "Cars"
}
local arguments = {
  "Building", 
  "Price", 
  "Seats", 
  "Probe Capacity", 
  "Speed", 
  "Off-Road", 
  "Acceleration", 
  "Fuel Economy", 
  "Fuel Capacity", 
  "Deployment Speed", 
  "Wind Resistance Low", 
  "Wind Resistance High",
}
local carfilterproperties = {
  ["Building"] = {
    "Dealership", 
    "Warehouse", 
  }, 
  ["Wheel_Drive"] = {
    "FWD", 
    "AWD", 
    "RWD", 
  }, 
  ["Fuel_Type"] = {
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
  
  local ClosestValue = nil
  local AddedSpecificValueCars = {}
  for Car, Specifics in pairs(CarTablev) do
    local Specific = Specifics[aNumber]
    local Value = Direction * math.log(Specific)
    
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
  
  ClosestValue = math.exp(Direction * ClosestValue)
  table.insert(SortedCarsv, {["Value"] = ClosestValue, ["Cars"] = AddedSpecificValueCars})
  
  return CarTablev, SortedCarsv
end
local function TranslateArgument(Argument, aTable)
  for Index, Specific in ipairs(aTable) do
    if Argument == Specific then
      return Index
    end
  end
end
local function PrintSortedTable(TTable, aNumber)
  for TableNumber, OrderedTable in ipairs(TTable) do
    for CarNumber, Car in ipairs(OrderedTable[sortedtable_arguments[2]]) do
      print(Car, OrderedTable[sortedtable_arguments[1]], aNumber)
    end
  end
end
local function SortByArgument(aIndex, aTable, CarTable, Direction)
  local CarTablev = CarTable 
  local SortedCars = {}
  
  local aNumber = TranslateArgument(aTable[aIndex], aTable)
  
  while true do
    CarTablev, SortedCars = Reiteration(CarTablev, aNumber, Direction, SortedCars)
    
    local c = 0
    for i, v in pairs(CarTablev) do
      c = c + 1
    end
    
    if c == 0 then
      break
    end
  end
  
  return SortedCars, aTable[aIndex]
end
local function GetCarList(requirements, vehicles)
  local Checksout = {}
  for Vehicle, Statistics in pairs(vehicles) do
    local Enter = true
    for reqNumber, Requirement in ipairs(requirements) do
      if Requirement then
        if Requirement ~= Statistics[reqNumber] then
          Enter = false
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
  ["Dominator 1"] = {{2, 100000,}, {2, 1, 4, 2,}, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
  ["2009 Dominator 1"] = {{2, 125000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
  ["2011 Dominator 1"] = {{2, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
  ["2012 Dominator 1"] = {{2, 130000, }, {2, 1, 4, 2, }, {105, 65, 400, 9, 26, 4, 140, 170, }}, 
  ["2013 Dominator 1"] = {{2, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
  ["2014 Dominator 1"] = {{2, 135000, }, {2, 1, 4, 2, }, {105, 65, 200, 9, 26, 4, 140, 170, }}, 
  ["Dominator 2"] = {{2, 150000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
  ["2012 Dominator 2"] = {{2, 185000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
  ["2013 Dominator 2"] = {{2, 185000, }, {2, 1, 4, 1, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
  ["2014 Dominator 2"] = {{2, 185000, }, {2, 1, 4, 2, }, {110, 60, 225, 13, 31, 9, 145, 190, }}, 
  ["Dominator 3"] = {{2, 250000, }, {2, 2, 5, 2, }, {110, 65, 265, 16, 35, 9, 155, 210, }}, 
  ["2013 Dominator 3"] = {{2, 260000, }, {2, 2, 5, 2, }, {110, 60, 225, 16, 35, 9, 155, 210, }}, 

  ["TIV 1"] = {{2, 100000, }, {3, 2, 4, 2, }, {95, 50, 180, 12, 92, 9, 150, 175, }}, 
  ["2025 TIV 1"] = {{2, 110000, }, {3, 2, 4, 2, }, {95, 50, 100, 12, 92, 9, 150, 175, }}, 
  ["TIV 2"] = {{2, 300000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
  ["2008 TIV 2"] = {{2, 370000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 21, 155, 210, }}, 
  ["2009 TIV 2"] = {{2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 23, 155, 235, }}, 
  ["2010 TIV 2"] = {{2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 23, 155, 235, }}, 
  ["2012 TIV 2"] = {{2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 150, 230, }}, 
  ["2012 Tornado Alley TIV 2"] = {{2, 400000,}, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
  ["2015 TIV 2"] = {{2, 340000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 155, 235, }}, 
  ["2020 TIV 2"] = {{2, 320000, }, {2, 2, 4, 2, }, {110, 75, 185, 8, 92, 27, 150, 200, }}, 
  ["2023 TIV 2"] = {{2, 400000, }, {2, 2, 3, 2, }, {110, 75, 185, 8, 92, 20, 150, 220, }}, 
  ["2024 TIV 2"] = {{2, 425000, }, {2, 2, 3, 2, }, {110, 75, 185, 8, 92, 20, 150, 220, }}, 

  ["DOW 3"] = {{2, 500000, }, {3, 2, 3, 0, }, {95, 50, 560, 5, 60, 112, 120, 105, }}, 
  ["DOW 6"] = {{2, 750000, }, {3, 2, 3, 2, }, {100, 55, 700, 9, 100, 141, 120, 105, }}, 

  ["RaXPol"] = {{2, 550000, }, {3, 2, 4, 0, }, {110, 65, 500, 5, 40, 38, 120, 115, }}, 


  ["2006 Bullhorn Buffalo 1500"] = {{1, 24000, }, {2, 1, 4, 3, }, {110, 65, 375, 17, 34, 1, 100, 100, 1, 2, 1, }}, 
  ["2006 Bullhorn Buffalo 2500"] = {{1, 32000, }, {2, 2, 4, 3, }, {110, 65, 375, 17, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["1995 Bullhorn Buffalo 3500"] = {{1, 19000, }, {2, 1, 4, 3, }, {100, 65, 180, 14, 35, 1, 100, 100, 1, 2, 1, }}, 
  ["2006 Bullhorn Buffalo 3500"] = {{1, 37000, }, {2, 2, 4, 3, }, {110, 65, 375, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2017 BullHorn Buffalo 3500"] = {{1, 40000, }, {2, 2, 4, 4, }, {110, 70, 465, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2017 BullHorn Prancer SXT"] = {{1, 41500, }, {3, 1, 4, 1, }, {140, 55, 285, 23, 18.5, 1, 100, 100, 1, 3, 1, }}, 
  ["2009 Doghouse"] = {{1, 24500, }, {2, 2, 4, 3, }, {110, 65, 375, 15, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["Early 2010 Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2010 Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 65, 375, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2010 Bullhorn Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2010 Filming Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 13, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2012 Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 14, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2014 Doghouse"] = {{1, 49000, }, {2, 2, 5, 2, }, {110, 70, 375, 14, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["2015 Doghouse"] = {{1, 54000, }, {2, 2, 5, 3, }, {110, 70, 375, 14, 35, 1, 100, 100, 1, 2, 2, }}, 
  ["Vortex 2 Probe Truck"] = {{1, 69000, }, {2, 1, 4, 4, }, {110, 65, 375, 17, 34, 1, 100, 100, 1, 2, 1, }}, 
  ["Twister Tamer"] = {{1, 120000, }, {2, 2, 4, 3, }, {110, 85, 500, 100, 35, 1, 100, 100, 1, 2, 2, }}, 

  ["Car_Name"] = {{0, 0, }, {0, 0, 0, 0, }, {0, 0, 0, 0, 0, 1, 100, 100, 1, 0, 0, }}, 
}

local cars, carproperties, argumentnumber, direction = warehouse, wh_arguments, 1, 1
PrintSortedTable(SortByArgument(argumentnumber, carproperties, cars, direction))
