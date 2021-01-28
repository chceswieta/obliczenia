# Patryk Majewski, 250134

include("hilb.jl")
include("matcond.jl")
    
# Rozwiązuje układ równań Ax = b, gdzie prawdziwym rozwiązaniem jest wektor jedynek.
# Najpierw wyznacza b = A * transposed(1,1,....,1),
# a następnie wyznacza rozwiązania metodą Gaussa i metodą inwersji.
# Ostatecznie wyznacza błędy względne uzyskane dla obu metod.
# Dane:
# A - macierz współczynników,
# n - liczba wierszy A
function solve(A,n)
    x = ones(Float64,n)
    b = A * x

    x_gauss = A\b
    x_inv = inv(A)*b

    err_gauss = norm(x_gauss - x)/norm(x)
    err_inv = norm(x_inv - x)/norm(x)

    println(rpad(n, 3), 
        " & ", rpad(cond(A), 25), 
        " & ", rpad(rank(A), 10), 
        " & ", rpad(err_gauss, 25), 
        " & ", rpad(err_inv, 25), 
        " \\\\\\hline")
end


println("---- Macierz Hilberta ----\n")
println(rpad("n", 3), 
        " & ", rpad("\$cond(A)\$", 25), 
        " & ", rpad("\$rank(A)\$", 10), 
        " & ", rpad("błąd met. Gaussa", 25), 
        " & ", rpad("błąd met. inwersji", 25), 
        " \\\\\\hline")

for n in 1:3:52
    solve(hilb(n), n)
end

println("\n---- Macierz losowa ----\n")
println(rpad("n", 3), 
        " & ", rpad("\$cond(A)\$", 25), 
        " & ", rpad("\$rank(A)\$", 10), 
        " & ", rpad("błąd met. Gaussa", 25), 
        " & ", rpad("błąd met. inwersji", 25), 
        " \\\\\\hline")

for n in [5,10,20]
    for c in [0,1,3,7,12,16]
        solve(matcond(n, 10.0^c), n)
    end
end