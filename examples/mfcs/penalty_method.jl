using FEMLab

# define stiffness matrix from study example
# K = [ K11 K12 0   0   0   0   0  
#       K12 K22 K23 0   0   0   0  
#       0   K23 K33 K34 0   0   0  
#       0   0   K34 K44 K45 0   0  
#       0   0   0   K45 K55 K56 0  
#       0   0   0   0   K56 K66 K67
#       0   0   0   0   0   K67 K77 ]
ndofs = 7
K₁₁ = 100.0
K₁₂ = -100.0
K₂₂ = 200.0
K = spdiagm(
     0 => vcat(K₁₁, fill(K₂₂, ndofs-2), K₁₁),
     1 => fill(K₁₂, ndofs-1),
    -1 => fill(K₁₂, ndofs-1))

# define load vector
f = zeros(ndofs)
f[end] = 50

## general case
# MFCs:
#   u₂ - u₆ = 0
#   u₁ + 4u₄ = 0.1
#   2u₃ + u₄ + u₅ = 0
# slaves: u₃, u₄, u₆
# master: u₁, u₂, u₅

## hand calculation approach
# define congruent transformation
Tref = [ 1    0   0    0 
         0    1   0    0
         1/8  0  -1/2  0
        -1/4  0   0    0
         0    0   1    0
         0    1   0    0
         0    0   0    1 ]

g = [ 0;  0;  -0.1/8;  0.1/4;  0;  0;  0 ]

# compute reference solution
u_hat_ref = (Tref' * K * Tref) \ (Tref' * (f - K*g))
u_ref = Tref * u_hat_ref + g


## Penalty augmentation (general case)
# MFCs:
#   u₂ - u₆ = 0
#   u₁ + 4u₄ = 0.1
#   2u₃ + u₄ + u₅ = 0

# MFCs coefficient matrix
A = [ 0  1  0  0  0 -1  0
      1  0  0  4  0  0  0
      0  0  2  1  1  0  0 ]

# MFCs rhs vector
b = [ 0; 0.1; 0 ]

# number of MFCs
N = length(b)

# maximum coefficient in K
max_Kij = maximum(K)

# working machine precision (digits)
p = precision(max_Kij; base=10) # typeof(max_Kij) == Float64!

# order of max_Kij
k = floor(Int, log10(max_Kij))

# diagonal matrix of penalty weights
penalty_factor = 10^(k + p/2)
W = penalty_factor * I(N)

# assemble penalty stiffness equations
K_p = A' * W * A
f_p = A' * W * b

# solve for u
u = (K + K_p) \ (f + f_p)

# compare reference solution to master-slave elimination
@info "
      u = $u,
  u_ref = $u_ref, 
  ‖u - u_ref‖ = $(norm(u - u_ref))
"