# Patryk Majewski, 250134
module BlockMatrices
export  BlockMatrix, get_blockmatrix,
        get_columns, get_last_column, get_first_column,
        get_rows, get_bottom_row, get_top_row
using SparseArrays

"""
Struktura reprezentująca macierz postaci zadanej na liście. 
"""
mutable struct BlockMatrix
    matrix::SparseMatrixCSC{Float64, Int}
    size::Int
    block_size::Int
    blocks_no::Int
    operation_count::Int
end


function Base.getindex(M::BlockMatrix, I::Int, J::Int)
    M.operation_count += 1
    return M.matrix[I, J]
end


function Base.setindex!(M::BlockMatrix, X::Float64, I::Int, J::Int)
    M.matrix[I, J] = X
end


function Base.:*(M::BlockMatrix, V::Vector{Float64})
    if length(V) != M.size
        error("Incompatible sizes of matrix and vector")
    end
    R = zeros(Float64, M.size)
    for i in 1:M.size
        for j in get_columns(M, i)
            R[i] += V[j] * M[i, j]
        end
    end
    return R
end


"""
Funkcja tworząca macierz postaci zadanej na liście wypełnioną podanymi wartościami.

# Dane
size – szerokość/wysokość macierzy

block_size – szerokość/wysokość bloku (musi być dzielnikiem size)

Vs – wektor trójek (i, j, v)

# Wyniki
M – macierz o zadanych właściwościach, że (∀ (i, j, v) ∈ Vs)(M[i, j] = v)
"""
function get_blockmatrix(size::Int, block_size::Int, Vs::Vector{Tuple{Int, Int, Float64}})
    M = get_blockmatrix(size, block_size)
    for (i, j, v) in Vs
        M[i, j] = v
    end
    return M
end


"""
Funkcja tworząca pustą macierz postaci zadanej na liście.

# Dane
size – szerokość/wysokość macierzy

block_size – szerokość/wysokość bloku (musi być dzielnikiem size)

# Wyniki
M – macierz o zadanych właściwościach
"""
function get_blockmatrix(size::Int, block_size::Int)
    block_no = Int(size / block_size)
    A = spzeros(size, size)
    return BlockMatrix(A, size, block_size, block_no, 0)
end

"""
Funkcja zwracająca dla danego wiersza macierzy zakres kolumn, w których występują niezerowe wartości.

# Dane
M – macierz

row – wiersz macierzy

# Wyniki
r – zakres kolumn
"""
function get_columns(M::BlockMatrix, row::Int)
    return get_first_column(M, row) : get_last_column(M, row)
end


"""
Funkcja zwracająca dla danego wiersza macierzy indeks pierwszej od lewej kolumny z niezerową wartością.

# Dane
M – macierz

row – wiersz macierzy

# Wyniki
c – indeks kolumny
"""
function get_first_column(M::BlockMatrix, row::Int)
    return max(1, row - ((row - 1) % M.block_size) - 1)
end


"""
Funkcja zwracająca dla danego wiersza macierzy indeks pierwszej od prawej kolumny z niezerową wartością.

# Dane
M – macierz

row – wiersz macierzy

# Wyniki
c – indeks kolumny
"""
function get_last_column(M::BlockMatrix, row::Int)
    return min(M.size, M.block_size + row)
end


"""
Funkcja zwracająca dla danej kolumny macierzy zakres wierszy, w których występują niezerowe wartości.

# Dane
M – macierz

column – kolumna macierzy

# Wyniki
r – zakres wierszy
"""
function get_rows(M::BlockMatrix, column::Int)
    return get_top_row(M, column) : get_bottom_row(M, column)
end


"""
Funkcja zwracająca dla danej kolumny macierzy indeks pierwszego od od góry wiersza z niezerową wartością.

# Dane
M – macierz

column – kolumna macierzy

# Wyniki
r – indeks wiersza
"""
function get_top_row(M::BlockMatrix, column::Int)
    return max(1, column - M.block_size)
end


"""
Funkcja zwracająca dla danej kolumny macierzy indeks pierwszego od od dołu wiersza z niezerową wartością.

# Dane
M – macierz

column – kolumna macierzy

# Wyniki
r – indeks wiersza
"""
function get_bottom_row(M::BlockMatrix, column::Int)
    return min(M.size, column + M.block_size - (column % M.block_size))
end

end