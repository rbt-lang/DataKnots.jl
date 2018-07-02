#
# Generic lattice operations.
#

# Generic upper bound.  Concrete types must define
# `bound(::Type{T})` and `bound(x::T, y::T)`.

"""
    bound(::Type{T})

The least element of the type `T`.

    bound(x::T, y::T)

The tight upper bound of the given two values of type `T`.

    bound(xs::T...)
    bound(xs::Vector{T}...)

The tight upper bound of the given sequence.
"""
bound(x) = x

bound(x1, x2, x3, xs...) =
    foldl(bound, xs; init=bound(bound(x1, x2), x3))

bound(xs::Vector{T}) where {T} =
    foldl(bound, xs, init=bound(T))

# Dually, generic lower bound.  Concrete types must define
# `ibound(::Type{T})` and `ibound(x::T, y::T)`.

"""
    ibound(::Type{T})

The greatest element of the type `T`.

    ibound(x::T, y::Y)

The tight lower bound of the given two values of type `T`.

    ibound(xs::T...)
    ibound(xs::Vector{T}...)

The tight lower bound of the given sequence.
"""
ibound(x) = x

ibound(x1, x2, x3, xs...) =
    foldl(ibound, xs, init=ibound(ibound(x1, x2), x3))

ibound(xs::Vector{T}) where {T} =
    foldl(ibound, xs, init=ibound(T))

