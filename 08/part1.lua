local m = {}
for line in io.lines("input.txt") do
	local y = {}
	for digit in line:gmatch("%d") do
		y[#y + 1] = digit
	end
	m[#m + 1] = y
end

local function isVisible(y, x)
	-- print(string.format("row: %d, col: %d", y, x))
	local n = m[y][x]
	-- North
	local visible = true
	for iy = y - 1, 1, -1 do
		-- print(string.format("N: %d >= %d", m[iy][x], n))
		if m[iy][x] >= n then
			visible = false
			break
		end
	end
	if visible then
		return true
	end
	-- South
	visible = true
	for iy = y + 1, #m do
		-- print(string.format("S: %d >= %d", m[iy][x], n))
		if m[iy][x] >= n then
			visible = false
			break
		end
	end
	if visible then
		return true
	end
	-- West
	visible = true
	for ix = x - 1, 1, -1 do
		-- print(string.format("W: %d >= %d", m[y][ix], n))
		if m[y][ix] >= n then
			visible = false
			break
		end
	end
	if visible then
		return true
	end
	-- East
	visible = true
	for ix = x + 1, #m[y] do
		-- print(string.format("E: %d >= %d", m[y][ix], n))
		if m[y][ix] >= n then
			visible = false
			break
		end
	end
	if visible then
		return true
	end
	return false
end

local visible = 2 * #m + 2 * #m[1] - 4
for y = 2, #m - 1 do
	for x = 2, #m[y] - 1 do
		if isVisible(y, x) then
			visible = visible + 1
		end
	end
end

print(string.format("Visible: %d", visible))
