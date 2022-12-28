local legend = {}

-- Reuse it in all for loops so we don't
-- loose the cursor position.
local lines = io.lines("input.txt")
-- Read the whole legend first.
for line in lines do
	if string.find(line, "^ %d") then
		break
	end
	legend[#legend + 1] = line
end

-- index stores a triple of { letter, stack_index, crate_position }.
local index = {}
-- reverseIndex stores the index of the top most crate.
local reverseIndex = {}
-- Read the legend from bottom to top, so the first
-- crates are the ones on top.
for i = #legend, 1, -1 do
	local j = 0
	for c in string.gmatch(legend[i], ".") do
		j = j + 1
		if (j == 2 or (j - 2) % 4 == 0) and c ~= " " then
			local stackIndex = j == 2 and 1 or ((j - 2) / 4) + 1
			index[#index + 1] = { c, stackIndex, #legend - i + 1 }
			reverseIndex[stackIndex] = #index
		end
	end
end

local function printGraph()
	local t = {}
	for i = 1, #index do
		local char = index[i]
		if not t[char[3]] then
			t[char[3]] = {}
		end
		t[char[3]][char[2]] = char[1]
	end
	local get = function(i, j)
		return t[i] and t[i][j] and string.format("[%s] ", t[i][j]) or "    "
	end
	for i = #t, 1, -1 do
		local row = ""
		for j = 1, #reverseIndex do
			row = row .. get(i, j)
		end
		print(row)
	end
	local indexes = ""
	for i = 1, #reverseIndex do
		indexes = indexes .. string.format(" %d  ", i)
	end
	print(indexes)
end

---Move n crates from one stack to another.
---@param count integer
---@param from integer
---@param to integer
local function move(n, from, to)
	local tf = reverseIndex[from]
	-- If from stack was empty, return.
	if tf == 0 then
		return
	end
	-- from stack position.
	local fsp = index[tf][3]
	-- Limit the crates moved in case we try moving more then stack has.
	n = n > fsp and fsp or n
	-- Iterate from the highest offset.
	local t = reverseIndex[to]
	-- Top of 'to'.
	local tt = index[t] and index[t][3] or 0
	-- Current crate on top of from.
	local curCrateIdx = reverseIndex[from]
	for offset = n, 1, -1 do
		-- { letter, stack_index, crate_position }.
		index[curCrateIdx][2] = to
		index[curCrateIdx][3] = tt + offset
		-- If we removed the last element, set stack to 0.
		if fsp == 1 then
			reverseIndex[from] = 0
			break
		end
		-- Otherwise search for the previous item in stack and
		-- update the variables.
		for i = 1, #index do
			if index[i][2] == from and index[i][3] == fsp - 1 then
				reverseIndex[from] = i
				curCrateIdx = i
				fsp = fsp - 1
				break
			end
		end
	end
	-- Update the top crate for destination stack.
	reverseIndex[to] = tf
end

for instruction in lines do
	-- t = { crates_to_move, from, to }
	local t = {}
	for match in string.gmatch(instruction, "(%d+)") do
		t[#t + 1] = tonumber(match)
	end
	if #t > 0 then
		printGraph()
		move(t[1], t[2], t[3])
		print(instruction)
		print("---")
	end
end
printGraph()

local tops = ""
for i = 1, #reverseIndex do
	if reverseIndex[i] > 0 then
		tops = tops .. index[reverseIndex[i]][1]
	end
end
print("Top stack:")
print(tops)
