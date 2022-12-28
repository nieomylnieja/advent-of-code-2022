local ctr, highestCalorie = 0, 0
for line in io.lines("input.txt") do
  if line ~= "" then
    ctr = ctr + line
  else
    if ctr > highestCalorie then
      highestCalorie = ctr
    end
    ctr = 0
  end
end

print(highestCalorie)

