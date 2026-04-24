using FEMLab   # load package and bring exported names into this (Main) namespace
#import FEMLab  # load package but only bring the module name into this (Main) namespace


# Julia documentation/manual is excellent
# https://docs.julialang.org/en/v1/


# define integer variable
a = 2

# define floating point variable
b = 3.0

# define a vector
v = [1; 2; 3]

# indexing and mutating vectors
v[1] = 0
v[3] = 10

# display a variable to REPL (Read-Eval-Print-Loop)
display(v[1])
display(v)

# define a tuple
c = (1, 2, 3)

# tuples are not mutable
#c[1] = 0 # this is not legal!

# defining a matrix
A = [1 2 3; 4 5 6; 7 8 9]

# iterating over vectors/tuples/iterables
for k = 1:3
    @info "k = $k"
    @info "v[$k] = $(v[k])"
    @info "c[$k] = $(c[k])"
    @info "A[$k,$k] = $(A[k,k])"
end # equality
A[1,1] == c[1]

# inequality
c[1] < A[1,1]
c[1] ≤ A[1,1] # eq. c[1] <= A[1,1]
c[3] > A[1,3]
c[3] ≥ A[1,3] # eq. c[3] >= A[1,3]

# array slicing 
A[:,1] == [1; 4; 7]
A[2,:] == [4; 5; 6]
A[1:2,2:3] == [2 3; 5 6]
A[1:end,2:end] == [2 3; 5 6; 8 9]


# define function
function f(x,y)
    x^2 + y^2
end

f(x) = x^2

f(x,y,z) = begin
    a = x^2
    b = y^2
    c = z^2
    sqrt(a + b + c) # last statement value is returned
    # == return sqrt(a + b + c)
end

# show methods belonging to f
methods(f)

# anonymous (nameless) functions (similar to Python's lambda functions)
# g and h are not functions but variables "pointing" to a (nameless) function
g = x -> x^2
h = (x,y) -> x^2 + y^2
o = (x,y,z) -> begin
    a = x^2
    b = y^2
    c = z^2
    return sqrt(a + b + c)
end

# function composition (r points now to a new anonymous function)
r = (x,y) -> (g ∘ h)(x, y) # r(2,3) = (2^2 + 3^2)^2




## composite data types, subtyping and multiple dispatch (advanced)
abstract type Shape{T} end

struct Square{T<:Real} <: Shape{T}
    w::T
    function Square(w::T) where {T<:Real}
        (w < 0) && error("rectangle width must be positive!")
        new{T}(w)
    end
end

struct Rectangle{T<:Real} <: Shape{T}
    h::T
    w::T
    function Rectangle(w::T, h::T) where {T<:Real}
        (w < 0) && error("rectangle width must be positive!")
        (h < 0) && error("rectangle height must be positive!")
        new{T}(w, h)
    end
end

struct Circle{T<:Real} <: Shape{T}
    r::T
    function Circle(r::T) where {T<:Real}
        (r < 0) && error("circle radius must be positive!")
        new{T}(r)
    end
end

# multiple dispatch
area(::Shape) = error("fallback called")
area(s::Square) = s.w^2
area(s::Rectangle) = s.w * s.h

r = Rectangle(2.0, 3.0)
s = Square(2.0)
c = Circle(π)

Ar = area(r)
As = area(s)
#Ac = area(c) # not implemented, so error method in line 106 is called