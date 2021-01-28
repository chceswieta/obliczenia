# Patryk Majewski, 250134

include("miejsca_zerowe.jl")
using .MiejscaZerowe

δ = ε = 10^-4
g = x -> ℯ^x - 3x
println("g(x) = ℯ^x - 3x")
println("legenda: (przybliżenie pierwiastka r, g(r), liczba iteracji, kod błędu)")
println("pierwszy pierwiastek:  ", mbisekcji(g, 0., 1., δ, ε))
println("drugi pierwiastek:     ", mbisekcji(g, 1., 4., δ, ε))