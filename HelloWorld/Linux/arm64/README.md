# Linux (ARM64 / aarch64)

Setup and instructions to build and run "Hello, World!" in ARM64 Assembly on Linux (e.g. Raspberry Pi, Asahi Linux, ARM VMs).

## Source File

- [`helloworld_Linux_arm64.s`](helloworld_Linux_arm64.s)

## 1. Install GNU Assembler & Linker

- **Debian / Ubuntu**:
  ```bash
  sudo apt update
  sudo apt install binutils gcc
  ```
- **Arch-based systems**:
  ```bash
  sudo pacman -S binutils gcc
  ```

## 2. Assemble, Link & Run

From this directory:

```bash
as helloworld_Linux_arm64.s -o helloworld.o
ld -o helloworld helloworld.o
./helloworld
```

*(Alternatively, assemble and link directly with GCC: `gcc -nostdlib helloworld_Linux_arm64.s -o helloworld`)*

Or from the repository root:

```bash
as HelloWorld/Linux/arm64/helloworld_Linux_arm64.s -o helloworld.o
ld -o helloworld helloworld.o
./helloworld
```
