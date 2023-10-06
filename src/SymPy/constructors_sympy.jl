## constructors

Sym(x::Number) = ↑(_sympy_.sympify(x))
Sym(x::AbstractString) = ↑(_sympy_.sympify(x))
Sym(x::Irrational{:π}) = PI
Sym(x::Irrational{:ℯ}) = E
Sym(x::Irrational{:φ}) = (1 + sqrt(Sym(5))) / 2
function Sym(x::Complex{Bool})
    !x.re &&  x.im && return IM
    !x.re && !x.im && return Sym(0)
     x.re && !x.im && return Sym(1)
     x.re &&  x.im && return Sym(1) + IM
end
Sym(x::Complex{T}) where {T} = Sym(real(x)) + Sym(imag(x)) * IM


function symbols(args...; kwargs...)
    as =  _sympy_.symbols(args...; kwargs...)
    hasproperty(as, :__iter__) && return Tuple((↑)(xᵢ) for xᵢ ∈ as)
    return ↑(as)
end

function SymFunction(x::AbstractString; kwargs...)
    out = _sympy_.Function(x; kwargs...)
    SymPyCore.SymFunction(out)
end

macro syms(xs...)
    # If the user separates declaration with commas, the top-level expression is a tuple
    if length(xs) == 1 && isa(xs[1], Expr) && xs[1].head == :tuple
        SymPyCore._gensyms(xs[1].args...)
    elseif length(xs) > 0
        SymPyCore._gensyms(xs...)
    end
end
