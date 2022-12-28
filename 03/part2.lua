local sum, halfIdx = 0, 0
local lc, rc = "", "" -- Left and right comparments.
local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" -- 97 65

local sumForGroup = function(group)
	local byteValue = 0
	for c in group[1]:gmatch(".") do
		for i = 2, #group do
			if group[i]:find(c) then
				byteValue = string.byte(c)
			else
				-- Reset the byteValue if we don't get any hits.
				byteValue = 0
				break
			end
		end
		-- If we got all hits this won't be 0 and we can quit looping.
		if byteValue ~= 0 then
			break
		end
	end
	if byteValue >= 65 and byteValue <= 90 then
		sum = sum + byteValue - 38
	elseif byteValue >= 97 and byteValue <= 122 then
		sum = sum + byteValue - 96
	end
end

local group = {}
for line in io.lines("input.txt") do
	table.insert(group, line)
	if #group == 3 then
		sumForGroup(group)
		group = {}
	end
end

print(sum)
