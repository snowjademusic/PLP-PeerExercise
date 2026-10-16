# Linux (x86_64: Intel / AMD)

Setup and instructions to build and run "Hello, World!" in x86_64 Assembly on Linux.

## Source File

- [`helloworld_Linux_x86_64.asm`](helloworld_Linux_x86_64.asm)

## 1. Install NASM & Binutils

- **Debian-based systems** (Ubuntu, Pop!_OS, Mint, Debian):
  ```bash
  sudo apt update
  sudo apt install nasm binutils
  ```
- **Arch-based systems**:
  ```bash
  sudo pacman -S nasm binutils
  ```
- **Fedora / Red Hat**:
  ```bash
  sudo dnf install nasm binutils
  ```

## 2. Assemble, Link & Run

From this directory:

```bash
nasm -f elf64 helloworld_Linux_x86_64.asm -o helloworld.o
ld -s -o helloworld helloworld.o
./helloworld
```

Or from the repository root:

```bash
nasm -f elf64 HelloWorld/Linux/x86_64/helloworld_Linux_x86_64.asm -o helloworld.o
ld -s -o helloworld helloworld.o
./helloworld
```
