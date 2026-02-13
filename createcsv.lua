local fname = "data"
local dp = 200
local function createf()
    local file = io.open(fname..".csv", "w")
    for i = 1,dp do
        for k = 1,2 do
            local rand = math.random()
            file:write(string.format("%f, ",rand*1000))
        end
        file:write("\n")
    end
end

createf()
