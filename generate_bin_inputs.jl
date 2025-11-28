# SPDX-License-Identifier: GPL-3.0-only
# Copyright © 2025 Roy Chih Chung Wang <roy.c.c.wang@proton.me>

using Random, LinearAlgebra

function store_bin(file_path::AbstractString, v_array::AbstractArray)
    v = reinterpret(UInt8, v_array)
    f = open(file_path, "w")
    write(f, v)
    close(f)
    return nothing
end

rng = Random.Xoshiro(0)

T = Float64
N = 7

a = randn(rng, T, N)
b = randn(rng, T, N)

a_path = joinpath(pwd(), "a.bin")
b_path = joinpath(pwd(), "b.bin")

store_bin(a_path, a)
store_bin(b_path, b)

output = dot(a, b) .* (b .- a) # this is the formula for the output of this example app.
@show output
# a = [0.942970533446119, 0.13392275765318448, 1.5250689085124804, 0.12390123120559722, -1.205772284259936, 0.31181717536024806, -0.23464126496126003]
# b = [-1.0873522937105327, 0.4623106804313759, -0.08059308663320504, -0.8124306879044242, -2.0610343848003203, 0.3130563692286773, -0.4794303128671186]
# [-3.062234813287182, 0.49529115071947744, -2.4217400278127807, -1.4122228057230422, -1.289949235525102, 0.0018690144018280624, -0.36920313084324485]

a_read = Memory{T}(reinterpret(T, read(a_path)))
b_read = Memory{T}(reinterpret(T, read(b_path)))

println("Round-trip discrepancies. Should be zero.")
@show norm(a - a_read)
@show norm(b - b_read)

if ispath(joinpath(pwd(), "out.bin"))
    output_read = Memory{T}(reinterpret(T, read(a_path)))
    @show norm(output - output_read)
end

nothing
