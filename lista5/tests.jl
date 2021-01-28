# Patryk Majewski, 250134

include("utils.jl")
include("matrixgen.jl")
using .matrixgen
using .blocksys
using .MatrixUtils
using Test

blockmat(1000, 10, 10., "testA.txt")
A = read_matrix("testA.txt")
x = ones(Float64, A.size)
b = generate_rhs(A)

@testset "$(rpad("Eliminacja Gaussa", 50))" begin
    @test isapprox(gauss_elimination(deepcopy(A), deepcopy(b)), x)
end

@testset "$(rpad("LU", 50))" begin
    @test isapprox(solve_by_lu!(deepcopy(A), deepcopy(b)), x)
end

@testset "$(rpad("Eliminacja Gaussa z częściowym wyborem", 50))" begin
    @test isapprox(gaussian_elimination_with_pivoting(deepcopy(A), deepcopy(b)), x)
end

@testset "$(rpad("LU z częściowym wyborem", 50))" begin
    @test isapprox(solve_by_pivoted_lu!(deepcopy(A), deepcopy(b)), x)
end
