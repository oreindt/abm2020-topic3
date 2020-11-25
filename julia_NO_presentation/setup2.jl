include("model_info2.jl")

# set up a mixed population
# p_contact is the probability that two agents are connected
function setup_mixed(n, p_contact)
    pop = [ SimplePerson(rand()*2-1, false) for i=1:n ]

    # go through all combinations of agents and 
    # check if they are connected
    for i in eachindex(pop)
        for j in i+1:length(pop)
            if rand() < p_contact
                push!(pop[i].contacts, pop[j])
                push!(pop[j].contacts, pop[i])
            end
        end
    end

    pop
end

# function parameters after ; have to be 
# named on call 

function  setup_sim(;p, N, p_c, n_inf, b, seed)
    # for reproducibility
    Random.seed!(seed)

    # create a population of agents, fully mixed
    pop = setup_mixed(N, p_c)

    # create a simulation object with parameter values
    sim = Simulation(p, pop)
    # initial condition for each agent
    for i in 1:n_inf
        # one percent of agents are infected
        sim.pop[i].know = true
        sim.pop[i].belief = b
        # sim.pop[i].info = Information(economy)
        # OR: info is a Vector, not a single Information (therefore the push)
        # OR: and info is of type Information, so you need to create an information object
        push!(sim.pop[i].info, Information(new)) 
    end
    
    sim
end

function run_sim(sim, n_steps, verbose = false)
    # we keep track of the numbers
    knowing = Int[]
    avg_belief = Float64[]
    pos = Int[]
    neg = Int[]
    mid = Int[]
    abs_avgs = Float64[]
    
    n = length(sim.pop)

    # simulation steps
    for t in  1:n_steps
        update_agents!(sim)
        
        push!(knowing, count(p -> p.know == true, sim.pop))
        
        avg = 0
        abs_avg = 0
        for i in 1:n
            if sim.pop[i].know
                avg = avg + sim.pop[i].belief
                abs_avg = abs_avg + abs(sim.pop[i].belief)
            end
        end
        n_know = count(p -> p.know == true, sim.pop)
        push!(avg_belief, avg /n_know)
        push!(abs_avgs, abs_avg /n_know)

        push!(pos, count(p -> p.know == true && very_pos(p), sim.pop))
        push!(neg, count(p -> p.know == true && very_neg(p), sim.pop))
        push!(mid, count(p -> p.know == true && mid_belief(p), sim.pop))
        
        # a bit of output
        #if verbose
        #    println(t, ", ", n_inf[end], ", ", n_susc[end])
        #end
    end
    
    # return the results (normalized by pop size)
    knowing./n, pos./n, neg./n, mid./n, avg_belief, abs_avgs

    #Dict("knowing" => knowing./n, "pos" => pos./n, "neg" => neg./n, "mid" => mid./n, "avg" => avg_belief, "abs_avg" => abs_avgs)
end