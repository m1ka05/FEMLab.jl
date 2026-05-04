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

# assemble augmented stiffness matrix
K_a = [ K   A';
        A   zeros(N,N) ]

# assemble augmented forces vector
f_a = [f; b]

# solve for displacement and Lagrange multipliers
x = K_a \ f_a

# collect displacements from x
u = x[1:ndofs]

# collect Lagrange multipliers from x
lambda = x[(ndofs+1):end]

# compare reference solution to master-slave elimination
@info "
      u = $u,
  u_ref = $u_ref, 
  ‖u - u_ref‖ = $(norm(u - u_ref))
"