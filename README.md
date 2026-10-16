# Peer Exercise: Assembly

## Getting Started

### Hello, World!s

To make sure your Assembly setup works and the code compiles on your machine, select the [Hello, World!](HelloWorld) program that fits your operating system and processor architecture.

| OS | Architecture | File |
| :--- | :--- | :--- |
| **Linux** | Intel / AMD (`x86_64`) | [helloworld_x86_64_Linux.asm](HelloWorld/helloworld_x86_64_Linux.asm) |
| **Linux** | ARM (`arm64` / `aarch64`) | [helloworld_Linux_arm64.s](HelloWorld/helloworld_Linux_arm64.s) |
| **macOS** | Apple Silicon (`arm64`: M1/M2/M3/M4) | [helloworld_macOS_arm64.s](HelloWorld/helloworld_macOS_arm64.s) |
| **macOS** | Intel (`x86_64`) | [helloworld_macOS_x86_64.asm](HelloWorld/helloworld_macOS_x86_64.asm) |
| **Windows** | x86_64 / ARM64 | (via WSL) |

___

#### Linux users

##### 1. Intel or AMD chip (`x86_64`)

Use this file: [helloworld_x86_64_Linux.asm](HelloWorld/helloworld_x86_64_Linux.asm)

**Install NASM & Binutils:**

- For Debian-based systems (Ubuntu, Pop!_OS, Mint, Debian):
  ```bash
  sudo apt update
  sudo apt install nasm binutils
  ```
- For Arch-based systems:
  ```bash
  sudo pacman -S nasm binutils
  ```
- For Fedora / Red Hat:
  ```bash
  sudo dnf install nasm binutils
  ```

**Assemble, Link & Run:**

```bash
nasm -f elf64 HelloWorld/helloworld_x86_64_Linux.asm -o helloworld.o
ld -s -o helloworld helloworld.o
./helloworld
```

##### 2. ARM chip (`arm64` / `aarch64` — e.g. Raspberry Pi, Asahi Linux, ARM VMs)

Use this file: [helloworld_Linux_arm64.s](HelloWorld/helloworld_Linux_arm64.s)

**Install GNU Assembler & Linker:**

- For Debian / Ubuntu:
  ```bash
  sudo apt update
  sudo apt install binutils gcc
  ```
- For Arch-based systems:
  ```bash
  sudo pacman -S binutils gcc
  ```

**Assemble, Link & Run:**

```bash
as HelloWorld/helloworld_Linux_arm64.s -o helloworld.o
ld -o helloworld helloworld.o
./helloworld
```
*(Alternatively, assemble and link directly with GCC: `gcc -nostdlib HelloWorld/helloworld_Linux_arm64.s -o helloworld`)*

___

#### Mac users

On macOS, your setup depends on whether you have an **Apple Silicon Mac** (M1, M2, M3, M4 chip) or an older **Intel Mac**.

First, make sure you have the Xcode Command Line Tools installed (if not already installed):

```bash
xcode-select --install
```

##### 1. Apple Silicon (`arm64`: M1 / M2 / M3 / M4)

Use this file: [helloworld_macOS_arm64.s](HelloWorld/helloworld_macOS_arm64.s)

Apple Silicon Macs use ARM64 assembly with Apple's built-in `clang` toolchain (no external package manager required).

**Assemble, Link & Run:**

```bash
clang HelloWorld/helloworld_macOS_arm64.s -o helloworld
./helloworld
```

*(Alternatively, using `as` and `ld` explicitly)*:
```bash
as HelloWorld/helloworld_macOS_arm64.s -o helloworld.o
ld -o helloworld helloworld.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _main -arch arm64
./helloworld
```

##### 2. Intel Mac (`x86_64`)

Use this file: [helloworld_macOS_x86_64.asm](HelloWorld/helloworld_macOS_x86_64.asm)

**Install NASM via Homebrew:**

```bash
brew install nasm
```

**Assemble, Link & Run:**

Assemble the 64-bit Mach-O object file with NASM, then link with `clang`:

```bash
nasm -f macho64 HelloWorld/helloworld_macOS_x86_64.asm -o helloworld.o
clang helloworld.o -o helloworld
./helloworld
```

*(Alternatively, using `ld` explicitly)*:
```bash
ld -o helloworld helloworld.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _main -arch x86_64
./helloworld
```

___

#### Windows users

The simplest and recommended environment for Assembly programming on Windows is **Windows Subsystem for Linux (WSL)**:

1. **Install WSL** (if you haven't already):
   Open PowerShell or Windows Terminal as Administrator and run:
   ```powershell
   wsl --install
   ```
   Restart your computer if prompted.

2. **Open your WSL distribution** (e.g. Ubuntu from the Start Menu or via Windows Terminal).

3. **Configure VS Code (optional):**
   If you use VS Code, install the **WSL** extension and open your terminal with the WSL profile.

4. **Clone the repository inside WSL:**
   ```bash
   git clone <repo-url>
   cd PLP-PeerExercise
   ```

5. **Build and Run:**
   Follow the [Linux users](#linux-users) instructions corresponding to your machine architecture (`x86_64` for standard Intel/AMD PCs).