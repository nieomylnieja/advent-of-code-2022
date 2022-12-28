local sequenceSize = 4
local ctr = 0
local buff = {}
for i = 1, sequenceSize do
	buff[#buff + 1] = ""
end

local bi = sequenceSize
local file = io.open("input.txt", "r")
repeat
	ctr = ctr + 1
	local c = file:read(1)
	print(string.format("%s: %d", c, ctr))
	buff[bi] = c
	bi = bi % sequenceSize + 1
	local markerDetected = ctr >= sequenceSize
	-- 1: 2, 3, 4
	-- 2: 3, 4
	-- 3: 4
	for i = 1, sequenceSize - 1 do
		for j = i + 1, sequenceSize do
			if buff[i] == buff[j] then
				markerDetected = false
				break
			end
		end
	end
	if markerDetected then
		print("break! ", c)
		break
	end
until c == nil

print(ctr)
