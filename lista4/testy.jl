# Patryk Majewski, 250134

include("interpolacja.jl")
using .Interpolacja
using Test

@testset "$(rpad("test z wielomianem", 25))" begin
    w = x -> 5*x^2 + 2*x - 12
    x = [1., 2., 3., 4., 5.]
    y = w.(x)
    c = ilorazyRoznicowe(x, y)
    val = z -> warNewton(x, c, z)
    @test c == [-5., 17., 5., 0., 0.]
    @test naturalna(x, c) == [-12., 2., 5., 0., 0.]
    @test val.(x) == y
end

@testset "$(rpad("zad 5 z listy 4 z ćwiczeń", 25))" begin
    x = [-1., 0., 1., 2.]
    y = [2., 1., 2., -7.]
    c = ilorazyRoznicowe(x, y)
    val = z -> warNewton(x, c, z)
    @test c == [2., -1., 1., -2.]
    @test naturalna(x, c) == [1., 2., 1., -2.]
    @test val.(x) == y
end

