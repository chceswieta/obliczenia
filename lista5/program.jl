# Patryk Majewski, 250134
include("utils.jl")
using .blocksys
using .BlockMatrices
using .MatrixUtils

A = nothing
LU = nothing
P = nothing
b = nothing
x = nothing
target_x = nothing
elements = [:A, :LU, :P, :b, :x, :target_x]

while true
    print("\$ ")
    command = split(readline())
    if isempty(command) || command[1] == "fin"
        println()
        break
    elseif command[1] == "read"
        if length(command) == 3
            try
                global A = read_matrix(String(command[2]))
                global b = read_vector(String(command[3]))
                global LU = nothing
                global P = nothing
                global x = nothing
                global target_x = nothing

            catch err
                println("Nie udało się wczytać pliku")
            end
        else
            println("Użycie: read IN_A IN_b")
        end
    elseif command[1] == "reada"
        if length(command) == 2
            try
                global A = read_matrix(String(command[2]))
                global b = generate_rhs(A)
                global LU = nothing
                global P = nothing
                global x = nothing
                global target_x = ones(Float64, A.size)

            catch err
                println("Nie udało się wczytać pliku")
            end
        else
            println("Użycie: reada IN_A")
        end
    elseif command[1] == "readb"
        if length(command) == 2
            try
                global b = read_vector(String(command[2]))
                global x = nothing
                global target_x = nothing
            catch err
                println("Nie udało się wczytać pliku")
            end
        else
            println("Użycie: readb IN_b")
        end
    elseif command[1] == "gauss"
        if A === nothing
            println("Należy najpierw wczytać macierz A")
        elseif length(command) == 2 && command[2] == "pivot"
            global x = gaussian_elimination_with_pivoting(A, b)
            global A = nothing
            global b = nothing
        else
            global x = gauss_elimination(A, b)
            global A = nothing
            global b = nothing
        end
    elseif command[1] == "lu"
        if length(command) >= 2 && command[2] == "gen"
            if A === nothing
                println("Należy najpierw wczytać macierz A")
            elseif length(command) == 2
                generate_lu!(A)
                global LU = A
                global A = nothing
            elseif length(command) == 3 && command[3] == "pivot"
                global P = generate_lu_with_pivoting!(A)
                global LU = A
                global A = nothing
            else
                println("Użycie: lu gen [pivot]")
            end
        elseif length(command) == 2 && command[2] == "solve"
            if LU === nothing
                println("Należy najpierw przygotować rozkład LU")
            elseif b === nothing
                println("Należy najpierw wczytać wektor b")
            else
                if P === nothing
                    global x = solve_with_lu!(LU, b)
                else
                    global x = solve_with_pivoted_lu!(LU, P, b)
                end
                global b = nothing
            end
        else
            println("Użycie: lu (gen|solve)")
        end
    elseif command[1] == "write"
        if x === nothing
            println("Nie wyznaczono jeszcze wektora x")
        elseif length(command) == 1
            println("Użycie: write OUT")
        else
            write_x(String(command[2]), x, target_x)
        end
    else
        println("Nieprawidłowa komenda")
    end

    print("Gotowe elementy: ")
    for el in elements
        if eval(el) !== nothing
            print("$el ")
        end
    end
    println()
end

