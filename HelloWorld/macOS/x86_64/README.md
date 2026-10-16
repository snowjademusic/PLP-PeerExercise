# macOS (Intel: x86_64)

Setup and instructions to build and run "Hello, World!" in x86_64 Assembly on Intel macOS.

## Source File

- [`helloworld_macOS_x86_64.asm`](helloworld_macOS_x86_64.asm)

## 1. Prerequisites & Installation

Make sure you have the Xcode Command Line Tools installed:

```bash
xcode-select --install
```

Install NASM via Homebrew:

```bash
brew install nasm
```

## 2. Assemble, Link & Run

Assemble the 64-bit Mach-O object file with NASM, then link with `clang`:

From this directory:

```bash
nasm -f macho64 helloworld_macOS_x86_64.asm -o helloworld.o
clang helloworld.o -o helloworld
./helloworld
```

*(Alternatively, using `ld` explicitly)*:

```bash
ld -o helloworld helloworld.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _main -arch x86_64
./helloworld
```

Or from the repository root:

```bash
nasm -f macho64 HelloWorld/macOS/x86_64/helloworld_macOS_x86_64.asm -o helloworld.o
clang helloworld.o -o helloworld
./helloworld
```
