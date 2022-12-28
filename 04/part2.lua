---
---Returns binary string representation of `x`.
---
---@param x number
---@return string
local function toBits(x)
	local bits = math.max(1, math.frexp(x))
	local t = {}
	for b = bits, 1, -1 do
		t[b] = math.fmod(x, 2)
		x = math.floor((x - t[b]) / 2)
	end
	return table.concat(t)
end

local function bitOnesRange(range)
	if range < 1 then
		return 0
	end
	local br = 1 << range - 1
	return br | ~-br
end

local blockSize = 62

---
---Returns a table of binary masks representing a range <l, r>.
---Each mask can be at most 63 bits long.
---
---@param l number Left side of the tange.
---@param r number Right side of the range.
---@return table
local function bitMask(l, r)
	-- If block size is 4 we'd do the following:
	-- We expect the mask to be 11|1111|1100|0000 ('|' spearates the blocks).
	-- Each element in mask table is a single block.
	-- Blocks are read from 1 .. x, right to left,
	-- first block at index 1 will be '0000'.
	local mask = {}
	-- How many ones do we need --> our RANGE
	-- Since 'r' is inclusive we need to add 1.
	-- l = 7, r = 13
	-- ones = 13 - 7 + 1 = 7
	local ones = r - l + 1
	-- How many zeros do we need --> our OFFSET
	-- Since 'l' is inclusive we need to subtract 1.
	-- l = 7
	-- zeros = 7 - 1 = 6
	local zeros = l - 1

	-- How many blocks of zeroes we need to offset?
	-- zeros = 6, blockSize = 4
	-- zerosBlocks = 6 / 4 = 1
	local zerosBlocks = math.floor(zeros / blockSize)
	-- How many zeroes will be part of the mixed ones-zeros block?
	-- zerosRemainder = 6 % 4 = 2
	local zerosRemainder = zeros % blockSize
	-- Create all the necessary blocks of zeros to OFFSET the RANGE.
	for i = 1, zerosBlocks do
		-- Insert zero which is the equivalent of
		-- having a full binary block of zeros.
		-- mask[1] = 0000
		table.insert(mask, 0)
	end
	-- Insert the (potentially) mixed ones + zeros block.
	-- Subtract from the total number ones the number of
	-- ones used to fill the block.
	if zerosRemainder > 0 then
		-- onesToFill = 4 - 2 = 2
		local onesToFill = blockSize - zerosRemainder
		-- ones = 7, onesToFill = 2
		-- ones = 7 - 2 = 5
		if ones > onesToFill then
			ones = ones - onesToFill
		else
			onesToFill = ones
			ones = 0
		end
		-- mask[2] = 1100
		table.insert(mask, bitOnesRange(onesToFill) << zerosRemainder)
	end

	-- If we already alocated the ones in the previous
	-- step we can return.
	if ones == 0 then
		return mask
	end

	-- How many blocks of ones we need to create?
	-- ones = 5, blockSize = 4
	-- onesBlocks = 5 / 4 = 1
	local onesBlocks = math.floor(ones / blockSize)
	-- How many ones do we have remaining --> not full block?
	-- onesRemainder = 5 % 4 = 1
	local onesRemainder = ones % blockSize
	-- Create all the necessary full blocks of zeros.
	for i = 1, onesBlocks do
		-- Insert full block of ones.
		-- mask[3] = 1111
		table.insert(mask, bitOnesRange(blockSize))
	end
	-- Finally insert the remaining ones.
	if onesRemainder > 0 then
		-- Insert the remaining one.
		-- mask[4] = 0001
		table.insert(mask, bitOnesRange(onesRemainder))
	end

	-- Return the mask.
	-- mask = { '0001', '1111', '1100', '0000' }
	return mask
end

local sum = 0
for line in io.lines("input.txt") do
	local s = {}
	for num in line:gmatch("%d+") do
		table.insert(s, tonumber(num))
	end
	-- 2-4,6-8
	local fm = bitMask(s[1], s[2]) -- First mask.
	local sm = bitMask(s[3], s[4]) -- Second mask.
	-- We're choosing the lowset index, since the mask starts
	-- with the first block, i.e. the right-most we can just
	-- iterate over the smallest table.
	-- If no bits overlapped we'll get 0, otherwise it's a match!
	for i = 1, math.min(#fm, #sm) do
		if fm[i] & sm[i] > 0 then
			sum = sum + 1
			break
		end
	end
end

print(sum)
