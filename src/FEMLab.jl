module FEMLab

using Reexport

## Julia
#   Julia is a high-level, high-performance programming language designed
#   for numerical and scientific computing that combines MATLAB/Python-like
#   ease of use with near-C speed through just-in-time compilation.
#
#   Docs: https://docs.julialang.org/en/v1/
#
#
## LinearAlgebra
#   Support for matrix decompositions and similar operations
#   Docs: https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/ 
#
## SparseArrays
#   Support for matrices in sparse format
#   Docs: https://docs.julialang.org/en/v1/stdlib/SparseArrays/
#
## WriteVTK
#   Support for exporting data for visualization in Paraview
#   Docs: https://juliavtk.github.io/WriteVTK.jl/stable/
#
## Krylov
#   Support for sparse linear solvers
#   Docs: https://juliavtk.github.io/WriteVTK.jl/stable/ 
#
## FastGaussQuadrature
#   Support for generation of 1d quadrature rules
#   Docs: https://juliaapproximation.github.io/FastGaussQuadrature.jl/stable/


# Reexport is used to export all functionality from above
# packages together with FEMLab. Students only need to write
#
#   using FEMLab
#
# in scripts to access everthing.
#
# Note: we only do this for student convenience, this is not recommended practice!

@reexport using LinearAlgebra
@reexport using SparseArrays
@reexport using WriteVTK
@reexport using Krylov, KrylovPreconditioners, ILUZero, LDLFactorizations, LimitedLDLFactorizations
@reexport using FastGaussQuadrature 
@reexport using ForwardDiff, StaticArrays
@reexport using Plots
@reexport using ReTestItems


include("preconditioners.jl")


end # module FEMLab