using JSON3
global fname = ""
global p = false

# stats from https://api.tracker.gg/api/v2/marvel-rivals/standard/profile/ign/{ign}
# copy pretty printed json into a file and pass it as an argument to this script

for x in ARGS
    if occursin(".json", x)
        global fname = x
    end
    if occursin("--p", x)
        global p = true
    end
end


data = JSON3.parsefile(fname)
peak_tiers = data["data"]["segments"][2]["stats"]["peakTiers"]["value"]

for peak in peak_tiers
    season = peak["metadata"]["seasonName"]
    tier = peak["metadata"]["tierName"]
    rating = peak["value"]
    println("$season: $tier ($rating)")
end


function get_season_peak(data, season_id)
    peak_tiers = data["data"]["segments"][2]["stats"]["peakTiers"]["value"]
    for peak in peak_tiers
        if peak["metadata"]["season"] == season_id
            return peak
        end
    end
    return nothing
end


println("Enter a season: ")
try
    season_input:: Int = parse(Int, readline())
    peak = get_season_peak(data, season_input)
    println("Peak: $(peak["metadata"]["tierName"]) - $(peak["value"]) RS")
catch e
    println("Invalid input or no data for that season.")
end
