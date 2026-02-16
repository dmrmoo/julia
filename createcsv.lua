local fname = "data"
local dr = 200
local dc = 2



local function createf()
    local file = io.open(fname..".csv", "w")
    for i = 0,dr do
        for k = 1,dc do
            local rand = math.random()
            file:write(string.format("%f, ",rand*1000))
        end
        file:write("\n")
    end
end

createf()