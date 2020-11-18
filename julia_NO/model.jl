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
        other.know = true
        if sign(person.belief) == sign(other.belief) || mid_belief(other)
            other.belief = (person.belief + other.belief) / 2
        end
    end
end

function very_pos(person)
    person.belief > 1/3
end 

function very_neg(person)
    person.belief < -1/3
end 

function mid_belief(person)
    !very_pos(person) && !very_neg(person)
end 



function update_agents!(sim)
    # we need to change the order, otherwise agents at the beginning of the 
    # pop array will behave differently from those further in the back
    order = shuffle(sim.pop)
    
    for p in order
        update!(p, sim)
    end
end   


