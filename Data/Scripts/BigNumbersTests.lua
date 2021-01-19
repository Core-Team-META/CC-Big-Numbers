--[[
  Big Numbers Tests
  V1.0 - 1/19/2021
  by Chris
  
  This file contains unit tests for big numbers.
  See the readme for more information!
]]

local prop_BigNumbers = script:GetCustomProperty("_BigNumbers")
bn = require(prop_BigNumbers)


local testCounter = 0
local failedCounter = 0

-- Quick utility functions so we can run through a bunch of math test cases!
function ValidateBN(a, b, message)
	testCounter = testCounter + 1
	if a ~= bn.New(b) then
		failedCounter = failedCounter + 1
		warn(message)
	end
end

function Validate(a, b, message)
	testCounter = testCounter + 1
	if a ~= b then
		failedCounter = failedCounter + 1
		warn(message)
		print(a, b)
	end
end


ValidateBN(bn.New( 55) + bn.New( 27),  55 +  27, "addition")
ValidateBN(bn.New(-55) + bn.New( 27), -55 +  27, "addition")
ValidateBN(bn.New( 55) + bn.New(-27),  55 + -27, "addition")
ValidateBN(bn.New(-55) + bn.New(-27), -55 + -27, "addition")

ValidateBN(bn.New( 155) + bn.New( 27),  155 +  27, "more addition")
ValidateBN(bn.New(-155) + bn.New( 27), -155 +  27, "more addition")
ValidateBN(bn.New( 155) + bn.New(-27),  155 + -27, "more addition")
ValidateBN(bn.New(-155) + bn.New(-27), -155 + -27, "more addition")

ValidateBN(bn.New( 55) + bn.New( 127),  55 +  127, "still more addition")
ValidateBN(bn.New(-55) + bn.New( 127), -55 +  127, "still more addition")
ValidateBN(bn.New( 55) + bn.New(-127),  55 + -127, "still more addition")
ValidateBN(bn.New(-55) + bn.New(-127), -55 + -127, "still more addition")

ValidateBN(bn.New(55) + bn.New(-55), 55 + -55, "adding inverses")
ValidateBN(bn.New(-55) + bn.New(55), -55 + 55, "adding inverses")

Validate(bn.New( 55) < bn.New( 27), false, "comparisons")
Validate(bn.New( 55) > bn.New( 27), true,  "comparisons")
Validate(bn.New(-55) < bn.New( 27), true,  "comparisons")
Validate(bn.New(-55) > bn.New( 27), false, "comparisons")
Validate(bn.New( 55) < bn.New(-27), false, "comparisons")
Validate(bn.New( 55) > bn.New(-27), true,  "comparisons")
Validate(bn.New(-55) < bn.New(-27), true,  "comparisons")
Validate(bn.New(-55) > bn.New(-27), false, "comparisons")
Validate(bn.New( 55) > bn.New( 55), false, "comparisons")

Validate(bn.New( 55) <= bn.New( 27), false, "more comparisons")
Validate(bn.New( 55) >= bn.New( 27), true,  "more comparisons")
Validate(bn.New(-55) <= bn.New( 27), true,  "more comparisons")
Validate(bn.New(-55) >= bn.New( 27), false, "more comparisons")
Validate(bn.New( 55) <= bn.New(-27), false, "more comparisons")
Validate(bn.New( 55) >= bn.New(-27), true,  "more comparisons")
Validate(bn.New(-55) <= bn.New(-27), true,  "more comparisons")
Validate(bn.New(-55) >= bn.New(-27), false, "more comparisons")
Validate(bn.New( 55) >= bn.New( 55), true,  "more comparisons")

Validate(bn.New( 55) * bn.New( 127), bn.New( 55 *  127), "multiplication")
Validate(bn.New(-55) * bn.New( 127), bn.New(-55 *  127), "multiplication")
Validate(bn.New( 55) * bn.New(-127), bn.New( 55 * -127), "multiplication")
Validate(bn.New(-55) * bn.New(-127), bn.New(-55 * -127), "multiplication")

Validate(bn.New( 55142) / bn.New( 127), bn.New( 55142 /  127), "division")
Validate(bn.New(-55142) / bn.New( 127), bn.New(-55142 /  127), "division")
Validate(bn.New( 55142) / bn.New(-127), bn.New( 55142 / -127), "division")
Validate(bn.New(-55142) / bn.New(-127), bn.New(-55142 / -127), "division")

Validate(bn.New( 127) / bn.New( 55142), bn.New( 127 /  55142), "division")
Validate(bn.New(-127) / bn.New( 55142), bn.New(-127 /  55142), "division")
Validate(bn.New( 127) / bn.New(-55142), bn.New( 127 / -55142), "division")
Validate(bn.New(-127) / bn.New(-55142), bn.New(-127 / -55142), "division")

Validate(bn.New( 5566):AsNumber(),  5566, "number conversion")
Validate(bn.New(-5566):AsNumber(), -5566, "number conversion")

Validate(bn.New(100000):AsPrettyString(), "100000", "Pretty Text")
Validate(bn.New(1000000):AsPrettyString(), "1 Million", "Pretty Text")
Validate(bn.New(10000000):AsPrettyString(), "10 Million", "Pretty Text")

Validate(bn.New(-100000):AsPrettyString(), "-100000", "Negative Pretty Text")
Validate(bn.New(-1000000):AsPrettyString(), "-1 Million", "Negative Pretty Text")
Validate(bn.New(-10000000):AsPrettyString(), "-10 Million", "Negative Pretty Text")


Validate(bn.New(10), bn.New(10), "Base Constructor")
Validate(bn.New("5000"), bn.New(5000), "Constructor #1")
Validate(bn.New("-5000"), bn.New(-5000), "Constructor #2")


print("Completed", testCounter, "tests. (", failedCounter, "failed)")