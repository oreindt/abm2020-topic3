include("model_MH.jl")

# set up a mixed population
# p_contact is the probability that two agents are connected
function setup_mixed(n, p_contact)
    pop = [ SimplePerson(rand(), false) for i=1:n ]

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
    for i in 1:n_inf
        # one percent of agents are infected
        sim.pop[i].know = true
        sim.pop[i].belief = b
    end
    
    sim
end

function run_sim(sim, n_steps, verbose = false)
    # we keep track of the numbers
    knowing = Int[]
    avg_belief = Float64[]
    
    n = length(sim.pop)
    disperse = zeros(n)
    disper = zeros(n)
    disp = zeros(n_steps)

    # simulation steps
    for t in  1:n_steps
        update_agents!(sim)
        
        push!(knowing, count(p -> p.know == true, sim.pop))
        
        avg = 0
        for i in 1:n
            if sim.pop[i].know
                avg = avg + sim.pop[i].belief
            end
        
		#Added code here 
		for j in 1:n
			disperse[j] = sqrt( (sim.pop[i].belief-sim.pop[j].belief)^2 );
		end
                disper[i] = maximum(disperse)

        end
        n_know = count(p -> p.know == true, sim.pop)
        push!(avg_belief, avg /n_know)

        disp[t] = maximum(disper)
        
        # a bit of output
        #if verbose
        #    println(t, ", ", n_inf[end], ", ", n_susc[end])
        #end          

        end

    # return the results (normalized by pop size)
    knowing./n, avg_belief, disp
end