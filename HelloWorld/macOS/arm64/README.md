# macOS (Apple Silicon: M1 / M2 / M3 / M4 - arm64)

Setup and instructions to build and run "Hello, World!" in ARM64 Assembly on macOS (Apple Silicon).

Apple Silicon Macs use ARM64 assembly with Apple's built-in `clang` toolchain (no external package manager required).

## Source File

- [`helloworld_macOS_arm64.s`](helloworld_macOS_arm64.s)

## 1. Prerequisites

Make sure you have the Xcode Command Line Tools installed:

```bash
xcode-select --install
```

## 2. Assemble, Link & Run

From this directory:

```bash
clang helloworld_macOS_arm64.s -o helloworld
./helloworld
```

*(Alternatively, using `as` and `ld` explicitly)*:

```bash
as helloworld_macOS_arm64.s -o helloworld.o
ld -o helloworld helloworld.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _main -arch arm64
./helloworld
```

Or from the repository root:

```bash
clang HelloWorld/macOS/arm64/helloworld_macOS_arm64.s -o helloworld
./helloworld
```
