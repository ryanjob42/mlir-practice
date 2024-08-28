# MLIR Practice
A practice repo for creating a standalone MLIR dialect.

This repo is based on MLIR's example of a standalone project.
See the link below.

https://github.com/llvm/llvm-project/tree/main/mlir/examples/standalone

Parts of this repo were designed for the computer science department machines
at Colorado State University (for my own convenience).
If you're trying to use this elsewhere, some very minor changes may be needed.
Mainly, if you see the `module` command anywhere, you'll need to remove it.

## Setup
Prior to using this repo, you will need to clone the LLVM repo and build it a certain way.
Additionally, this repo expects that you have added the `llvm-project/build/bin` directory to your `PATH`,
and that you set up the `LLVM_BUILD_DIR` environment variable to point to the `llvm-project/build` directory.

For instructions on all this, see: [docs/MLIR Setup.md](./docs/MLIR%20Setup.md).

## Compiling
I've set up a `build.sh` script which compiles everything here (using CMake).
If you're running on the department machines, you can call it as-is.
Otherwise, you'll need to remove the `module` commands from the script.

## Repository Layout
The layout of this repo is as follows.

- `build/`: When you run the `build.sh` script, all compilation files go here.
- `docs/`: Documents I've created to help understand what's here.
- `include/`: TODO
  - `Standalone/`: The definitions for the "Standalone" dialect.
  - `Standalone-c/`: TODO
- `lib/`: TODO
- `python/`: TODO
- `standalone-opt/`: The source for the `standalone-opt` application (see [Applications](#applications)).
- `standalone-plugin/`: Contains definitions for registering the "Standalone" dialect and compiler pass as plugin modules.
- `standalone-translate/`: The source for the `standalone-translate` application (see [Applications](#applications)).
- `test/`: The source for the `standalone-capi-test` application (see [Applications](#applications)).
- `build.sh`: The compilation script.
- `CMakeLists.txt`: Defines how CMake should build the project.
- `LICENSE.TXT`: LLVM's licence.
- `README.md`: The file you're currently reading.

## Applications
The `build.sh` script will cause three applications to be built:

1. `standalone-capi-test`
2. `standalone-opt`
3. `standalone-translate`

The `-capi-test` program tests that the C APIs for the "Standalone" dialect and passes work as intended.

The `-opt` program is intended for taking MLIR and optimizing it into a better MLIR representation.
Specifically, since this program is the `standalone-opt`, it optimizes MLIR that includes the "Standalone" dialect found in this repo.

The `-translate` program is intended for translating MLIR into some other intermediate representation.
Again, since it's `standalone-translate`, it is capable of translating MLIR that includes the "Standalone" dialect found here.

Per the link below, these programs are intended to work together to form the middle stages of your compiler.
You are intended to have a front end that takes your source code and produces MLIR that includes the "Standalone" dialect.
This gets passed into `standalone-opt` to optimize the MLIR and convert it into a different dialect, such as MLIR's LLVM dialect.
From there, you pass that into `standalone-translate` to translate it into a different IR, such as LLVM IR.
Note the distinction between MLIR's LLVM dialect and the actual LLVM IR.
This could then be passed into some backend which optimizes the LLVM IR and generates actual machine code (i.e., a library or an executable).

https://discourse.llvm.org/t/mlir-documentation-is-confusing-and-not-as-helpful-as-it-could-be/60715/3

In short: `-opt` is an MLIR to MLIR optimizer, and `-translate` converts MLIR into a different IR (e.g., LLVM IR) so you can move to code generation.
