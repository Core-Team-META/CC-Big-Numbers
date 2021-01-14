﻿--[[
  Large Numbers Library
  V1.0 - 1/7/2021
  by Chris
]]


local BigNumber = {}
local bnMetaTable = {}


-- Handy utility function for trimming preceeding zeros.
function TrimZeros(s)
	local i = 0
	while s:byte(i + 1) == 48 do -- ascii 0
		i = i + 1
	end
	if i == s:len() then i = i - 1 end
	return s:sub(i + 1) 
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
		raw = n -- this could be bad if it has decimals etc
	else
		sign = sign or 1
		n = "0"
	end
	if n == "0" then sign = 1 end
	newBigNumber = {
		raw = raw,
		sign = sign,
	}
	setmetatable(newBigNumber, bnMetaTable

	)
	--print(newBigNumber)
	return newBigNumber
end

function BigNumber.IsEqual(a, _b)
	b = BigNumber.New(_b)
	return a.raw == b.raw and a.sign == b.sign
end

function BigNumber.IsLessThan(a, _b)
	b = BigNumber.New(_b)
	return Compare(a, b) == -1
end

function BigNumber.IsLessThanOrEqual(a, _b)
	b = BigNumber.New(_b)
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
	--return "[" .. prefix .. self.raw .. "]"
end


function BigNumber.Add(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	print("adding " .. tostring(a) .. " + " .. tostring(b))
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
		if newDigit > 10 then
			carry = 1
			newDigit = newDigit - 10
		elseif newDigit < 0 then
			carry = -1
			newDigit = newDigit + 10
		end
		--print(aa, " ", bb, " (", carry, ") = ", newDigit)
		result = tostring(newDigit) .. result
	end
	
	if carry > 0 then 
		result = tostring(carry) .. result 
	end
	print("Should be: ", tonumber(a.raw) * a.sign + tonumber(b.raw) * b.sign)
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
	
	print("subtracting " .. tostring(a) .. " - " .. tostring(b))
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
		--print(aa, " ", bb, " (", borrow, ") = ", newDigit)
		result = tostring(newDigit) .. result
	end
	
	if borrow < 0 then
		print("borrow:", borrow)
		--result = tostring(carry) .. result 
	end
	return BigNumber.New(TrimZeros(result), a.sign * finalSignFlip)
end


function BigNumber.Multiply(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	print("mult:", a,b)

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
	print("Dividing ", a, b)
	local div, mod = DivideHelper(a, b)
	return div
end


function BigNumber.Modulo(_a, _b)
	local a = BigNumber.New(_a)
	local b = BigNumber.New(_b)
	print("Dividing ", a, b)
	local div, mod = DivideHelper(a, b)
	return mod
end


function BigNumber.ToDo(self, other)
	print("Todo")
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
	local check = 0
	while #stepList > 0 do
		local currentStep = table.remove(stepList)
		check = div * b
		--print(currentStep, div, "   ", check, " -- ", a)
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


function BigNumber.Connect(self, func)
	self.listeners[func] = true
	return Listener.New(self, func)
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
--	__le = BigNumber.IsLessThanOrEqual,
	__tostring = BigNumber.ToString,
}


return {
	New = BigNumber.New
}