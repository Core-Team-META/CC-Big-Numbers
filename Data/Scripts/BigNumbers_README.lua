--[[
  Big Numbers library
  V1.0 - 1/19/2021
  by Chris


This is a library to handle large numbers, without losing percision.
You can do math on 100-digit numbers!

Setup:
----------------
  * Add the _BigNumbers file to your script as a custom project.
  * require() the _BigNumbers file, to allow your script to access it.
  * Do fun big number stuff!
  

Example Setup:
----------------
Drag the "_BigNumbers" script file onto your script, as a custom property.
Then add a line like this to the top of your file:

  local prop_BigNumbers = script:GetCustomProperty("_BigNumbers")
  bn = require(prop_BigNumbers)
  
And then you can use the big numbers functions in your script!

Check out the BigNumbersExamples file, for sample code showing off
what you can do with big numgers.


Files:
----------------
  BigNumbers_README
      the file you are currently reading.  This file.
      
  _BigNumbers
      The file containing all the actual logic for big numbers.  You should
      never need to open it directly, but you will probably want to
      require() it into your scripts, to use big numbers!
      
  BigNumbersExamples
      A bunch of examples for how big numbers work.  Look here to see a runthrough
      of what kinds of things you 
  
  BigNumbersTests
      Unit tests!  These are mostly for me to test that everything works the way
      it should.  You can use it for example code if you want, but mostly it's
      so that I can quickly verify 
      




Caveats:
----------------
* Big Numbers are considerably slower to use than basic lua Numbers.
  Multiplication and Division in particular are fairly expensive.
  Try not to have too many happening at once.
  
* Big Numbers do not support decimal points - They are always represented
  as integers, and any decimals are always dropped.
  




]]