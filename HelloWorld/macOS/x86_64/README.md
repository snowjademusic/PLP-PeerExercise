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

```bash
nasm -f macho64 HelloWorld/macOS/x86_64/helloworld_macOS_x86_64.asm -o helloworld.o
clang helloworld.o -o helloworld
./helloworld
```

## 3. System Calls & Architecture Reference (for the Task)

On macOS x86_64 (Intel), system calls use the `syscall` instruction. macOS requires adding the BSD class offset `0x2000000` to the system call number in `rax`.

### Register Conventions

| Role | Register | Notes |
| :--- | :--- | :--- |
| **Syscall Number** | `rax` | Base syscall number + `0x2000000` |
| **Argument 1** | `rdi` | First parameter |
| **Argument 2** | `rsi` | Second parameter |
| **Argument 3** | `rdx` | Third parameter |
| **Argument 4** | `r10` | Fourth parameter |
| **Return Value** | `rax` | Result. Carry flag (`CF`) is set if an error occurred |

### Key System Calls

| Syscall | `rax` (with `0x2000000` offset) | `rdi` (arg 1) | `rsi` (arg 2) | `rdx` (arg 3) | Description |
| :--- | :---: | :--- | :--- | :--- | :--- |
| `sys_exit` | `0x2000001` | `status` (`0` = success) | — | — | Exit process |
| `sys_read` | `0x2000003` | `fd` (file descriptor) | `buf` (pointer to buffer) | `count` (bytes to read) | Read from file |
| `sys_write` | `0x2000004` | `fd` (`1` = stdout) | `buf` (pointer to data) | `count` (number of bytes) | Write to file/stream |
| `sys_open` | `0x2000005` | `path` (null-terminated string) | `flags` (`0` = `O_RDONLY`) | `mode` (`0`) | Open file |
| `sys_close` | `0x2000006` | `fd` (file descriptor) | — | — | Close file descriptor |

### Accessing Command-Line Arguments (`argv[1]`)

When linking with `clang`, execution begins at `_main`:

- `rdi` contains `argc` (integer count).
- `rsi` contains the pointer to the `argv` array (`char**`).
- The filename passed on the command line (`argv[1]`) is located at `[rsi + 8]`.

Example in NASM (`macho64`):

```nasm
global _main
default rel                     ; enable RIP-relative addressing by default

section .text
_main:
    ; Check if argc >= 2
    cmp rdi, 2
    jl .missing_arg

    ; Load argv[1] pointer into rdi
    mov rdi, [rsi + 8]          ; rdi = pointer to filename string

    ; sys_open(path=rdi, flags=0, mode=0)
    mov rax, 0x2000005          ; macOS sys_open
    xor rsi, rsi                ; O_RDONLY
    xor rdx, rdx                ; mode
    syscall
    jc .open_error              ; jump if Carry Flag is set (error)

    mov rbx, rax                ; save file descriptor in rbx
```

### Reading from the File

```nasm
section .bss
    buffer: resb 4096           ; 4 KB buffer

section .text
    ; sys_read(fd=rbx, buf=buffer, count=4096)
    mov rax, 0x2000003          ; macOS sys_read
    mov rdi, rbx                ; fd
    lea rsi, [rel buffer]       ; destination buffer (RIP-relative)
    mov rdx, 4096               ; bytes to read
    syscall
    jc .read_error
    ; rax contains number of bytes read
```

### Writing ANSI Escape Codes to stdout

```nasm
section .data
    red_block: db 0x1B, "[41m  ", 0x1B, "[0m"
    red_len equ $ - red_block

section .text
    ; sys_write(fd=1, buf=red_block, count=red_len)
    mov rax, 0x2000004          ; macOS sys_write
    mov rdi, 1                  ; stdout
    lea rsi, [rel red_block]    ; pointer to data
    mov rdx, red_len            ; length
    syscall
```
