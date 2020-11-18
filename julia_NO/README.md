# ABM Course Topic 3 - Model

To run a simulation with default parameters:
```
julia run.jl
```

To get a list of parameters:
```
julia run.jl --help
```

To run with changed parameters, e.g. fixed seed:
```
julia run.jl -r 42
```

The simulation will write results to `results/output.csv`.

In `plots.ipynb` the simulation is run in a notebook, and a plot is created.