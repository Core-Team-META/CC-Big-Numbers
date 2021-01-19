--[[
  Big Numbers Examples
  V1.0 - 1/19/2021
  by Chris
  
  This file contains examples for how to use big numbers!
  See the readme for more information!
]]


local prop_BigNumbers = script:GetCustomProperty("_BigNumbers")
bn = require(prop_BigNumbers)


-- You can create new big numbers using the New constructor:
local myBigNumber = bn.New(10)

-- Once you have a big number, you can do basic arithmatic to it:
local myOtherBigNumber = bn.New(555666)
myBigNumber = myBigNumber + bn.New(555666)
myBigNumber = myBigNumber - bn.New(234567)
myBigNumber = myBigNumber * bn.New(99999)
myBigNumber = myBigNumber / bn.New(11223)

-- You can also do math operations using regular Lua numbers:
myBigNumber = myBigNumber + 91556
myBigNumber = myBigNumber - 1251
myBigNumber = myBigNumber * 82345
myBigNumber = myBigNumber / 522


-- Comparisons also work, of course!
if myBigNumber ~= 5 then print("Big number is not five!") end
if myBigNumber > 5 then print("It's bigger than 5!") end


-- You can print big numbers directly:
print(myBigNumber)

-- You can also transform the big number into a string.
print("String: " .. myBigNumber:AsString())

-- You can also transform the big number into a pretty string!
print("Pretty string: " .. myBigNumber:AsPrettyString())

-- You can transform big numbers into abreviated strings also.
-- Similar to pretty strings, but shorter!
print("String: " .. myBigNumber:AsShortString())


-- Big numbers can be saved/loaded from player storage, by converting
-- them to/from strings:

-- (This code is disabled in this example so as not to throw errors
-- if long term storage is disabled.)
if false then

local players = Game.GetPlayers()
while #players == 0 do Task.Wait() end
local player = Game.GetPlayers()[1]
local playerData = Storage.GetPlayerData(player)
playerData.BigNumber = myBigNumber:AsString()
Storage.SetPlayerData(player, playerData)

-- ...later...

playerData = Storage.GetPlayerData(player)
local reloadedBigNumber = bn.New(playerData.BigNumber)
print("Successfully reloaded number: ", reloadedBigNumber)


end