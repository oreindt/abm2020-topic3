using Random

# this is our agent type
mutable struct SimplePerson
    # state
    belief :: Float64
    know :: Bool
    # other agents this one can infect or be infected by
    contacts :: Vector{SimplePerson}
end

# how we construct a person object
SimplePerson(belief, know) = SimplePerson(belief, know, [])

# this is a parametric type
# we can specify which type AGENT is going to be replaced with
# when constructing our Simulation
mutable struct Simulation{AGENT}
    # model parameters:
    # probability to pass on the news each step
    p :: Float64

    # and this is our population of agents
    pop :: Vector{AGENT}
end

# update an agent
function update!(person, sim)
    if person.know && rand() < sim.p
        other = rand(person.contacts)
# Added code here
        if other.know && other.belief < 0.5*person.belief
		other.belief = other.belief
       else
            other.know = true
            other.belief = person.belief * 0.9 
        end

	if other.know && other.belief >= 0.5*person.belief
            other.belief = (person.belief + other.belief) * 0.5
        else
            other.know = true
            other.belief = person.belief * 0.9 
        end
        
    end
end

function update_agents!(sim)
    # we need to change the order, otherwise agents at the beginning of the 
    # pop array will behave differently from those further in the back
    order = shuffle(sim.pop)
    
    for p in order
        update!(p, sim)
    end
end  
