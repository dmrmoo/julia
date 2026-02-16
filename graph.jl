using CSV
using DataFrames
using UnicodePlots


# filename to read from
global fname = ARGS[1]


# read the csv file into a DataFrame
df = CSV.read(fname, DataFrame)

# print the DataFrame and create a scatter plot
println("DataFrame:")
show(df)
pl = scatterplot(df[:, 1], df[:, 2], title="Scatter Plot", xlabel="X-axis", ylabel="Y-axis")
show(pl)