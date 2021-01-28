# Patryk Majewski, 250134

module MiejscaZerowe
export mbisekcji, mstycznych, msiecznych


"""
Funkcja rozwiązująca równanie f(x) = 0 metodą bisekcji.

# Dane
f – funkcja f(x) zadana jako anonimowa funkcja,
a, b – końce przedziału początkowego,
delta, epsilon – dokładności obliczeń.

# Wyniki
Czwórka (r, v, it, err), gdzie
r – przybliżenie pierwiastka równania f(x) = 0,
v – wartość f(r),
it – liczba wykonanych iteracji,
err – sygnalizacja błędu:
        0 - brak błędu,
        1 - funkcja nie zmienia znaku w przedziale [a,b].
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    A = f(a)
    B = f(b)

    if sign(A) == sign(B)
        return Nothing, Nothing, Nothing, 1
    end

    er = b - a
    it = 0

    while true
        it += 1
        er /= 2
        c = a + er
        v = f(c)

        if abs(er) < delta || abs(v) < epsilon
            return c, v, it, 0
        end

        if sign(v) != sign(A)
            b = c
            B = v
        else
            a = c
            A = v
        end
    end
end


"""
Funkcja rozwiązująca równanie f(x) = 0 metodą Newtona.

# Dane
f, pf – funkcja f(x) oraz pochodna f'(x) zadane jako anonimowe funkcje,
x0 – przybliżenie początkowe,
delta, epsilon – dokładności obliczeń,
maxit – maksymalna dopuszczalna liczba iteracji.

# Wyniki
Czwórka (r, v, it, err), gdzie
r – przybliżenie pierwiastka równania f(x) = 0,
v – wartość f(r),
it – liczba wykonanych iteracji,
err – sygnalizacja błędu:
        0 - brak błędu,
        1 - nie osiągnięto wymaganej dokładności w maxit iteracji,
        2 - pochodna bliska zeru.
"""
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    if abs(v) < epsilon
        return x0, v, 0, 0
    end

    for it in 1:maxit
        df = pf(x0)
        if abs(df) < epsilon
            return x0, v, it, 2
        end

        x1 = x0 - v/df
        v = f(x1)
        if abs(x1 - x0) < delta || abs(v) < epsilon
            return x1, v, it, 0
        end
        x0 = x1
    end
    return x0, v, maxit, 1
end


"""
Funkcja rozwiązująca równanie f(x) = 0 metodą siecznych.

# Dane
f – funkcja f(x) zadana jako anonimowa funkcja,
x0, x1 – przybliżenia początkowe,
delta, epsilon – dokładności obliczeń,
maxit – maksymalna dopuszczalna liczba iteracji.

# Wyniki
Czwórka (r, v, it, err), gdzie
r – przybliżenie pierwiastka równania f(x) = 0,
v – wartość f(r),
it – liczba wykonanych iteracji,
err – sygnalizacja błędu:
        0 - brak błędu,
        1 - nie osiągnięto wymaganej dokładności w maxit iteracji.
"""
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    A = f(x0)
    B = f(x1)
    for it in 1:maxit
        if abs(A) < abs(B)
            x0, x1 = x1, x0
            A, B = B, A
        end
        s = (x1 - x0)/(B - A)
        x0 = x1
        A = B
        x1 = x1 - A * s
        B = f(x1)
        if abs(x1 - x0) < delta || abs(B) < epsilon
            return x1, B, it, 0
        end
    end
    return x1, B, maxit, 1
end

end