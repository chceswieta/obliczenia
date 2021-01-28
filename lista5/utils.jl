# Patryk Majewski, 250134
include("blocksys.jl")

module MatrixUtils
export read_matrix, read_matrix_as_sparse, read_vector, write_x
using SparseArrays
using LinearAlgebra
using Main.BlockMatrices

function read_matrix(filename::String)
    open(filename) do f
        params = split(readline(f))
        size = parse(Int, params[1])
        block_size = parse(Int, params[2])
        A = get_blockmatrix(size, block_size)
        while !eof(f)
            line = split(readline(f))
            i = parse(Int, line[1])
            j = parse(Int, line[2])
            v = parse(Float64, line[3])
            A[i, j] = v
        end
        return A
    end
end

function read_matrix_as_sparse(filename::String)
    open(filename) do f
        params = split(readline(f))
        size = parse(Int, params[1])
        block_size = parse(Int, params[2])
        A = spzeros(size, size)
        while !eof(f)
            line = split(readline(f))
            i = parse(Int, line[1])
            j = parse(Int, line[2])
            A[i,j] = parse(Float64, line[3])
        end
        return A
    end
end

function read_vector(filename::String)
    open(filename) do f
        n = parse(Int, readline(f))
        b = zeros(n)
        for i in 1:n
            b[i] = parse(Float64, readline(f))
        end
        return b
    end
end

function write_x(filename::String, X::Vector{Float64}, target_x::Union{Nothing, Vector{Float64}})
    open(filename, "w") do f
        if target_x !== nothing
            error = norm(X-target_x) / norm(target_x)
            write(f, "$error\n")
        end
        for x in X
            write(f, "$x\n")
        end
    end
end

end