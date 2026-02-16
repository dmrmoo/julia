local file = io.open("data.csv", "w")


local coefficients = arg  
local numCoeffs = #coefficients
local maxX = 100  -- generate data from x=0 to maxX

for x = 0, maxX do
    local result = 0
    for i = 1, numCoeffs do
        local power = numCoeffs - i  -- Highest power first
        result = result + coefficients[i] * (x ^ power)
    end
    file:write(string.format("%d, %f\n", x, result))
end