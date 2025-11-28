# SPDX-License-Identifier: GPL-3.0-only
# Copyright © 2025 Roy Chih Chung Wang <roy.c.c.wang@proton.me>

using LinearAlgebra

T = Float64

a_path = joinpath(pwd(), "a.bin")
b_path = joinpath(pwd(), "b.bin")
output_path = joinpath(pwd(), "output.bin")

a = Memory{T}(reinterpret(T, read(a_path)))
b = Memory{T}(reinterpret(T, read(b_path)))
output_read = Memory{T}(reinterpret(T, read(output_path)))

println("Verify output.bin. Should be zero.")
output_oracle = dot(a, b) .* (b .- a)
@show norm(output_oracle - output_read)

nothing
