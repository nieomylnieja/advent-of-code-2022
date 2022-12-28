local rock, paper, scissors = 1, 2, 3
local loose, draw, win = 0, 3, 6
local strategy = {
	["A"] = rock,
	["B"] = paper,
	["C"] = scissors,
	["X"] = loose,
	["Y"] = draw,
	["Z"] = win,
}

-- We're using the fact that rock, paper and scissorcs
-- form an array of len(3), no need to create a map here.
local winning = { paper, scissors, rock }
local loosing = { scissors, rock, paper }

local score = 0
for line in io.lines("input.txt") do
	local t = {}
	for letter in string.gmatch(line, "%S+") do
		table.insert(t, strategy[letter])
	end
	local v = 0
	if t[2] == draw then
		v = t[1]
	elseif t[2] == win then
		v = winning[t[1]]
	elseif t[2] == loose then
		v = loosing[t[1]]
	else
		print("I don't recognize this!")
		os.exit(1)
	end
	print(string.format("[%s] -> %s + %s", line, v, t[2]))
	score = score + v + t[2]
end

print(score)
