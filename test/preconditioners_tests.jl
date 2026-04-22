@testitem "Formation of LU factors from ILUZero.jl" begin
    n = 100
    A = spdiagm(0 => fill(2.0, n), 1 => fill(-1.0, n-1), -1 => fill(-1.0, n-1))
    P = ilu0(A)
    L, U = form_factors(P)

    y = rand(n)
    x = zeros(n)
    ldiv!(x, P, y)

    T = eltype(x)
    @test x ≈ U \ (L \ y) atol=eps(T) * 1e2
end