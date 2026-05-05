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
K₁₁ = 100
K₁₂ = -100
K₂₂ = 200
K = spdiagm(
     0 => vcat(K₁₁, fill(K₂₂, ndofs-2), K₁₁),
     1 => fill(K₁₂, ndofs-1),
    -1 => fill(K₁₂, ndofs-1))


## MFC: u₂ - u₆ = 0
# define congruent transformation
T = [ 1  0  0  0  0  0 
      0  1  0  0  0  0 
      0  0  1  0  0  0 
      0  0  0  1  0  0 
      0  0  0  0  1  0 
      0  1  0  0  0  0
      0  0  0  0  0  1 ]

# apply constraints
K̃ = T' * K * T

# compute eigenvalue decompositions
evd = eigen(Matrix(K)) # compute both at the same time
Λ, U = evd.values, evd.vectors
Λ̃, Ũ = eigvals(K̃), eigvecs(K̃)

# K and K̃ are not invertible, the solution is not unique
@info "det(K) = $(det(K)), det(K̃) = $(det(K̃))"