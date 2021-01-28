# Patryk Majewski, 250134

p1 = Float32(0.01)
p3 = Float64(0.01)
r = 3

# Funkcja wyznaczająca kolejny wyraz ciągu zadanego wzorem z zadania
next(p) = p + r*p*(1-p)

println(rpad("n", 3),
            " & ", rpad("Float32", 20), 
            " & ", rpad("Float32 z obcięciem", 20), 
            " & ", rpad("Float64", 25), 
            "\\\\\\hline")
for n in 0:9
    println(rpad(n, 3),
            " & ", rpad(p1, 20), 
            " & ", rpad(p1, 20), 
            " & ", rpad(p3, 25), 
            "\\\\\\hline")
    global p1 = next(p1)
    global p3 = next(p3)
end

p2 = Float32(0.722) # p2 dotychczas było identyczne jak p1, teraz następuje ucięcie

for n in 10:40
    println(rpad(n, 3),
            " & ", rpad(p1, 20), 
            " & ", rpad(p2, 20), 
            " & ", rpad(p3, 25), 
            "\\\\\\hline")
    global p1 = next(p1)
    global p2 = next(p2)
    global p3 = next(p3)
end