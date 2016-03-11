using Base.Test
using ToeplitzMatrices

ns = 10
nl = 2000

xs = randn(ns, 5)
xl = randn(nl, 5)

@printf("General Toeplitz: ")
As = Toeplitz(0.9.^(0:ns-1), 0.4.^(0:ns-1))
Al = Toeplitz(0.9.^(0:nl-1), 0.4.^(0:nl-1))
@test_approx_eq As * xs full(As) * xs
@test_approx_eq Al * xl full(Al) * xl
@test_approx_eq A_ldiv_B!(As, copy(xs)) full(As) \ xs
@test_approx_eq A_ldiv_B!(Al, copy(xl)) full(Al) \ xl
@printf("OK!\n")

@printf("Symmetric Toeplitz: ")
As = SymmetricToeplitz(0.9.^(0:ns-1))
Ab = SymmetricToeplitz(abs(randn(ns)))
Al = SymmetricToeplitz(0.9.^(0:nl-1))
@test_approx_eq As * xs full(As) * xs
@test_approx_eq Ab * xs full(Ab) * xs
@test_approx_eq Al * xl full(Al) * xl
@test_approx_eq A_ldiv_B!(As, copy(xs)) full(As) \ xs
@test_approx_eq A_ldiv_B!(Ab, copy(xs)) full(Ab) \ xs
@test_approx_eq A_ldiv_B!(Al, copy(xl)) full(Al) \ xl
@test_approx_eq StatsBase.levinson(As, xs) full(As) \ xs
@test_approx_eq StatsBase.levinson(Ab, xs) full(Ab) \ xs
@test_approx_eq StatsBase.levinson(Al, xl) full(Al) \ xl
@printf("OK!\n")

@printf("Circulant: ")
As = Circulant(0.9.^(0:ns-1))
Al = Circulant(0.9.^(0:nl-1))
@test_approx_eq As * xs full(As) * xs
@test_approx_eq Al * xl full(Al) * xl
@test_approx_eq A_ldiv_B!(As, copy(xs)) full(As) \ xs
@test_approx_eq A_ldiv_B!(Al, copy(xl)) full(Al) \ xl
@printf("OK!\n")

@printf("Upper triangular Toeplitz: ")
As = TriangularToeplitz(0.9.^(0:ns - 1), :U)
Al = TriangularToeplitz(0.9.^(0:nl - 1), :U)
@test_approx_eq As * xs full(As) * xs
@test_approx_eq Al * xl full(Al) * xl
@test_approx_eq A_ldiv_B!(As, copy(xs)) full(As) \ xs
@test_approx_eq A_ldiv_B!(Al, copy(xl)) full(Al) \ xl
@printf("OK!\n")

@printf("Lower triangular Toeplitz: ")
As = TriangularToeplitz(0.9.^(0:ns - 1), :L)
Al = TriangularToeplitz(0.9.^(0:nl - 1), :L)
@test_approx_eq As * xs full(As) * xs
@test_approx_eq Al * xl full(Al) * xl
@test_approx_eq A_ldiv_B!(As, copy(xs)) full(As) \ xs
@test_approx_eq A_ldiv_B!(Al, copy(xl)) full(Al) \ xl
@printf("OK!\n")


@printf("Hankel: ")
H=Hankel([1.0,2,3,4,5],[5.0,6,7,8,0])
x=ones(5)
@test_approx_eq full(H)*x H*x
@printf("OK!\n")

@printf("BigFloat: ")
if isdir(Pkg.dir("ApproxFun"))
    using ApproxFun
    T=Toeplitz(BigFloat[1,2,3,4,5],BigFloat[1,6,7,8,0])
    @test_approx_eq T*ones(BigFloat,5) [22,24,19,16,15]
end
@printf("OK!\n")
