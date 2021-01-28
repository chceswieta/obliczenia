# Patryk Majewski, 250134

include("miejsca_zerowe.jl")
using .MiejscaZerowe

function print_tex_table(res)
    println(
        rpad(res[1], 25), " & ",
        rpad(res[2], 25), " & ",
        rpad(res[3], 20), " & ",
        rpad(res[4], 10), " \\\\\\hline"
    )
end

f1 = x -> ℯ^(1-x) - 1
df1 = x -> -ℯ^(1-x)
f2 = x -> x * ℯ^(-x)
df2 = x -> ℯ^(-x) * (1-x)
δ = ε = 10^-5


println("\n****** funkcja f_1 ******")

println("\n---- metoda bisekcji ----")
print(rpad("przedział", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_1(r)\$", "liczba iteracji", "kod błędu"])
for (a, b) in [(0., 2.), (-0.1, 2.), (-21.37, 37.21), (0.1, 1024.), (0.9, 1.0e6)]
    print(rpad("\$[$a, $b]\$", 20), " & ")
    print_tex_table(mbisekcji(f1, a, b, δ, ε))
end

println("\n--- metoda stycznych ----")
print(rpad("\$x_0\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_1(r)\$", "liczba iteracji", "kod błędu"])
for x0 in [0., -4., 10., 1.0e6]
    print(rpad(x0, 20), " & ")
    print_tex_table(mstycznych(f1, df1, x0, δ, ε, 100))
end

println("\n--- metoda siecznych ----")
print(rpad("\$x_0\$, \$x_1\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_1(r)\$", "liczba iteracji", "kod błędu"])
for (x0, x1) in [(0.,2.), (-0.1, 2.), (-21.37, 37.21), (0.1, 1024.), (0.9, 1.0e6)]
    print(rpad("\$$x0, $x1\$", 20), " & ")
    print_tex_table(msiecznych(f1, x0, x1, δ, ε, 100))
end

println("\n****** funkcja f_2 ******")

println("\n---- metoda bisekcji ----")
print(rpad("przedział", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_2(r)\$", "liczba iteracji", "kod błędu"])
for (a, b) in [(-1., 2.), (-0.1, 2.), (-21.37, 37.21), (-2.1, 1024.), (0.9, 1.0e6)]
    print(rpad("\$[$a, $b]\$", 20), " & ")
    print_tex_table(mbisekcji(f2, a, b, δ, ε))
end

println("\n--- metoda stycznych ----")
print(rpad("\$x_0\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_2(r)\$", "liczba iteracji", "kod błędu"])
for x0 in [-1., -4., 1., 10., 1.0e6]
    print(rpad(x0, 20), " & ")
    print_tex_table(mstycznych(f2, df2, x0, δ, ε, 100))
end

println("\n--- metoda siecznych ----")
print(rpad("\$x_0\$, \$x_1\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_2(r)\$", "liczba iteracji", "kod błędu"])
for (x0, x1) in [ (-0.1, 2.), (-0.7,1.5), (-21.37, 37.21), (0.1, 1024.), (0.9, 1.0e6)]
    print(rpad("\$$x0, $x1\$", 20), " & ")
    print_tex_table(msiecznych(f2, x0, x1, δ, ε, 100))
end

println("\n******* dodatkowo *******")

println("\n--- f1 ----")
print(rpad("\$x_0\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_1(r)\$", "liczba iteracji", "kod błędu"])
for x0 in [1.1, 2., 5., 10., 1.0e4]
    print(rpad(x0, 20), " & ")
    print_tex_table(mstycznych(f1, df1, x0, δ, ε, 100))
end

println("\n--- f2 ----")
print(rpad("\$x_0\$", 20), " & ")
print_tex_table(["pierwiastek r", "\$f_2(r)\$", "liczba iteracji", "kod błędu"])
for x0 in [1., 1.1, 2., 5., 10., 1.0e4]
    print(rpad(x0, 20), " & ")
    print_tex_table(mstycznych(f2, df2, x0, δ, ε, 100))
end