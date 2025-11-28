# SPDX-License-Identifier: GPL-3.0-only
# Copyright © 2025 Roy Chih Chung Wang <roy.c.c.wang@proton.me>

module DotProductIO

using LinearAlgebra

const T = Float64

function load_float(::Type{T}, file_path::AbstractString) where {T <: AbstractFloat}
    data_raw = reinterpret(T, read(file_path)) # Assumes system is little endianess. Need to modify this if using a big endian machine!
    data_binary = Memory{T}(data_raw)
    return data_binary
end

function store_bin(file_path::AbstractString, v_array::AbstractArray)
    v = reinterpret(UInt8, v_array)
    f = open(file_path, "w")
    write(f, v)
    close(f)
    return nothing
end

## works on Julia v1.12.1, but not with JuliaC v0.2.2.
# function store_bin(file_path::AbstractString, v_array::AbstractArray)
#     v = reinterpret(UInt8, v_array)
#     open(file_path, "w") do file
#         for x in v
#             write(file, x) # write a <:Real
#         end
#     end
#     return nothing
# end

## works on Julia v1.12.1, but not with JuliaC v0.2.2.
# function store_bin(file_path::AbstractString, v::AbstractArray{<:Real})
#     open(file_path, "w") do file
#         for x in v
#             write(file, x) # write a <:Real
#         end
#     end
#     return nothing
# end

# first two arguments are the file paths to binary files. Each is a binary file that stores Float64 values as UInt8. Tested on a little endianess systems.
function (@main)(ARGS)

    a = load_float(T, ARGS[1])
    b = load_float(T, ARGS[2])

    out = dot(a, b) .* (b .- a)
    store_bin(ARGS[3], out)

    #println(Core.stdout, "out = ", out) # won't work on Julia v.1.12.1, JuliaC v0.2.2
    #println(Core.stdout, out) # won't work on Julia v.1.12.1, JuliaC v0.2.2

    println(Core.stdout, "Input 1:")
    for i in eachindex(a)
        println(Core.stdout, a[i])
    end

    println(Core.stdout, "Input 2:")
    for i in eachindex(b)
        println(Core.stdout, b[i])
    end

    println(Core.stdout, "Output:")
    for i in eachindex(out)
        println(Core.stdout, out[i])
    end

    return 0 # must do this or we have:
    # fatal: error thrown and no exception handler available.
    # Core.MethodError(f=Base.var"#convert"(), args=(Core.Int32, nothing), world=0x000000000000975c)
    # upon exit of running the compiled binary.
end
# test data: a.bin, b.bin.
# a = [0.942970533446119, 0.13392275765318448, 1.5250689085124804, 0.12390123120559722, -1.205772284259936, 0.31181717536024806, -0.23464126496126003]
# b = [-1.0873522937105327, 0.4623106804313759, -0.08059308663320504, -0.8124306879044242, -2.0610343848003203, 0.3130563692286773, -0.4794303128671186]
# out = [-3.062234813287182, 0.49529115071947744, -2.4217400278127807, -1.4122228057230422, -1.289949235525102, 0.0018690144018280624, -0.36920313084324485]

end # module DotProductIO
