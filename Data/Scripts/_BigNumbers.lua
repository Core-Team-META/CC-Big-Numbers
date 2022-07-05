--[[
  Large Numbers Library
  V1.0 - 1/7/2021
  by Chris
  
  This is the main script file, containing the actual logic for large numbers.
  See the readme for more information on how to use it!
]]


local BigNumber = {}
local bnMetaTable = {}


local numNames = {
[6] = "Million",
[9] = "Billion",
[12] = "Trillion",
[15] = "Quadrillion",
[18] = "Quintillion",
[21] = "Sextillion",
[24] = "Septillion",
[27] = "Octillion",
[30] = "Nonillion",
[33] = "Decillion",
[36] = "Undecillion",
[39] = "Duodecillion",
[42] = "Tredecillion",
[45] = "Quattuordecillion",
[48] = "Quindecillion",
[51] = "Sexdecillion",
[54] = "Septendecillion",
[57] = "Octodecillion",
[60] = "Novemdecillion",
[63] = "Vigintillion",
[66] = "Unvigintillion",
[69] = "Duovigintillion",
[72] = "Trevigintillion",
[75] = "Quattuorvigintillion",
[78] = "Quinvigintillion",
[81] = "Sexvigintillion",
[84] = "Septenvigintillion",
[87] = "Octovigintillion",
[90] = "Novemvigintillion",
[93] = "Trigintillion",
[96] = "Untrigintillion",
[99] = "Duotrigintillion",
[102] = "Tretrigintillion",
[105] = "Quattortrigintillion",
[108] = "Quintrigintillion",
[111] = "Sextrigintillion",
[114] = "Septentrigintillion",
[117] = "Octotregintillion",
[120] = "Novemtrigintillion"
}




local numShortNames = {
[6] = "Mil",
[9] = "Bil",
[12] = "Tril",
[15] = "Quad",
[18] = "Quintn",
[21] = "Sext",
[24] = "Sept",
[27] = "Oct",
[30] = "Non",
[33] = "Dec",
[36] = "Udec",
[39] = "Ddec",
[42] = "Tdec",
[45] = "Qtdec",
[48] = "Qnidec",
[51] = "Sxdec",
[54] = "Spdec",
[57] = "Ocdec",
[60] = "Nvdec",
[63] = "Vig",
[66] = "Uvig",
[69] = "Dvig",
[72] = "Tvig",
[75] = "Qtvig",
[78] = "Qnvig",
[81] = "Sxvig",
[84] = "Stvig",
[87] = "Ocvig",
[90] = "Nvvig",
[93] = "Trig",
[96] = "Untrig",
[99] = "Duotrig",
[102] = "Ttrig",
[105] = "Qttrig",
[108] = "Qntrig",
[111] = "Sxtrig",
[114] = "Sptrig",
[117] = "Octrig",
[120] = "Nvtrig"}

local minNumNames = 6
local maxNumNames = 120


-- Handy utility function for trimming preceeding zeros.
function TrimZeros(s)
	local i = 0
	while s:byte(i + 1) == 48 do -- ascii 0
		i = i + 1
	end
	if i == s:len() then i = i - 1 end
	return s:sub(i + 1) 
end

local max_int = 99999999999999999
local max_int_digits = tostring(max_int):len()

function BigNumber.CanBeInt(self)
	return self.raw:len() <= max_int_digits
end


function BigNumber.New(n, sign)
	local sign = sign or 1
	local raw = "0"
	if type(n) == "number" then
		if n < 0 then
			n = math.abs(n)
			sign = -1
		end
		n = math.floor(n)
		raw = tostring(n)
	elseif type(n) == "table" then
		sign = n.sign or 1
		raw = n.raw or "0"
	elseif type(n) == "string" then
		sign = sign or 1
		if n:sub(1, 1) == "-" then
			sign = sign * -1
			n = n:sub(2)
		end
		raw = TrimZeros(n) -- this could be bad if it has decimals etc
	else
		sign = sign or 1
		n = "0"
	end
	if n == "0" then sign = 1 end
	newBigNumber = {
		raw = raw,
		sign = sign,
	}
	setmetatable(newBigNumber, bnMetaTable)
	return newBigNumber
end

function BigNumber.IsEqual(a, _b)
  local b = BigNumber.New(_b)
  return a.raw == b.raw and a.sign == b.sign
end

function BigNumber.IsLessThan(_a, _b)
  local a = BigNumber.New(_a)
  local b = BigNumber.New(_b)
  return Compare(a, b) == -1
end

function BigNumber.IsLessThanOrEqual(_a, _b)
  local a = BigNumber.New(_a)
  local b = BigNumber.New(_b)
  return BigNumber.IsEqual(a, b) or Compare(a, b) == -1
end


function BigNumber.Invert(self)
	local res = BigNumber.New(self)
	res.sign = res.sign * -1
	return res
end


function Compare(a, b)
	-- Check signs:
	if a.sign < b.sign then return -1 end
	if a.sign > b.sign then return 1 end
	
	-- check string length:
	if a.raw:len() < b.raw:len() then return -1 * a.sign end
	if a.raw:len() > b.raw:len() then return 1 * a.sign end
	
	for i=1, a.raw:len() do
		local ab = a.raw:byte(i)
		local bb = b.raw:byte(i)
		if ab < bb then
			return -1 * a.sign
		elseif 	ab > bb then
			return 1 * a.sign
		end
		-- Else the digits are equal (so far) and keep going
	end
	
	-- They seem equal.
	return 0
end

function GetDigit(s, n)
	return (s:byte(math.max(n, 0)) or 48) - 48, n < 1
end

function BigNumber.ToString(self)
	local prefix = ""
	if self.sign == -1 then prefix = "-" end
	return prefix .. self.raw
end

function BigNumber.AsNumber(self)
	local num = tonumber(self.raw)
	return num * self.sign
end

function BigNumber.AsString(self)
  return self:ToString()
end


function FindNumPrefix(digitCount, numNameList)
	local foundDigit = digitCount - 1
	if foundDigit > maxNumNames then return maxNumNames end
	while numNameList[foundDigit] == nil do
		if foundDigit < minNumNames then return 0 end
		foundDigit = foundDigit - 1
	end
	return foundDigit
end

function BigNumber.AsPrettyString(self)
	return PrettyStringHelper(self, numNames)
end

function BigNumber.AsShortString(self)
	return PrettyStringHelper(self, numShortNames)
end


function PrettyStringHelper(num, nameList)
	local currentDigits = num.raw:len()
	local foundDigit = FindNumPrefix(num.raw:len(), nameList)
	
	if foundDigit == 0 then return num:ToString() end
	
	local numName = nameList[foundDigit]
	local numString = num.raw:sub(1, currentDigits - foundDigit)
	if num.sign < 0 then numString = "-" .. numString end
	return numString .. " " .. numName
end




function BigNumber.Add(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	local result = ""
	local carry = 0
	if a.sign < 0 and b.sign > 0 then
		return SubtractHelper(b, -a)
	elseif b.sign < 0 and a.sign > 0 then
		return SubtractHelper(a, -b)
	end

	for i = 1, math.max(a.raw:len(), b.raw:len()) do
		aa = GetDigit(a.raw, a.raw:len() + 1 - i)
		bb = GetDigit(b.raw, b.raw:len() + 1 - i)
		newDigit = aa + bb + carry
		carry = 0
		if newDigit >= 10 then
			carry = 1
			newDigit = newDigit - 10
		elseif newDigit < 0 then
			carry = -1
			newDigit = newDigit + 10
		end
		result = tostring(newDigit) .. result
	end
	
	if carry > 0 then 
		result = tostring(carry) .. result 
	end
	return BigNumber.New(TrimZeros(result), a.sign)
end


function BigNumber.Subtract(a, b)
	return BigNumber.Add(a, BigNumber.Invert(b))
end


function SubtractHelper(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	if a.sign ~= b.sign then
		return BigNumber.Add(a, -b)
	end
	
	local result = ""
	local borrow = 0
	local finalSignFlip = 1
	
	if b > a then
		local temp = a
		a = b
		b = temp
		finalSignFlip = -1
	end

	for i = 1, math.max(a.raw:len(), b.raw:len()) do
		aa = GetDigit(a.raw, a.raw:len() + 1 - i)
		bb = GetDigit(b.raw, b.raw:len() + 1 - i)
		newDigit = aa - bb + borrow
		
		borrow = 0
		if newDigit < 0 then
			borrow = -1
			newDigit = newDigit + 10
		end
		result = tostring(newDigit) .. result
	end
	
	return BigNumber.New(TrimZeros(result), a.sign * finalSignFlip)
end


function BigNumber.Multiply(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	preCarryResults = {}
	for i_a = 1, a.raw:len() do
		digit_a = GetDigit(a.raw, a.raw:len() + 1 - i_a)
		for i_b = 1, b.raw:len() do
			digit_b = GetDigit(b.raw, b.raw:len() + 1 - i_b)
			local index = i_b + i_a - 1
			if preCarryResults[index] == nil then preCarryResults[index] = 0 end
			preCarryResults[index] = preCarryResults[index] + digit_a * digit_b
		end
	end

	local newRaw = ""
	for k,v in ipairs(preCarryResults) do
		newRaw = tostring(v % 10) .. newRaw

		local carry = math.floor(v/10)
		if carry > 0 then
			if preCarryResults[k + 1] == nil then
				preCarryResults[k + 1] = carry
			else
				preCarryResults[k + 1] = preCarryResults[k + 1] + carry
			end
		end
	end

	return BigNumber.New(TrimZeros(newRaw), a.sign * b.sign)

end

function BigNumber.Divide(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	local div, mod
	if b:CanBeInt() then
		div, mod = IntDivideHelper(a, b:AsNumber())
	else
		div, mod = DivideHelper(a, b)
	end
	return div
end


function BigNumber.Modulo(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	if b:CanBeInt() then
		div, mod = IntDivideHelper(a, b:AsNumber())
	else
		div, mod = DivideHelper(a, b)
	end
	return mod
end


-- rounds the big number a up to the next 10s digit
function RoundUp(a)
	local needToRound = false
	for i = 2, a.raw:len() do
		if a.raw:sub(i, i) ~= "0" then
			needToRound = true
			break
		end
	end
	if needToRound == false then return a end

	local newRaw = tostring(GetDigit(a.raw, 1) + 1) .. string.rep("0", a.raw:len() - 1)
	return BigNumber.New(newRaw, a.sign)
end



-- Performs the actual divison
-- returns the dividend and oodulo
function DivideHelper(a, b)
	-- First calculate something "sorta close":
	local finalSign = a.sign * b.sign
	a.sign = 1
	b.sign = 1

	if b == 0 then
		error("Divison by zero!")
	end

	local over = BigNumber.New(1)
	local under = BigNumber.New(1)
	over.raw = over.raw .. string.rep("0", a.raw:len() - b.raw:len() + 1)
	under.raw = under.raw .. string.rep("0", a.raw:len() - b.raw:len() - 1)

	local done = false

	local currentStep = BigNumber.New(1)
	local spread = over - under
	local stepList = {}
	while currentStep < spread do
		table.insert(stepList, BigNumber.New(currentStep))
		currentStep = currentStep * 2
	end

	table.remove(stepList)
	local div = table.remove(stepList)
	if div == nil then div = BigNumber.New(0) end
	local check = 0
	while #stepList > 0 do
		local currentStep = table.remove(stepList)
		check = div * b
		if check == a then
			break
		elseif check < a then
			div = div + currentStep
		else
			div = div - currentStep
		end
	end

	check = div * b
	if check > a then
		check = check - b
		div = div - 1
	end
	local mod = a - check
	div.sign = finalSign
	return div, mod
end



-- Optiomized version of division, where B is an integer.
function IntDivideHelper(_a, b)
	local a = BigNumber.New(_a)
	if type(b) ~= "number" then
		print("type:", type(b))
		error("Somehow got a non-number for int divide helper")
	end
	local endSign = a.sign
	if b < 0 then endSign  = endSign * -1 end
	
	b = math.floor(math.abs(b))
	local b_digitCount = tostring(b):len()
	
	local aDigits = a.raw
	
	answerDigits = ""
	local currentA = 0
	while aDigits:len() > 0 do
		currentA = currentA * 10 + GetDigit(aDigits, 1)
		aDigits = aDigits:sub(2)
		local newDigit = math.floor(currentA / b)
		answerDigits = answerDigits .. tostring(newDigit)
		currentA = currentA % b
	end
	
	return BigNumber.New(answerDigits, endSign), BigNumber.New(currentA)
end

bnMetaTable = {
	__index = BigNumber,
	__add = BigNumber.Add,
	__sub = BigNumber.Subtract,
	__mul = BigNumber.Multiply,
	__div = BigNumber.Divide,
	__mod = BigNumber.Modulo,
	__unm = BigNumber.Invert,
	__eq = BigNumber.IsEqual,
	__lt = BigNumber.IsLessThan,
	__le = BigNumber.IsLessThanOrEqual,
	__tostring = BigNumber.ToString,
}


return {
	New = BigNumber.New
}