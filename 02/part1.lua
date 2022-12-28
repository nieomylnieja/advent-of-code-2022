local rock, paper, scissors = 1, 2, 3
local strategy = {
	["A"] = rock,
	["B"] = paper,
	["C"] = scissors,
	["X"] = rock,
	["Y"] = paper,
	["Z"] = scissors,
}

-- Rules
local rockWins = function (t)
  return t[2] == rock and t[1] == scissors
end
local paperWins = function (t)
  return t[2] == paper and t[1] == rock
end
local scissorsWin = function (t)
  return t[2] == scissors and t[1] == paper
end
local anyWiningConditionMet = function (t)
  return rockWins(t) or paperWins(t) or scissorsWin(t)
end

local score = 0
for line in io.lines("input.txt") do
  local t = {}
	for letter in string.gmatch(line, "%S+") do
		table.insert(t, strategy[letter])
	end
  local outcome = 0
  if t[2] == t[1] then
    outcome = 3
  elseif anyWiningConditionMet(t) then
    outcome = 6
  end
  score = score + t[2] + outcome
end

print(score)
