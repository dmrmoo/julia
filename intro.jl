# Basic Julia syntax examples
# Save this file as intro.jl and run with: julia intro.jl

# --- Variables and types ---
x = 10                # Int
y = 3.14              # Float64
greeting = "Hello"    # String
flag::Bool = true     # annotated type
const PI = 3.14159    # constant

println(x, " ", typeof(x))

# --- Collections ---
tup = (1, "two", 3.0)         # tuple (immutable)
arr = [1, 2, 3]               # Vector{Int}
push!(arr, 4)
dict = Dict("a" => 1, "b" => 2)
set = Set([1,2,2,3])

println(tup, " ", arr, " ", dict, " ", set)

# --- Ranges and comprehension ---
r = 1:2:9             # range with step
squares = [i^2 for i in 1:5 if i % 2 == 1]
println(r, " ", squares)

# --- Broadcasting ---
a = [1,2,3]
b = [10,20,30]
sum_arr = a .+ b      # elementwise addition
println(sum_arr)

# --- Control flow ---
if x > 5
    println("x > 5")
elseif x == 5
    println("x == 5")
else
    println("x < 5")
end

for i in 1:3
    println("for: ", i)
end

let i = 0
    while i < 3
        println("while: ", i)
        i += 1
    end
end

# --- Functions and multiple dispatch ---
# docstring for the function
"""
add(a, b)

Add two numbers.
"""
add(a, b) = a + b                # short-form function

# keyword args and varargs
function greet(name; punctuation="!")
    return "Hello, $name$punctuation"
end

function sum_all(nums...)
    s = zero(first(nums))
    for n in nums
        s += n
    end
    return s
end

println(add(2,3), " ", greet("Julia"), " ", sum_all(1,2,3,4))

# multiple dispatch example
area(r::Float64) = π * r^2
area(a::Int, b::Int) = a * b   # rectangle

println(area(2.0), " ", area(3,4))

# --- Anonymous functions and closures ---
mul_by(n) = x -> x * n
double = mul_by(2)
println(double(5))

# --- Structs (immutable and mutable) ---
struct Point
    x::Float64
    y::Float64
end

mutable struct Person
    name::String
    age::Int
end

p = Point(1.0, 2.0)
person = Person("Alice", 30)
person.age += 1

println(p, " ", person)

# --- Methods on structs / show usage ---
Base.show(io::IO, p::Point) = print(io, "Point($(p.x), $(p.y))")
println(p)   # uses custom show

# --- Error handling ---
function safe_div(a, b)
    try
        return a / b
    catch e
        @warn "division failed" exception=(e, catch_backtrace())
        return nothing
    end
end

println(safe_div(1,0))

# --- Modules and packages ---
# To use packages, use the package manager:
# using Pkg; Pkg.add("ExamplePackage")
# Example of module:
module MyUtils
export sq
sq(x) = x^2
end

using .MyUtils
println(sq(5))

# --- Macros and timing ---
println(@time sum(1:1_000_000))   # simple timing macro

# --- End ---