using FEMLab

## Poisson equation on a quarter annulus geometry (κ = 1.0)
#
#    -∇⋅(κ∇u) = 0                    in Ω
#      u(r,θ) = -1                   on ∂Ω @ r = 1
#      u(r,θ) = cos(2θ) + 1          on ∂Ω @ r = 2
#      ∂u/∂n = 0                     on ∂Ω @ θ = 0 ∨ θ = π/2
#
# Reference solution in polar coordinates:
#
#      u(r,θ) = -1 + 2 log(r) / log(2) + (r² - r⁻²) / (2² - 2⁻²) cos(2θ)
#
function u_exact(x, y)
    r = sqrt(x^2 + y^2)
    θ = atan(y, x)
    -1 + 2 * log(r) / log(2) + (r^2 - r^(-2)) / (2.0^2 - 2.0^(-2)) * cos(2θ)
end

function generate_tri_mesh(x, y)
    # number of nodes in each direction
    nnodes = size(x)
    nelems = nnodes .- 1

    # array for node coordinates and element connectivity
    nodes = zeros(2, prod(nnodes))
    elements = zeros(Int, 3, 2*prod(nelems))

    # assign coordinates
    nodes[1, :] = x
    nodes[2, :] = y

    # linear node indices on structured grid
    ninds = LinearIndices(nnodes)

    # generate triangular elements
    # (walk quad by quad and split into two trias)
    eind = 1
    for l = 1:nelems[2]
        for k = 1:nelems[1]
            # first triangle
            elements[:, eind] = [
                ninds[k, l],
                ninds[k, l+1],
                ninds[k+1, l]
            ]
            eind += 1

            # second triangle
            elements[:, eind] = [
                ninds[k, l+1],
                ninds[k+1, l+1],
                ninds[k+1, l]
            ]
            eind += 1
        end
    end

    return nodes, elements
end


## preprocessing

# define geometric mapping
x(r,θ) = r * cos(θ)
y(r,θ) = r * sin(θ)

# define partition in parametric domain
δ = 10
r = LinRange(1, 2, 2^δ)
θ = LinRange(0, π/2, 2^δ)

# compute grid of points representing the quarter annulus
X = [x(rᵢ, θⱼ) for θⱼ in θ, rᵢ in r]
Y = [y(rᵢ, θⱼ) for θⱼ in θ, rᵢ in r]

# generate triangular mesh
nodes, elements = generate_tri_mesh(X, Y)

# compute mesh metrics
nnodes = size(nodes, 2)
nelems = size(elements, 2)
ndofs = nnodes

# collect boundary indices
R = [norm(p) for p in eachcol(nodes)] # distance from origin to each mesh node
inner_boundary_inds = findall(R .<= 1.0 + eps())
outer_boundary_inds = findall(R .>= 2.0 - eps())
boundary_dofs = unique([inner_boundary_inds; outer_boundary_inds])

# evaluate u at outer boundary as u(θ) = cos(2θ) + 1 
u_outer_boundary = cos.(2θ) .+ 1

# define constant forcing and material parameters
b = 0.0
κ = 1.0


# allocate and set EFT
EFT = zeros(Int, 3, nelems)
loc2glob(elements, element, node) = elements[node, element]
for k = 1:nelems
    EFT[1, k] = loc2glob(elements, k, 1)
    EFT[2, k] = loc2glob(elements, k, 2)
    EFT[3, k] = loc2glob(elements, k, 3)
end


## assembly

function element_force_vector(b, X, Y)
    A = det([1.0 1.0 1.0; X'; Y']) / 2
    fᵉ = A / 3 * [b; b; b]
end

function element_stiffness_matrix(X, Y)
    B = [ Y[2]-Y[3]  Y[3]-Y[1]  Y[1]-Y[2]
          X[3]-X[2]  X[1]-X[3]  X[2]-X[1] ]
    A = det([1.0 1.0 1.0; X'; Y']) / 2
    Kᵉ = 1 / (4 * A) * (B' * B)
end

# allocate arrays for sparse matrix assembly
I = zeros(Int, 9 * nelems)
J = zeros(Int, 9 * nelems)
V = zeros(9 * nelems)

# allocate global force vector
f = zeros(ndofs)

# contribution index
ind = 1

# iterate through all elements
@time for k = 1:nelems
    # collect element freedom table
    EFTᵉ = EFT[:, k]

    # collect element coordinates
    Xᵉ = nodes[1, EFTᵉ]
    Yᵉ = nodes[2, EFTᵉ]

    # compute local element stiffness matrix
    Kᵉ = element_stiffness_matrix(Xᵉ, Yᵉ)

    # collect element contributions
    for j = 1:3
        for i = 1:3
            V[ind] = κ * Kᵉ[i, j]
            I[ind] = EFTᵉ[i]
            J[ind] = EFTᵉ[j]

            # increment contribution index
            ind += 1
        end
    end

    # compute local element force vector
    fᵉ = element_force_vector(b, Xᵉ, Yᵉ)

    # assemble force vector
    f[EFTᵉ] += fᵉ
end

# define sparse stiffness matrix from (row, col, val) triplets
K = sparse(I, J, V)
K̄ = sparse(I, J, V)


## solution

# apply homogeneous boundary conditions by modification
num_boundary_dofs = length(boundary_dofs)
K[boundary_dofs, :] .= 0
K[:, boundary_dofs] .= 0
K[boundary_dofs, boundary_dofs] .= Diagonal(ones(num_boundary_dofs))
f[boundary_dofs] .= 0

# setup nonhomogeneous boundary conditions
uₚ = zeros(nnodes)
uₚ[inner_boundary_inds] .= -1.0
uₚ[outer_boundary_inds] = u_outer_boundary

f₀ = f - K̄ * uₚ
f₀[boundary_dofs] .= 0.0

# solve for homogeneous solution
u₀ = K \ f₀

# recover nonhomogeneous solution
u = u₀ + uₚ

## alternatively (Lecture 3, Slide 5)
#f̄ =  -K̄ * uₚ
#ff = f + f̄
#ff[boundary_dofs] .= uₚ[boundary_dofs]
#u = K \ ff

## Paraview output
points = vcat(nodes, zeros(1, nnodes)) # adds third row with zero z-coordinate
cells = [MeshCell(VTKCellTypes.VTK_TRIANGLE, elements[:, k]) for k = 1:nelems]
vtk_grid(joinpath("results", "quarter_annulus_poisson"), points, cells) do vtk
    vtk["solution", VTKPointData()] = u
    vtk["exact solution", VTKPointData()] = u_exact.(X,Y)
end


## L² error computation

# get quadrature rule on reference triangle
Qx, Qw = gauss_duffy_triangle_rule(5)

# loop over elements and compute error in l2 norm
l2error_sq = 0.0
for k = 1:nelems
    # collect element freedom table
    EFTᵉ = EFT[:, k]

    # collect element coordinates
    Xᵉ = nodes[1, EFTᵉ]
    Yᵉ = nodes[2, EFTᵉ]

    # collect solution dofs
    uᵉ = u[EFTᵉ]

    # physical triangle area
    A = det([1.0 1.0 1.0; Xᵉ'; Yᵉ']) / 2

    # quadrature loop
    for q in eachindex(Qw)
        # quadrature point and weight
        N = Qx[q]
        w = Qw[q]

        # physical point
        x = dot(N, Xᵉ)
        y = dot(N, Yᵉ)

        # error computation
        uₕ = dot(N, uᵉ)
        uref = u_exact(x, y)
        l2error_sq += 2A * w * (uₕ - uref)^2
    end
end
@info "L² error (N=$ndofs)" l2error = sqrt(l2error_sq)


# plot l2 errors
using Plots, LaTeXStrings
N = (2 .^ (1:10)) .^ 2
l2err = [
    0.8823939105039833,
    0.11468160064818678,
    0.021374285003360836,
    0.004666646224877333,
    0.0010931950722824814,
    0.0002647244446891423,
    6.514494612472998e-5,
    1.615887075392761e-5,
    4.02392945504997e-6,
    9.687316875041608e-7
]
plot(
    sqrt.(N),
    l2err,
    xscale = :log10,
    yscale = :log10,
    ylims=(10^-7, 10^0),
    marker = :circle,
    markercolor = :black,
    linewidth = 2,
    linecolor = :black,
    grid = true,
    minorgrid = true,
    minorticks = 10,
    gridcolor = :black,
    gridalpha = 0.45,
    minorgridcolor = :black,
    minorgridalpha = 0.25,
    xlabel = L"\sqrt{N}",
    ylabel = L"\|u - u_h\|_{L^2(\Omega)}",
    legend = false,
    size = (600, 400),
    dpi = 600,
)


