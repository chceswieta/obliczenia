# Patryk Majewski, 250134

include("miejsca_zerowe.jl")
using .MiejscaZerowe

δ = ε = (10^-5)/2
f = x -> sin(x) - (x/2)^2
df = x -> cos(x) - x/2
r = 1.9337537628270212
println("sin(x) - (x/2)^2 = 0")
println("legenda: (przybliżenie pierwiastka r, f(r), liczba iteracji, kod błędu)\n")

res = mbisekcji(f, 1.5, 2., δ, ε)
println("metoda bisekcji:   ", res)
println("                   |r-x| = ", abs(r-res[1]), "\n")

res = mstycznych(f, df, 1.5, δ, ε, 100)
println("metoda Newtona:    ", res)
println("                   |r-x| = ", abs(r-res[1]), "\n")

res = msiecznych(f, 1., 2., δ, ε, 100)
println("metoda siecznych:  ", res)
println("                   |r-x| = ", abs(r-res[1]), "\n")
