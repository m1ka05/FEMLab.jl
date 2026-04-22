using FEMLab

# define a tridiagonal matrix of size n × n
# [ 2 -1  0  0  
#  -1  2 -1  0  
#   0 -1  2 -1
#   0  0 -1  2 ]
n = 100
A = spdiagm(0 => fill(2.0, n), 1 => fill(-1.0, n-1), -1 => fill(-1.0, n-1))

# show condition number
@info "cond(A) = $(cond(A))"

# random rhs vector of length n
y = rand(n)

# direct solve
x = A \ y
r = A * x - y
@info "norm(r) = $(norm(r))"

# iterative solve using cg (conjugate gradient)
x, log = cg(A, y; itmax=30)
r = A * x - y
@info "solved = $(log.solved), niter = $(log.niter), norm(r) = $(norm(r))"

# iterative solve using pcg (preconditioned conjugate gradient)
P = ilu0(A)
x, log = cg(A, y; M=P, ldiv=true)
r = A * x - y
@info "solved = $(log.solved), niter = $(log.niter), norm(r) = $(norm(r))"

# form L and U factors from ILU(0) preconditioner
L, U = form_factors(P)

# in this specific case LU == A!
norm(L*U - A)