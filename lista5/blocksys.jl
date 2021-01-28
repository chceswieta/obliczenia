# Patryk Majewski, 250134
include("blockmatrix.jl")

module blocksys
export  generate_rhs,
        gauss_elimination, 
        gaussian_elimination_with_pivoting, 
        generate_lu!, solve_with_lu!, solve_by_lu!, 
        generate_lu_with_pivoting!, solve_with_pivoted_lu!, solve_by_pivoted_lu!
using Main.BlockMatrices

"""
Funkcja wyznaczająca wektor prawych stron dla podanej macierzy A przy założeniu, że wektor rozwiązań x
składa się z samych jedynek.

# Dane
A – macierz współczynników rozmiaru n×n z niezerowymi (dostatecznie dużymi) elementami na przekątnej, będąca postaci
    opisanej na liście

# Wyniki
b – wektor prawych stron długości n

"""
function generate_rhs(A::BlockMatrix)
    R = zeros(Float64, A.size)
    for i in 1:A.size
        for j in get_columns(A, i)
            R[i] += A[i, j]
        end
    end
    return R
end

# ELIMINACJA GAUSSA BEZ WYBORU

"""
Funkcja rozwiązująca układ równań postaci opisanej na liście metodą eliminacji Gaussa.

# Dane
A – macierz współczynników rozmiaru n×n z niezerowymi (dostatecznie dużymi) elementami na przekątnej, będąca postaci
    opisanej na liście

b – wektor prawych stron długości n

# Wyniki
x – wektor rozwiązań długości n

"""
function gauss_elimination(A::BlockMatrix, b::Vector{Float64})
    n = A.size
    
    # faza eliminacji
    for k in 1 : n-1
        for i in k+1 : get_bottom_row(A, k)
            try
                m = A[i, k] / A[k, k]
                A[i, k] = 0.0

                for j in k+1 : get_last_column(A, k)
                    A[i, j] -= m * A[k, j]
                end

                b[i] -= m * b[k]

            catch err
                error("Zero value on the diagonal of A at index ($k, $k)")

            end            
        end
    end

    # wyznaczanie wektora x
    x = zeros(n)
    x[n] = b[n] / A[n, n]
    for i in n-1 : -1 : 1
        x[i] = b[i]
        for j in i+1 : get_last_column(A, i)
            x[i] -= A[i, j] * x[j]
        end
        x[i] /= A[i, i]
    end
    return x
end

# ELIMINACJA GAUSSA Z CZĘŚCIOWYM WYBOREM

"""
Funkcja rozwiązująca układ równań postaci opisanej na liście metodą eliminacji Gaussa z częściowym wyborem.

# Dane
A – macierz współczynników rozmiaru n×n z niezerowymi (dostatecznie dużymi) elementami na przekątnej, będąca postaci
    opisanej na liście

b – wektor prawych stron długości n

# Wyniki
x – wektor rozwiązań długości n

"""
function gaussian_elimination_with_pivoting(A::BlockMatrix, b::Vector{Float64})
    n = A.size
    p = [1:n;]
    
    for k in 1 : n-1
        bound = get_bottom_row(A, k)
        j = reduce((x, y) -> abs(A[p[x], k]) >= abs(A[p[y], k]) ? x : y, k : bound)
        p[k], p[j] = p[j], p[k]
        for i in k+1 : bound
            z = A[p[i], k] / A[p[k], k]
            A[p[i], k] = 0.0
            # p[k] to najwyżej k + block_size, ponieważ poniżej są już zera
            # można by ograniczyć to bardziej, na przykład pamiętając maksymalny dotychczas użyty indeks wiersza (łącznie z p[k])
            for j in k+1 : get_last_column(A, k + A.block_size)
                A[p[i], j] -= z * A[p[k], j]
            end
            b[p[i]] -= z * b[p[k]]
        end
    end

    # wyznaczanie wektora x
    x = zeros(n)
    x[n] = b[p[n]] / A[p[n], n]
    for i in n-1 : -1 : 1
        x[i] = b[p[i]]
        # analiza jak wyżej
        for j in i+1 : get_last_column(A, i + A.block_size)
            x[i] -= A[p[i], j] * x[j]
        end
        x[i] /= A[p[i], i]
    end
    return x
end

# LU BEZ WYBORU

"""
Funkcja wyznaczająca rozkład LU dla podanej macierzy współczynników.

# Dane
A – macierz współczynników będąca postaci opisanej na liście (ulega zmianom)
"""
function generate_lu!(A::BlockMatrix)    
    n = A.size

    for k in 1 : n-1
        for i in k+1 : get_bottom_row(A, k)
            try
                m = A[i, k] / A[k, k]
                A[i, k] = m

                for j in k+1 : get_last_column(A, k)
                    A[i, j] -= m * A[k, j]
                end

            catch err
                error("Zero value on the diagonal of A at index ($k, $k)")

            end            
        end
    end
end


"""
Funkcja rozwiązująca układ równań dla podanego wektora prawych stron i rozkładu LU macierzy współczynników.

# Dane
LU – rozkład LU macierzy A jako jedna macierz rozmiaru n×n postaci opisanej na liście, gdzie pod diagonalą 
znajduje się L, a nad – U

b – wektor prawych stron długości n (ulega zmianom)

# Wyniki
x – wektor rozwiązań długości n

"""
function solve_with_lu!(LU::BlockMatrix, b::Vector{Float64})
    n = LU.size

    # Lz = b
    # z przechowamy w miejsce b, bo
    # na diagonali L są w domyśle jedynki
    for k in 1 : n - 1
        for i in k + 1 : get_bottom_row(LU, k)
            b[i] -= LU[i, k] * b[k]
        end
    end

    # Ux = z
    x = zeros(Float64, n)
    for i in n : -1 : 1
        x[i] = b[i]
        for j in i+1 : get_last_column(LU, i)
            x[i] -= LU[i, j] * x[j]
        end
        x[i] /= LU[i, i]
    end
    return x
end


"""
Funkcja rozwiązująca układ równań postaci opisanej na liście z wykorzystaniem rozkładu LU.

# Dane
A – macierz współczynników rozmiaru n×n będąca postaci opisanej na liście

b – wektor prawych stron długości n

# Wyniki
x – wektor rozwiązań długości n
"""
function solve_by_lu!(A, b)
    generate_lu!(A)
    return solve_with_lu!(A, b)
end

# LU Z CZĘŚCIOWYM WYBOREM

"""
Funkcja wyznaczająca rozkład LU z wykorzystaniem częściowego wyboru dla podanej macierzy współczynników.

# Dane
A – macierz współczynników będąca postaci opisanej na liście (ulega zmianom)

# Wyniki
p – wektor permutacji
"""
function generate_lu_with_pivoting!(A::BlockMatrix)
    n = A.size
    p = [1:n;]
    for k in 1 : n-1
        bound = get_bottom_row(A, k)
        j = reduce((x, y) -> abs(A[p[x], k]) >= abs(A[p[y], k]) ? x : y, k : bound)
        p[k], p[j] = p[j], p[k]
        for i in k+1 : bound
            z = A[p[i], k] / A[p[k], k]
            A[p[i], k] = z
            for j in k+1 : get_last_column(A, k + A.block_size)
                A[p[i], j] -= z * A[p[k], j]
            end
        end
    end
    return p
end


"""
Funkcja rozwiązująca układ równań dla podanego wektora prawych stron i rozkładu LU macierzy współczynników wiersza
z wektorem permutacji uzyskanym podczas generowania rozkładu z częściowym wyborem.

# Dane
LU – rozkład LU macierzy A jako jedna macierz rozmiaru n×n postaci opisanej na liście, gdzie pod diagonalą 
znajduje się L, a nad – U

P – wektor permutacji długości n

b – wektor prawych stron długości n (ulega zmianom)

# Wyniki
x – wektor rozwiązań długości n

"""
function solve_with_pivoted_lu!(LU::BlockMatrix, P::Vector{Int}, b::Vector{Float64})
    n = LU.size

    # Lz = Pb
    for i in 2 : n
        # P[i] to maksymalnie i + block_size, więc tu maksymalnie 2 * block_size iteracji
        for j in get_first_column(LU, P[i]) : i-1
            b[P[i]] -= LU[P[i], j] * b[P[j]]
        end
    end

    # Ux = z
    x = zeros(Float64, n)
    x[n] = b[P[n]] / LU[P[n], n]
    for i in n-1 : -1 : 1
        x[i] = b[P[i]]
        for j in i+1 : get_last_column(LU, i + LU.block_size)
            x[i] -= LU[P[i], j] * x[j]
        end
        x[i] /= LU[P[i], i]
    end
    return x
end


"""
Funkcja rozwiązująca układ równań postaci opisanej na liście z wykorzystaniem rozkładu LU i częściowym wyborem.

# Dane
A – macierz współczynników rozmiaru n×n będąca postaci opisanej na liście

b – wektor prawych stron długości n

# Wyniki
x – wektor rozwiązań długości n
"""
function solve_by_pivoted_lu!(A, b)
    P = generate_lu_with_pivoting!(A)
    return solve_with_pivoted_lu!(A, P, b)
end

end
