export gauss_duffy_triangle_rule

"""
    gauss_duffy_triangle_rule(nq::Int)

Return an `nq²`-point quadrature rule on the reference triangle with vertices
`(0,0)`, `(1,0)`, `(0,1)` via the **Duffy (collapsed-coordinate) transform**.

# Arguments
- `nq::Int`: number of quadrature points per parametric direction.
  The returned rule contains `nq²` points in total.

# Returns
- `points`: barycentric quadrature point coordinates
- `weights`: quadrature weights

# Reference
Duffy, M. G. (1982). Quadrature over a pyramid or cube of integrands with a
singularity at a vertex. *SIAM J. Numer. Anal.*, 19(6), 1260–1262.
"""
function gauss_duffy_triangle_rule(nq::Int)
    # 1d Gauss–Legendre nodes and weights on [-1, 1]
    xg, wg = gausslegendre(nq)

    # affine rescaling to [0, 1]: x̂ = (x + 1)/2, ŵ = w/2
    pts = 0.5 .* (xg .+ 1.0)
    wts = 0.5 .* wg

    # allocate output arrays
    npts    = nq^2
    points  = Vector{Vector{Float64}}(undef, npts)
    weights = Vector{Float64}(undef, npts)

    k = 0
    for (b, wb) in zip(pts, wts)
        for (a, wa) in zip(pts, wts)
            # Duffy collapsed coordinates on the reference triangle
            ξ = a
            η = (1.0 - a) * b

            # Jacobian for (a,b) → (ξ,η)
            J_collapse = 1.0 - a

            # linear shape functions (barycentric coordinates)
            N = [1.0 - ξ - η, ξ, η]

            # quadrature points and weight computation
            k += 1
            points[k]  = N
            weights[k] = wa * wb * J_collapse
        end
    end

    return points, weights
end