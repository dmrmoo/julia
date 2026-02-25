using UnicodePlots
using ChangePrecision


global b = false
global s = false
global n = false
global h = false
global eps :: Float32 = 0.00001
global delta :: Float32 = 0.00001
global maxIt :: Float32 = 10000
global mI = false
global initP::Float32 = 0.0
global initP2::Float32 = 1.0
global fname = ""
global coeffs = []
global vals = 0
global its = 0
global success = false


# command line format: julia  polRoot [-newt, -sec, -hybrid] [-maxIt n] initP [initP2] polyFileName 
for x in ARGS
    if occursin("-sec", x)
        global s = true
    elseif occursin("-newt", x)
        global n = true
    elseif occursin("-hybrid", x)
        global h = true
    else
        global b = true
    end
    
    if occursin(".pol", x)
        global fname = x
    elseif occursin("-maxIt", x)
       global mI = true
    elseif mI == true
        global maxIt = parse(Float32, x)
        mI = false
    elseif !startswith(x, "-")
        try
            if isinteger(parse(Float32, x))
                if initP == 0.0
                    global initP = parse(Float32, x)
                    initP2 = initP + 1.0
                else
                    global initP2 = parse(Float32, x)
                end
            end
        catch
        end
    end
end

function readFile()
    file = open(fname, "r")
    lines = readlines(file)
    global vals = parse(Float32, lines[1])
    global coeffs = [parse(Float32, x) for x in split(lines[2]) if !isempty(x)]
    close(file)
end

function writefile()
    file = replace(fname, ".pol" => ".sol")
    open(file, "a") do file
        
        write(file, "$ans $its $success\n\n")
    end
end



function solve(x::Float32) :: Float32
    result::Float32 = 0.0
    for i in eachindex(coeffs)
        result += coeffs[i] * x^(length(coeffs) - i)
    end
    return result
end

function solveDeriv(x::Float32) :: Float32
    result::Float32 = 0.0
    for i in 1:(length(coeffs)-1)
        power = length(coeffs) - i
        result += coeffs[i] * power * x^(power - 1)
    end
    return result
end


function bisection(a::Float32, b::Float32) :: Float32
    return bisection(a, b, maxIt)
end

function bisection(a::Float32, b::Float32, maxIt::Float32) :: Float32
@changeprecision Float32 begin
    fa = solve(a)
    fb = solve(b)

    if fa * fb >= 0
        println("Bisection method fails.")
        return -1
    end
    error = b - a
    c = a
    for i in 1:maxIt
        error /= 2
        c = a + error
        fc = solve(c)
        if fc == 0.0 || abs(error) < eps
            println("Bisection method converged in $i iterations.")
            global its = i
            global success = true
            return c
        end

        if (fa * fc < 0)
            b = c
            fb = fc
        else
            a = c
            fa = fc
        end
    end

    println("Bisection method reached maximum iterations without convergence.")
    return c
end
end

# for x use initial p and not initial p2
function newton(x::Float32) :: Float32
@changeprecision Float32 begin
    fx = solve(x)
    for i in 1:maxIt
        fd = solveDeriv(x)

        if abs(fd) < delta
            println("Derivative is too small. No solution found.")
            return x
        end

        d = fx / fd
        x -= d
        fx = solve(x)

        if abs(d) < eps
            println("Newton's method converged in $i iterations.")
            global its += i
            global success = true
            return x
        end
    end
    println("Maximum iterations reached without convergence.")
    return x
end
end

function secant(a::Float32, b::Float32) :: Float32
@changeprecision Float32 begin
    fa = solve(a)
    fb = solve(b)

    if abs(fa) < abs(fb)
        a, b = b, a
        fa, fb = fb, fa
    end

    for i in 1:maxIt
        if abs(fa) > abs(fb)
            a, b = b, a
            fa, fb = fb, fa
        end

        d = (b - a) / (fb - fa)
        b = a
        fb = fa
        d = d * fa

        if abs(d) < eps
            println("Secant method converged in $i iterations.")
            global its = i
            global success = true
            return a
        end

        a -= d
        fa = solve(a)
    end
    println("Maximum iterations reached without convergence.")
    return a
end
end

function hybrid(a ::Float32, b::Float32) :: Float32
@changeprecision Float32 begin
    # run bisection 5 times then switch to newton
    c = newton(bisection(a, b, 5::Float32))
    return c
end
end


function test()
    println(fname)
    println(initP)
    println(initP2)
    println(vals)

    for i in eachindex(coeffs)
        println(coeffs[i])
    end

    println(maxIt)
    println("s: $s, n: $n, h: $h, b: $b")

end


readFile()
test()



ans :: Float32 = -1
if s
    ans = secant(initP, initP2)
elseif n
    ans = newton(initP)
elseif h
    ans = hybrid(initP, initP2)
else
    ans = bisection(initP, initP2)
end

println("Using method: ", s ? "Secant" : n ? "Newton" : h ? "Hybrid" : "Bisection")
println("Approximate root: $ans")
writefile()

