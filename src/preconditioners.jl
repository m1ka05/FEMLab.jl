export form_factors

"""
    form_factors(P::ILU0Precon)

Form the explicit sparse factors `L` and `U` from an `ILUZero.ILU0Precon`.

`ILUZero.jl` stores the incomplete LU(0) factorization in its internal CSC data
structures, but does not provide a public function to reconstruct the corresponding
sparse matrices. This helper builds those matrices explicitly and returns them as
`SparseMatrixCSC` objects.

The returned factors satisfy the structural convention used by `ILUZero.jl`:

- `L` is unit lower triangular, with the diagonal stored implicitly in `P`.
  This function restores the diagonal by adding `I`.
- `U` is upper triangular, including its diagonal entries.

Note that this is an *incomplete* factorization, so in general `L * U != A` exactly;
rather, `L * U` represents the ILU(0) approximation associated with the original matrix.

# Arguments
- `P::ILU0Precon`: ILU(0) preconditioner/factorization produced by `ILUZero.jl`.

# Returns
- `L::SparseMatrixCSC`: explicit unit lower-triangular factor.
- `U::SparseMatrixCSC`: explicit upper-triangular factor.

# Example
```julia
P = ilu0(A)
L, U = form_factors(P)
```
"""
function form_factors(P::ILU0Precon)
    L = SparseMatrixCSC(P.n, P.n, copy(P.l_colptr), copy(P.l_rowval), copy(P.l_nzval))
    U = SparseMatrixCSC(P.n, P.n, copy(P.u_colptr), copy(P.u_rowval), copy(P.u_nzval))
    L = L + LinearAlgebra.I # L in ILUZero has implicit 1s on the diagonal
    return L, U
end