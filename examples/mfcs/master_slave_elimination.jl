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

## system partitioning approach
# (not suitable for hand calculations)

# collect indices
u_inds = [7] # unconstraint dofs
m_inds = [1, 2, 5] # master dofs
s_inds = [3, 4, 6] # slave dofs
all_inds = vcat(u_inds, m_inds, s_inds) # all dofs sorted

# define transformation (A_m * u_m + A_s * u_s = g_A)
A_s = [ 0 0 -1
        0 4  0
        2 1  0 ]
A_m = [ 0  1  0
        1  0  0
        0  0  1 ]
g_A = [ 0; 0.1;  0 ]

# define equivalent transformation (u_s = T * u_m + g)
T = -inv(A_s) * A_m
g = inv(A_s) * g_A

# get matrix partitions (submatrices of K)
K_uu = K[u_inds, u_inds]
K_um = K[u_inds, m_inds]
K_us = K[u_inds, s_inds]
K_mm = K[m_inds, m_inds]
K_ms = K[m_inds, s_inds]
K_ss = K[s_inds, s_inds]

# get load partitions (subvectors of f)
f_u = f[u_inds]
f_m = f[m_inds]
f_s = f[s_inds]

# assemble partitioned system
K_hat = [ K_uu               K_um + K_us*T
          K_um' + T'*K_us'   K_mm + T'*K_ms' + K_ms*T + T'*K_ss*T ]
f_hat = [ f_u - K_us*g
          f_m + T'*f_s - K_ms*g - T' * K_ss * g ]

# solve partitioned system
u_hat = K_hat \ f_hat

# recover full solution and reorder
N_u = size(K_uu, 1) # number of unconstrained dofs
N_m = size(K_mm, 1) # number of master dofs

# get partitions from u_hat
u_u = u_hat[1:N_u]
u_m = u_hat[N_u+1:end]

# recover slave dofs
u_s = T * u_m + g
u_partitioned = [ u_u; u_m; u_s ]

# reorder dofs
u = zeros(ndofs)
u[all_inds] = u_partitioned

# compare reference solution to master-slave elimination
@info "
      u = $u,
  u_ref = $u_ref, 
  ‖u - u_ref‖ = $(norm(u - u_ref))
"