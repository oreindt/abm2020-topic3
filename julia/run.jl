include("setup.jl")

# parse command line parameters
using ArgParse
s = ArgParseSettings()
@add_arg_table s begin
    "-p"
        help = "probability to pass on the news"
        arg_type = Float64
        default = 0.1
    "-n"
        help = "population size"
        arg_type = Int
        default = 1000
    "-c"
        help = "connection probability"
        arg_type = Float64
        default = 1.0
    "-k"
        help = "number of agents who know initially"
        arg_type = Int
        default = 10
    "-b"
        help = "initial belief"
        arg_type = Float64
        default = 1.0
    "-r"
        help = "random seed"
        arg_type = Int
        default = round(Int, time())
    "-s"
        help = "stop time"
        arg_type = Int
        default = 500
end

args = parse_args(s)

# setup and run
sim = setup_sim(p=args["p"], N=args["n"], p_c=args["c"], n_inf=args["k"], b=args["b"], seed=args["r"])
knowing, avg_belief = run_sim(sim, args["s"])

# write the observation to csv files
using DelimitedFiles
times = 1:args["s"]
data = [times knowing avg_belief]
header = ["time" "knowing" "avg_belief"]
mkpath("results")
writedlm("results/output.csv", [header; data], ',')