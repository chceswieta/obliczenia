# Patryk Majewski, 250134

function forward(x, y, type)
    sum = type(0.0)
    for i in 1:length(x)
        sum += x[i] * y[i]
    end 
    return sum
end

function backward(x, y, type)
    sum = type(0.0)
    for i in length(x):-1:1
        sum += x[i] * y[i]
    end 
    return sum
end

function partial_desc(x, y)
    p = x .* y
    sum_pos = sum(sort(filter(a -> a>0, p), rev=true))
    sum_neg = sum(sort(filter(a -> a<0, p)))
    return sum_pos+sum_neg
end

function partial_asc(x, y)
    p = x .* y
    sum_pos = sum(sort(filter(a -> a>0, p)))
    sum_neg = sum(sort(filter(a -> a<0, p), rev=true))
    return sum_pos+sum_neg
end

x = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

println("---- Przed zmianami: ----\n")
for t in [Float32, Float64]
    a = Array{t,1}(x)
    b = Array{t,1}(y)
    println(t)
    println(rpad("forward: ", 15), forward(a, b, t))
    println(rpad("backward: ", 15), backward(a, b, t))
    println(rpad("partial_desc: ", 15), partial_desc(a, b))
    println(rpad("partial_asc: ", 15), partial_asc(a, b), '\n')
end

x = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]

println("\n---- Po naniesieniu zmian w x: ----\n")
for t in [Float32, Float64]
    a = Array{t,1}(x)
    b = Array{t,1}(y)
    println(t)
    println(rpad("forward: ", 15), forward(a, b, t))
    println(rpad("backward: ", 15), backward(a, b, t))
    println(rpad("partial_desc: ", 15), partial_desc(a, b))
    println(rpad("partial_asc: ", 15), partial_asc(a, b), '\n')
end