local sum = 0
for line in io.lines("input.txt") do
	local s = {}
	for num in line:gmatch("%d+") do
		table.insert(s, tonumber(num))
	end
	local firstIncludesSecond = s[1] >= s[3] and s[2] <= s[4]
	local secondIncludesFirst = s[3] >= s[1] and s[4] <= s[2]
	if firstIncludesSecond or secondIncludesFirst then
		sum = sum + 1
	end
end

print(sum)
