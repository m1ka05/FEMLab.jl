using FEMLab

# Joukowski map
joukowski(ζ; a=1.0) = ζ + a^2 / ζ

# geometric mapping from reference coordinates p = [ρ, θ] to airfoil embedding
function F(p; a=1.0, c=-0.1 + 0.0im, θ₀=0.0)
    ρ, θ = p
    ζ = c + ρ * cis(θ + θ₀)  # circle centered at c, rotated so seam matches trailing edge
    w = joukowski(ζ; a=a)
    return [real(w), imag(w)]
end

# Jacobian of geometric mapping with respect to (ρ,θ)
∇F(p; kwargs...) = ForwardDiff.jacobian(q -> F(q; kwargs...), p)

# mesh parameters
a = 1.5
c = -0.2 + 0.5im
ρmax = 32.0 # farfield
ρcusp = abs(a - c)
δ = 0.05 # blunt trailing edge
ρmin = ρcusp + δ
θ₀ = angle(a - c)
β = 3.0
Δρ_out_target = 1.0
fac = β * exp(β) / (exp(β) - 1)
nr, nt = 2 .* (25, 50)

# sampling grid in parametric space
s = range(0.0, 1.0; length=nr)
ρ = ρmin .+ (ρmax - ρmin) .* (exp.(β .* s) .- 1) ./ (exp(β) - 1)
θ = range(0, 2π; length=nt)

# caches
X = zeros(nr, nt)
Y = zeros(nr, nt)
J = zeros(nr, nt)

# build mapped structured grid
for j in 1:nt
    for i in 1:nr
        # point in parametric space
        p = [ρ[i], θ[j]]

        # mapped point in physical space
        P = F(p; a=a, c=c, θ₀=θ₀)
        
        # update caches
        X[i, j] = P[1]
        Y[i, j] = P[2]

        # compute determinant of Jacobian
        J[i, j] = det(∇F(p; a=a, c=c, θ₀=θ₀))
    end
end

# structured mesh vtk output with point data
vtk_grid("results/joukowski_airfoil_mesh", X, Y) do vtk
    vtk["J"] = J
end