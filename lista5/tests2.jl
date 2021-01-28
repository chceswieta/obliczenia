# Patryk Majewski, 250134

include("utils.jl")
include("matrixgen.jl")
using .matrixgen
using .blocksys
using .MatrixUtils
using Test
using Random

blockmat(100, 50, 10., "testA.txt")
A = read_matrix("testA.txt")
b = rand(Float64, A.size)


@testset "$(rpad("Eliminacja Gaussa", 50))" begin
    @test isapprox(A * gauss_elimination(deepcopy(A), deepcopy(b)), b)
end

@testset "$(rpad("LU", 50))" begin
    @test isapprox(A * solve_by_lu!(deepcopy(A), deepcopy(b)), b)
end

@testset "$(rpad("Eliminacja Gaussa z częściowym wyborem", 50))" begin
    @test isapprox(A * gaussian_elimination_with_pivoting(deepcopy(A), deepcopy(b)), b)
end

@testset "$(rpad("LU z częściowym wyborem", 50))" begin
    @test isapprox(A * solve_by_pivoted_lu!(deepcopy(A), deepcopy(b)), b)
end
