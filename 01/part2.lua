local ctr = 0
local topThree = { 0, 0, 0 }
for line in io.lines("input.txt") do
	if line ~= "" then
		ctr = ctr + line
	else
		-- Lowest calorie index
		local lci = 0
		for i, calorie in ipairs(topThree) do
			if ctr > calorie then
				if lci == 0 then
					lci = i
				elseif topThree[lci] > calorie then
					lci = i
				end
			end
		end
		if lci > 0 then
			topThree[lci] = ctr
		end
		ctr = 0
	end
end

local sum = 0
for _, calorie in ipairs(topThree) do
	sum = sum + calorie
end

print(sum)
