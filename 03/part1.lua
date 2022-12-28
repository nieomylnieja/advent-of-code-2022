local sum, halfIdx = 0, 0
local lc, rc = "", "" -- Left and right comparments.
local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" -- 97 65

for line in io.lines("input.txt") do
	halfIdx = #line / 2
	lc = line:sub(1, halfIdx)
	rc = line:sub(halfIdx + 1, #line)
	local byteValue = 0
	for c in lc:gmatch(".") do
		if rc:find(c) then
			byteValue = string.byte(c)
			break
		end
	end
	if byteValue >= 65 and byteValue <= 90 then
		sum = sum + byteValue - 38
	elseif byteValue >= 97 and byteValue <= 122 then
		sum = sum + byteValue - 96
	end
end

print(sum)
