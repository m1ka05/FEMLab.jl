using FEMLab

# defining a column vector
v = [1; 2; 3]
w = [1
     2
     3]

# defining a row vector (1×3 Matrix)
u = [1 2 3]

# vector norm
@info "Norm of vector is norm(v) = $(norm(v))"

# defining a matrix
A = [ 1 2 3
      4 5 6
      7 8 9 ]
B = [ 1 2 3; 4 5 6; 7 8 9 ]

# matrix norm
norm(A - B) == 0

# matrix determinant
det(A)

# matrix transpose
At = transpose(A)

# matrix indexing
A[1] == A[1,1]
A[2] == A[2,1]
A[3] == A[3,1]
A[4] == A[1,2]
A[5] == A[2,2]
A[6] == A[3,2]
A[7] == A[1,3]
A[8] == A[2,3]
A[9] == A[3,3]

# Cartesian vs linear indices
cinds = CartesianIndices(A)
linds = LinearIndices(A)
for k in linds
    @info "Linear index $k is equivalent to Cartesian index $(cinds[k])"
end

# elementwise operations on vectors/matrices
y = sin.(v) .+ 1
Y = sin.(A) .+ 1
@. y = sin(v) + 1
@. Y = sin.(A) + 1
# y = sin(v) + 1 (wrong!)
# Y = sin(A) + 1 (wrong!)