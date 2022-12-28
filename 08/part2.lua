local m = {}
for line in io.lines("input.txt") do
	local y = {}
	for digit in line:gmatch("%d") do
		y[#y + 1] = digit
	end
	m[#m + 1] = y
end

local function calculateScenicScore(y, x)
	local n = m[y][x]
	-- North
	local score, ctr = 0, 0
	for iy = y - 1, 1, -1 do
		ctr = ctr + 1
		if m[iy][x] >= n then
			break
		end
	end
	score = ctr
	ctr = 0
	-- South
	for iy = y + 1, #m do
		ctr = ctr + 1
		if m[iy][x] >= n then
			break
		end
	end
	score = score * ctr
	ctr = 0
	-- West
	for ix = x - 1, 1, -1 do
		ctr = ctr + 1
		if m[y][ix] >= n then
			break
		end
	end
	score = score * ctr
	ctr = 0
	-- East
	for ix = x + 1, #m[y] do
		ctr = ctr + 1
		if m[y][ix] >= n then
			break
		end
	end
	return score * ctr
end

local score = 0
for y = 2, #m - 1 do
	for x = 2, #m[y] - 1 do
		local s = calculateScenicScore(y, x)
		if s > score then
			score = s
		end
	end
end

print(string.format("Highest scenic score: %d", score))
