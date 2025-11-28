# compile-julia-examples

## DotProductIO
This example loads two binary files, each into a `Float64` 1-D array, `a`, `b`, respectively. The output is given by: 
```
output = dot(a, b) .* (b .- a)
```
The output is saved in the user specified path as a binary file. It is stored as `UInt8`, and intended values are `Float64`. The routines involved with the binary input and output are for little endian systems; please make adjustments if you are adopting this example for a big endian system.

The binary files were tested on a little endian system (Fedora Workstation 43, 64-bit, AMD64):
```
Julia Version 1.12.2
Commit ca9b6662be4 (2025-11-20 16:25 UTC)
Build Info:
  Official https://julialang.org release
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 16 × AMD Ryzen 7 8745HS w/ Radeon 780M Graphics
  WORD_SIZE: 64
  LLVM: libLLVM-18.1.7 (ORCJIT, znver3)
  GC: Built with stock GC
Threads: 1 default, 1 interactive, 1 GC (on 16 virtual cores)
```

### Tutorial (Linux):

#### 1. Setup dependencies
Install [JuliaC](https://github.com/JuliaLang/JuliaC.jl).

On Fedora linux, make sure the build essentials are installed. The following is one of many ways to do so:
```
sudo dnf install make automake gcc gcc-c++ kernel-devel
```

#### 2. Generate test inputs
`cd` a terminal session to the root this repository. Run `generate_bin_inputs.jl` in a Julia REPL to generate `a.bin` and `b.bin`.

#### 3. Compile
Run the following in the same terminal session:
```
juliac \
    --output-exe app_test_exe \
    --bundle (path where the binary and libraries should be placed) \
    --trim=safe \
    --experimental \
    (path of julia project folder that contains the module with only one app)
```
The line with `DotProductIO` should be replaced with the path to this subdirectory on your local machine, i.e. to the folder `compile-julia-examples/DotProductIO'.

The word with `build` should be replaced with a directory path where you want the output binaries to be placed.

For the remainder of this tutorial, we assume the following was executed in a a terminal session at the root of this repository:
```
juliac \
    --output-exe dp-app \
    --bundle build \
    --trim=safe \
    --experimental \
    DotProductIO
```

On my machine, the terminal output is:
```
✓ Compiling...
PackageCompiler: bundled libraries:
  ├── Base:
  │    ├── libLLVM.so.18.1jl - 105.521 MiB
  │    ├── libatomic.so.1.2.0 - 159.875 KiB
  │    ├── libdSFMT.so - 21.602 KiB
  │    ├── libgcc_s.so.1 - 892.930 KiB
  │    ├── libgfortran.so.5.0.0 - 9.553 MiB
  │    ├── libgmp.so.10.5.0 - 707.688 KiB
  │    ├── libgmpxx.so.4.7.0 - 36.445 KiB
  │    ├── libgomp.so.1.0.0 - 1.469 MiB
  │    ├── libjulia-codegen.so.1.12.1 - 77.409 MiB
  │    ├── libjulia-internal.so.1.12.1 - 14.130 MiB
  │    ├── libmpfr.so.6.2.2 - 2.406 MiB
  │    ├── libopenlibm.so.4.0 - 248.109 KiB
  │    ├── libpcre2-8.so.0.13.0 - 663.234 KiB
  │    ├── libquadmath.so.0.0.0 - 966.984 KiB
  │    ├── libssp.so.0.0.0 - 35.555 KiB
  │    ├── libstdc++.so.6.0.34 - 2.513 MiB
  │    ├── libunwind.so.8.1.0 - 504.258 KiB
  │    ├── libuv.so.2.0.0 - 656.695 KiB
  │    ├── libz.so.1.3.1 - 116.062 KiB
  │    ├── libjulia.so.1.12.1 - 246.195 KiB
  ├── Stdlibs:
  │   ├── OpenBLAS_jll
  │   │   ├── libopenblas64_.0.3.29.so - 34.150 MiB
  │   ├── libblastrampoline_jll
  │   │   ├── libblastrampoline.so.5 - 3.418 MiB
  Total library file size: 255.703 MiB
```

#### 4. Run the compiled binary app
`cd` a terminal session to `build/bin`, and run:
```
./dp-app ../../a.bin ../../b.bin ../../output.bin
```

The terminal should display:
```
Input 1:
0.942970533446119
0.13392275765318448
1.5250689085124804
0.12390123120559722
-1.205772284259936
0.31181717536024806
-0.23464126496126003
Input 2:
-1.0873522937105327
0.4623106804313759
-0.08059308663320504
-0.8124306879044242
-2.0610343848003203
0.3130563692286773
-0.4794303128671186
Output:
-3.062234813287182
0.49529115071947744
-2.4217400278127807
-1.4122228057230422
-1.289949235525102
0.0018690144018280624
-0.36920313084324485
```

#### 5. Verify the app's output file
`cd` a terminal session to the root of this repository. Verify the contents of `output.bin` by running `verify_output_bin.jl` in a Julia REPL.

#### 6. Relocate the binary on a different 64-bit Linux system
This tutorial was carried out on a Fedora Workstation 43, 64-bit, AMD Ryzen 8745hs. I copied the entire `build` folder, and could successfully run the `dp-app` binary on a different PC (AMD Ryzen 9700X) that also runs Fedora Workstation 43, 64-bit. I have not tried running this binary on a different type of linux operating system.

# License
This project is licensed under the GPL V3.0 license; see the `LICENSE` file for details. Individual source files may contain the following tag instead of the full license text:
```
SPDX-License-Identifier: GPL-3.0-only
```

Using SPDX enables machine processing of license information based on the SPDX License Identifiers and makes it easier for developers to see at a glance which license they are dealing with.
