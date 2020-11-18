using Random

# OR: moved this to the fron
# all possible dimensions of a piece of information
@enum Dimensions economy welfare

# this is a information type
# What dimension the person is looking at the information
mutable struct Information
    # model parameters:
    # TODO: how about changing the probability of this?
    dim :: Dimensions
end

# this is our agent type
mutable struct SimplePerson
    # state
    belief :: Float64
    know :: Bool
    # other agents this one can infect or be infected by
    contacts :: Vector{SimplePerson}
    # What dimension the person is looking at the information
    info :: Vector{Information} # OR: braces instead of parens
end

# how we construct a person object
SimplePerson(belief, know) = SimplePerson(belief, know, [], []) # OR: the two parameter version is still used in the setup
SimplePerson(belief, know, info) = SimplePerson(belief, know, [], info) # OR: this had the last two parameters in the wrong order (must be the same as in the definition)

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
       # if sign(person.belief) == sign(other.belief) || mid_belief(other)
       #     other.belief = (person.belief + other.belief) / 2
       # end
       # If two people have the same sign & if they see things from the same angle
       # They will experience self-reinforcing
        if (sign(person.belief) == sign(other.belief) || mid_belief(other)) &  (person.info == other.belief)
            other.belief = (person.belief + other.belief) / 2
        end
       # If two people have the same sign & if they see things from a different angle
       # They will stick with their original belief
        if (sign(person.belief) == sign(other.belief) || mid_belief(other)) &  (person.info != other.belief)
            other.belief = other.belief
        end  
       # If two people have opposite sign & if they see things from the same angle
       # They will have an exchange in view and closer to mid-belief (at a faster rate)
        if (sign(person.belief) != sign(other.belief) || mid_belief(other)) &  (person.info == other.belief)
            other.belief = (other.belief)/2
        end  
       # If two people have opposite sign & if they see things from a different angle
       # They will have an exchange in view and closer to mid-belief (at a slower rate)
        if (sign(person.belief) != sign(other.belief) || mid_belief(other)) &  (person.info != other.belief)
            other.belief = (other.belief)/4
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


