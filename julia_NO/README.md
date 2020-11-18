# ABM Course Topic 3 - Model

The code is not working but I added a logic of information exchange with the following Julia codes in model_info.jl.

I need to get some extra help 

```
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
```
I also added the possible dimension of the Information as the following mutable struct

```
# all possible dimensions of a piece of information
@enum Dimensions economy welfare

# this is a information type
# What dimension the person is looking at the information
mutable struct Information
    # model parameters:
    # TODO: how about changing the probability of this?
    dim :: Dimensions
end

```
And I added `info :: Vector(Information)` in agent type
```
# this is our agent type
mutable struct SimplePerson
    # state
    belief :: Float64
    know :: Bool
    # other agents this one can infect or be infected by
    contacts :: Vector{SimplePerson}
    # What dimension the person is looking at the information
    info :: Vector(Information)
end
```
In setup.jl, I added the line
```
include("model_info.jl")
```
And in `function  setup_sim`

```
for i in 1:n_inf
        # one percent of agents are infected
        sim.pop[i].know = true
        sim.pop[i].belief = b
        sim.pop[i].info = economy
    end
```
