# macOS (Apple Silicon: M1 / M2 / M3 / M4 - arm64)

Setup and instructions to build and run "Hello, World!" in ARM64 Assembly on macOS (Apple Silicon).

Apple Silicon Macs use ARM64 assembly with Apple's built-in `clang` toolchain (no external package manager required).

## Source File

[helloworld_macOS_arm64.s](helloworld_macOS_arm64.s)

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

```bash
clang HelloWorld/macOS/arm64/helloworld_macOS_arm64.s -o helloworld
./helloworld
```

## 3. System Calls & Architecture Reference (for the Task)

On macOS Apple Silicon (`arm64`), system calls are invoked via `svc #0`. The system call number is passed in register `x16`.

### Register Conventions

| Role | Register | Notes |
| :--- | :--- | :--- |
| **Syscall Number** | `x16` | Syscall ID (BSD system call number) |
| **Argument 1** | `x0` | First parameter |
| **Argument 2** | `x1` | Second parameter |
| **Argument 3** | `x2` | Third parameter |
| **Argument 4** | `x3` | Fourth parameter |
| **Return Value** | `x0` | Return value. Carry flag is set if an error occurred |

### Key System Calls

| Syscall | `x16` | `x0` (arg 1) | `x1` (arg 2) | `x2` (arg 3) | Description |
| :--- | :---: | :--- | :--- | :--- | :--- |
| `sys_exit` | `1` | `status` (`0` = success) | — | — | Exit program |
| `sys_read` | `3` | `fd` (file descriptor) | `buf` (pointer to buffer) | `count` (bytes to read) | Read from file descriptor |
| `sys_write` | `4` | `fd` (`1` = stdout) | `buf` (pointer to data) | `count` (number of bytes) | Write to file descriptor |
| `sys_open` | `5` | `path` (null-terminated string) | `flags` (`0` = `O_RDONLY`) | `mode` (`0`) | Open file |
| `sys_close` | `6` | `fd` (file descriptor) | — | — | Close file descriptor |

### Accessing Command-Line Arguments (`argv[1]`)

When compiling with `clang`, the program entry point is `_main` and arguments follow standard ABI:

- `x0` contains `argc` (integer count).
- `x1` contains the pointer to the `argv` array (`char**`).
- The filename passed on the command line (`argv[1]`) is located at `[x1, #8]`.

Example in macOS ARM64 assembly:

```s
.global _main
.align 2

.text
_main:
    // Check if argc >= 2
    cmp     x0, #2
    b.lt    missing_arg

    // Load argv[1] pointer into x0
    ldr     x0, [x1, #8]        // x0 = pointer to filename string

    // sys_open(path=x0, flags=0, mode=0)
    mov     x1, #0              // O_RDONLY
    mov     x2, #0              // mode
    mov     x16, #5             // sys_open
    svc     #0
    b.cs    open_error          // branch if Carry Set (error occurred)

    mov     x19, x0             // save file descriptor in x19
```

### Reading from the File

On Apple Silicon, use `adrp` + `add` with `@PAGE` and `@PAGEOFF` to reference data buffers:

```s
.data
.align 4
buffer: .space 4096

.text
    // sys_read(fd=x19, buf=buffer, count=4096)
    mov     x0, x19
    adrp    x1, buffer@PAGE
    add     x1, x1, buffer@PAGEOFF
    mov     x2, #4096
    mov     x16, #3             // sys_read
    svc     #0
    b.cs    read_error
    // x0 holds number of bytes read
```

### Writing ANSI Escape Codes to stdout

```s
.data
red_block:
    .ascii "\033[41m  \033[0m"
red_len = . - red_block

.text
    // sys_write(fd=1, buf=red_block, count=red_len)
    mov     x0, #1
    adrp    x1, red_block@PAGE
    add     x1, x1, red_block@PAGEOFF
    mov     x2, #red_len
    mov     x16, #4             // sys_write
    svc     #0
```
