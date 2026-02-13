using CSV
using DataFrames
using UnicodePlots


# runs lua file to create random data
run(`lua createcsv.lua`)

global fname = ""
global p = false

for x in ARGS
    if occursin(".csv", x)
        global fname = x
    end
    if occursin("--p", x)
        global p = true
    end
end




# read the csv file into a DataFrame
df = CSV.read(fname, DataFrame)

# print the DataFrame and create a scatter plot if the --p flag is set
if p
    println("DataFrame:")
    show(df)
    pl = scatterplot(df[:, 1], df[:, 2], title="Scatter Plot", xlabel="X-axis", ylabel="Y-axis")
    show(pl)
end