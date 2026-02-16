using CSV
using DataFrames
using UnicodePlots


# filename to read from
global fname = ""
# p is a flag to determine whether to print the DataFrame and create a scatter plot
global p = false
# runs lua file to create random data
global r = false
# 0 is unsorted, 1 is ascending, 2 is descending
# 0.5 allows program to accept the following command line argument
global s = 0


# parse command line arguments
for x in ARGS
    if occursin(".csv", x)
        global fname = x
    elseif occursin("--p", x)
        global p = true
    elseif occursin("--r", x)
        global r = true
    elseif occursin("--s", x)
        global s = 0.5
    elseif s == 0.5
        if occursin("a", x)
            global s = 1
        elseif occursin("d", x)
            global s = 2
        end
    end
end

# runs lua file to create random data
if r == true
    run(`lua createcsv.lua`)
end


# read the csv file into a DataFrame
df = CSV.read(fname, DataFrame)

# sort the DataFrame based on the first column if the --s flag is set
if s == 1
    sort!(df, 1) # change to 2 to sort by the second column
elseif s == 2
    sort!(df, 1, rev=true)
end

# print the DataFrame and create a scatter plot if the --p flag is set
println("DataFrame:")
show(df)
if p
    pl = scatterplot(df[:, 1], df[:, 2], title="Scatter Plot", xlabel="X-axis", ylabel="Y-axis")
    show(pl)
end
