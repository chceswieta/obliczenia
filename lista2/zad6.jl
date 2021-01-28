# Patryk Majewski, 250134

# Funkcja wyznaczająca kolejny wyraz ciągu zadanego wzorem z zadania
next(x, c) = x^2 + c

println("---- Dla c = -2 ----\n")
c = -2
x1 = 1.
x2 = 2.
x3 = 1.99999999999999

println(rpad("n", 3),
        " & ", rpad("\$x_0=1\$", 10), 
        " & ", rpad("\$x_0=2\$", 10), 
        " & ", rpad("\$x_0=1.99999999999999\$", 25), 
        " \\\\\\hline")

for n in 1:40
    global x1 = next(x1, c)
    global x2 = next(x2, c)
    global x3 = next(x3, c)
    println(rpad(n, 3),
        " & ", rpad(x1, 10), 
        " & ", rpad(x2, 10), 
        " & ", rpad(x3, 25), 
        " \\\\\\hline")
end

println("\n---- Dla c = -1 ----\n")
c = -1
x4 = 1.
x5 = -1.
x6 = 0.75
x7 = 0.25

println(rpad("n", 3),
        " & ", rpad("\$x_0=1\$", 10), 
        " & ", rpad("\$x_0=-1\$", 10), 
        " & ", rpad("\$x_0=0.75\$", 25), 
        " & ", rpad("\$x_0=0.25\$", 25), 
        " \\\\\\hline")

for n in 1:40
    global x4 = next(x4, c)
    global x5 = next(x5, c)
    global x6 = next(x6, c)
    global x7 = next(x7, c)
    println(rpad(n, 3),
        " & ", rpad(x4, 10), 
        " & ", rpad(x5, 10), 
        " & ", rpad(x6, 25), 
        " & ", rpad(x7, 25), 
        " \\\\\\hline")
end