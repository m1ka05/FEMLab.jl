using FEMLab

# sparse matrix triplets
I = [1, 1, 2, 2, 3,  1,  2,  2,  3,  3]
J = [1, 1, 2, 2, 3,  2,  1,  3,  2,  2]
V = [1, 1, 1, 1, 2, -1, -1, -1,  3, -4]

A = [ 2 -1  0
     -1  2 -1
      0 -1  2 ];

# repeated values per (i,j)-pair will be summed in the sparse matrix!
B = sparse(I,J,V)

# conversion to dense format
C = Matrix(B)

# show matrices
@info "Dense matrix"
display(A)

@info "Sparse matrix constructed from triplets"
display(B)

@info "Dense matrix constructed from sparse matrix"
display(C)

# direct inversion requires conversion to dense format first
invB = inv(Matrix(B))
display(invB)
display(invB*B)

# linear algebra on sparse matrices
@info "det(B) = $(det(B))"
@info "inv(B) = $(inv(Matrix(B)))"
@info "det(B) = $(det(B))"