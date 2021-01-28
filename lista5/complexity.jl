# Patryk Majewski, 250134

include("utils.jl")
include("matrixgen.jl")
using .matrixgen
using .blocksys
using .MatrixUtils
using Plots

sizes = [1000, 2500, 5000, 7500, 10000, 15000]
test_no = length(sizes)
block_size = 10

function metoda_walca_parowego(A, b)
    return Array(A.matrix)\b
end

struct Solution
    func::Function
    times::Vector{Float64}
    ops::Vector{Int}
    memory::Vector{Int}
end

solutions = [
    Solution(f, zeros(Float64, test_no), zeros(Int, test_no), zeros(Int, test_no)) 
    for f in [metoda_walca_parowego, gauss_elimination, gaussian_elimination_with_pivoting, solve_by_lu!, solve_by_pivoted_lu!]
            ]

# rozgrzewkowy run, w przeciwnym wypadku dzieją się jakieś cuda w pierwszych testach
blockmat(4, 2, 10., "test.txt")
A = read_matrix("test.txt")
b = generate_rhs(A)
for S in solutions
    tempA = deepcopy(A)
    tempb = deepcopy(b)
    stats = @timed S.func(tempA, tempb)
end

for (i, size) in enumerate(sizes)
    blockmat(size, block_size, 10., "test.txt")
    A = read_matrix("test.txt")
    b = generate_rhs(A)
    for S in solutions
        tempA = deepcopy(A)
        tempb = deepcopy(b)
        stats = @timed S.func(tempA, tempb)
        println("$size $(stats.time) $(tempA.operation_count) $(stats.bytes)")
      
        S.times[i] = stats.time
        S.ops[i] = tempA.operation_count
        S.memory[i] = stats.bytes
       
    end
end

plot(
    sizes, 
    [S.times for S in solutions], 
    title="Złożoność czasowa algorytmów (sekundy)", 
    legend=:topleft,
    label=["Metoda tradycyjna" "Gauss" "Gauss z wyborem" "LU" "LU z wyborem"]
    )
savefig("times.png")

plot(
    sizes, 
    [solutions[k].times for k in 2:length(solutions)], 
    title="Złożoność czasowa algorytmów (sekundy)", 
    legend=:topleft,
    label=["Gauss" "Gauss z wyborem" "LU" "LU z wyborem"]
    )
savefig("times2.png")

plot(
    sizes, 
    [solutions[k].ops for k in 2:length(solutions)], 
    title="Złożoność czasowa algorytmów (liczba operacji)", 
    legend=:topleft,
    label=["Gauss" "Gauss z wyborem" "LU" "LU z wyborem"]
    )
savefig("ops.png")

plot(
    sizes, 
    [S.memory for S in solutions], 
    title="Zużycie pamięci", 
    legend=:topleft,
    label=["Metoda tradycyjna" "Gauss" "Gauss z wyborem" "LU" "LU z wyborem"]
    )
savefig("mem.png")

plot(
    sizes, 
    [solutions[k].memory for k in 2:length(solutions)], 
    title="Zużycie pamięci", 
    legend=:topleft,
    label=["Gauss" "Gauss z wyborem" "LU" "LU z wyborem"])
savefig("mem2.png")