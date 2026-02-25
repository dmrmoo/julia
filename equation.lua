
local fname = table.remove(arg, 1) -- removes the first argument (filename) from the list of arguments
local coefficients = arg
local numCoeffs = #coefficients
local maxX = 100  -- generate data from x=0 to maxX

local file = io.open(fname, "w")

for x = 0, maxX do
    local result = 0
    for i = 1, numCoeffs do
        local power = numCoeffs - i  -- Highest power first
        result = result + coefficients[i] * (x ^ power)
    end
    file:write(string.format("%d, %f\n", x, result))
end

file:close()

