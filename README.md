# MLIR Practice
A practice repo for creating a standalone MLIR dialect.

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
- `lib/`: TODO
- `python/`: TODO
- `standalone-opt/`: TODO
- `standalone-plugin/`: TODO
- `standalone-translate/`: TODO
- `test/`: TODO
- `build.sh`: The compilation script.
- `CMakeLists.txt`: Defines how CMake should build the project.
- `LICENSE.TXT`: LLVM's licence.
- `README.md`: This file.
