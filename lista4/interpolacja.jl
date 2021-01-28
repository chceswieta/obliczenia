# Patryk Majewski, 250134

module Interpolacja
export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx
using Plots

"""
Funkcja obliczająca ilorazy różnicowe potrzebne do przedstawienia wielomianu 
interpolacyjnego w postaci Newtona.

# Dane
x – wektor długości n zawierający węzły x_0, ..., x_n-1, gdzie 
    x[i] = x_{i-1}

f – wektor długości n zawierający wartości interpolowanej funkcji w węzłach,
    gdzie f[i] = f(x_{i-1})

# Wyniki
fx – wektor długości n zawierający obliczone ilorazy różnicowe, gdzie
    fx[i] = f[x_0, ..., x_{i-1}]
"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    n = length(x)
    fx = zeros(n)
    for i in 1:n
        fx[i] = f[i]
    end
    for j in 2:n
        for i in n:-1:j
            fx[i] = (fx[i] - fx[i-1])/(x[i]-x[i-j+1])
        end
    end
    return fx
end


"""
Funkcja obliczająca wartość wielomianu interpolacyjnego w postaci Newtona.

# Dane
x – wektor długości n zawierający węzły x_0, ..., x_n-1, gdzie 
    x[i] = x_{i-1}

fx – wektor długości n zawierający obliczone ilorazy różnicowe, gdzie
    fx[i] = f[x_0, ..., x_{i-1}]

t – punkt, w którym należy obliczyć wartość wielomianu

# Wyniki
nt – wartość wielomianu w punkcie t
"""
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n = length(x)
    nt = fx[n]
    for i in (n-1):-1:1
        nt = fx[i] + (t - x[i])*nt
    end
    return nt
end


"""
Funkcja wyznaczająca współczynniki dla postaci naturalnej wielomianu 
interpolacyjnego danego w postaci Newtona.

# Dane
x – wektor długości n zawierający węzły x_0, ..., x_n-1, gdzie 
    x[i] = x_{i-1}

fx – wektor długości n zawierający obliczone ilorazy różnicowe, gdzie
    fx[i] = f[x_0, ..., x_{i-1}]

# Wyniki
a – wektor długości n zawierający obliczone współczynniki postaci naturalnej, 
    gdzie a[i] to współczynnik przy x^{i-1}
"""
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n = length(x)
    a = zeros(n)
    a[n] = fx[n]
    for i in (n-1):-1:1
        a[i] = fx[i] - x[i] * a[i+1]
        for j in (i+1):(n-1)
            a[j] += -x[i] * a[j+1]
        end
    end
    return a
end


"""
Funkcja rysuje wielomian interpolacyjny i interpolowaną funkcję 
w przedziale [a, b] na n+1 równoodległych punktach.

# Dane
f – funkcja do interpolacji zadana jako anonimowa funkcja

a, b – przedział interpolacji

n – stopień wielomianu interpolacyjnego

# Wyniki
p – obiekt rysunku z wykresami wielomianu i funkcji
"""
function rysujNnfx(f,a::Float64,b::Float64,n::Int)
    x = zeros(n+1)
    y = zeros(n+1)
    h = (b-a)/n
    for k in 0:n
        x[k+1] = a + k*h
        y[k+1] = f(x[k+1])
    end
    c = ilorazyRoznicowe(x, y)

    points = 50 * (n+1)
    dx = (b-a)/(points-1)
    xs = zeros(points)
    poly = zeros(points)
    func = zeros(points)
    xs[1] = a
    poly[1] = func[1] = y[1]
    for i in 2:points
        xs[i] = xs[i-1] + dx
        poly[i] = warNewton(x, c, xs[i])
        func[i] = f(xs[i])
    end
    p = plot(xs, [poly func], label=["wielomian" "funkcja"], title="n = $n")
    display(p)
    return p
end

end