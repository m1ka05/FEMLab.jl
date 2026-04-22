using FEMLab

# Plots.jl
# Docs: https://docs.juliaplots.org/stable/basics/

x = 0:0.01:2π
y1 = sin.(x)
y2 = cos.(x)
plot(x, y1)
plot!(x, y2)