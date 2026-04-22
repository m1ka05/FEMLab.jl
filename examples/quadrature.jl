using FEMLab

## 1D

# polynomial function to be integrated on [-1,1] exactly
f(x) = π * x^4 - π/3 * x^3 + 10x - 2 # 

# generate quadrature rule (exactness p ≤ 2n-1, n: npts)
n = 3
x, w = gausslegendre(n)

# evaluate integral (option 1)
∫ = sum(w .* f.(x))

# evaluate integral (option 2)
∫ = 0.0
for k in eachindex(x)
    ∫ += w[k] * f(x[k])
end

# compute error
∫_ref = 2π/5 - 4
err = ∫ - ∫_ref



## 2D

# polynomial function to be integrated on [-1,1]² exactly
f(x) = π * x[1]^4 * x[2]^2 - 2*x[1] + x[2] - 1

# generate quadrature rule per direction
x₁, w₁ = gausslegendre(3) # need 3 points in x₁-direction → exact up to degree 5
x₂, w₂ = gausslegendre(2) # need 2 points in x₂-direction → exact up to degree 3

# evaluate integral
∫ = 0.0
for l in eachindex(x₂)
    for k in eachindex(x₁)
        # 2d quadrature point and weight
        p = [x₁[k]; x₂[l]]
        w = w₁[k] * w₂[l]

        # contribution from quadrature point
        ∫ += w * f(p)
    end
end

# compute exact integral
∫_ref = 4π/15 - 4
err = ∫ - ∫_ref
