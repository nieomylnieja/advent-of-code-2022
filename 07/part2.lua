local tree = {}
local pwd = {}
local leaf = {}

local function cd(t, i)
	if i == #pwd then
		return t
	end
	i = i + 1
	return cd(t[pwd[i]], i)
end

local function processCmd(line)
	local cmd, arg = line:gmatch("$%s([lc][sd])%s?([./%a]*)")()
	if cmd == "ls" then
		-- Recurse to the 'leaf' through a path specified in 'pwd'.
		leaf = cd(tree, 0)
		return
	end
	if arg == "/" then
		pwd = {}
		return
	end
	-- Pop the last element.
	if arg == ".." and #pwd > 0 then
		table.remove(pwd, #pwd)
		return
	end
	-- Else the arg must be the dir we want to enter.
	if cmd == "cd" then
		pwd[#pwd + 1] = arg
	end
end

local function processLsDirOutput(line)
	local dir = line:gmatch("dir%s(%a+)")()
	if dir == "e" then
		print(#leaf)
	end
	leaf[dir] = {}
end

local function processLsFileOutput(line)
	local size, fn = line:gmatch("(%d+)%s(.+)")()
	leaf[fn] = tonumber(size)
end

for line in io.lines("input.txt") do
	local s = line:sub(1, 1)
	if s == "$" then
		processCmd(line)
	elseif s == "d" then
		processLsDirOutput(line)
	else
		processLsFileOutput(line)
	end
end

local function printTree(k, v, indent)
	local typ = type(v)
	if typ == "table" then
		print(string.format("%s- %s (dir)", string.rep(" ", indent), k))
		for k, v in pairs(v) do
			printTree(k, v, indent + 2)
		end
	end
	if typ == "number" then
		print(string.format("%s- %s (file, size=%d)", string.rep(" ", indent), k, v))
	end
end

printTree("/", tree, 0)

local fsDiskSpace = 70000000
local unusedSpace = 30000000

local function sumDirectories(v)
	local typ = type(v)
	if typ == "table" then
		local sum = 0
		for _, v in pairs(v) do
			sum = sum + sumDirectories(v)
		end
		return sum
	end
	if typ == "number" then
		return v
	end
end

local totalSize = sumDirectories(tree)
local freeSpace = unusedSpace - (fsDiskSpace - totalSize)
print(
	string.format(
		"Available: %d, needed: %d, total size: %d, free at least: %d",
		fsDiskSpace,
		unusedSpace,
		totalSize,
		freeSpace
	)
)

-- Set it to anything big enough.
local sd = totalSize

local function findSmallestDirToFree(v)
	local typ = type(v)
	if typ == "table" then
		local sum = 0
		for _, v in pairs(v) do
			sum = sum + findSmallestDirToFree(v)
		end
		if sum > freeSpace and sum < sd then
			sd = sum
		end
		return sum
	end
	if typ == "number" then
		return v
	end
end

findSmallestDirToFree(tree)

print(string.format("Smallest size to free: %d", sd))
