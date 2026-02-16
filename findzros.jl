using UnicodePlots


global b = false
global n = false

for x in ARGS
    if occursin("--b", x)
        global b = true
    end
    if occursin("--n", x)
        global n = true
    end
end

function bisection()

end

function newton()

end