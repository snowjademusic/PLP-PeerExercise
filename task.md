# Task: Terminal Color Art Viewer

In this task, you will create an Assembly program that reads a text file containing a letter-based drawing using ANSI Escape Codes.
The Task will teach you a lot about syscalls, registers and ,akes you think about the stack pointer whenever you call a function.

---

## Objective (pass criteria)

Your program must:

1. **Accept a filename as a command-line argument** (e.g. `./displayfile example.txt`).
2. **Open and read the file** from disk into memory.
3. **Parse the characters** and map specific letters to terminal colors:
   - `R` $\rightarrow$ **Red**
   - `G` $\rightarrow$ **Green**
   - `B` $\rightarrow$ **Blue**
   - `Y` $\rightarrow$ **Yellow**
   - `V` $\rightarrow$ **Violet / Magenta**
   - `W` $\rightarrow$ **White**
   - `0` $\rightarrow$ **Black**
   - *(Optional / Bonus)* Add your own colors! (e.g. `C` for Cyan, `O` for Orange, `P` for Pink).
4. **Preserve formatting 1-to-1**:
   - Newlines (`\n` / ASCII `10`) must be output as newlines so lines and rows match the input file.
   - Any unmapped characters and spaces should be skipped, so that even normal texts produce a cool image!
5. **Print the result to the terminal** using ANSI escape codes and exit cleanly.

---

## 💻 Example Call & Output

The repository includes an example file: [`example.txt`](example.txt) containing an 8×8 checkered pattern of Green and Red:

```text
GRGRGRGR
RGRGRGRG
GRGRGRGR
RGRGRGRG
GRGRGRGR
RGRGRGRG
GRGRGRGR
RGRGRGRG
```

### Running Your Program

```bash
./displayfile example.txt
```

### Expected Output

Your terminal will display a checkered board of green and red square blocks:

```bash
🟩🟥🟩🟥🟩🟥🟩🟥
🟥🟩🟥🟩🟥🟩🟥🟩
🟩🟥🟩🟥🟩🟥🟩🟥
🟥🟩🟥🟩🟥🟩🟥🟩
🟩🟥🟩🟥🟩🟥🟩🟥
🟥🟩🟥🟩🟥🟩🟥🟩
🟩🟥🟩🟥🟩🟥🟩🟥
🟥🟩🟥🟩🟥🟩🟥🟩
```

---

## ANSI Escape Codes Reference

ANSI escape sequences control the color and formatting of text in terminal emulators. An escape sequence begins with the ASCII **ESC** character:

- Hex: `0x1b`
- Decimal: `27`
- Octal: `\033`

Followed by `[` and formatting parameters ending in `m`.

### Recommended Rendering Style: Background Color Blocks

Terminal characters are typically about twice as tall as they are wide. To produce square-like "pixels", the standard technique is to print **two spaces with a background color**, then reset:

$$\text{ESC} + \text{"[<colorcode>m\_\_"} + \text{ESC} + \text{"[0m"}$$

For example, Red is `0x1b, "[41m  ", 0x1b, "[0m"`.

### Color Codes Table

| Letter | Color | Foreground Code | Background Code | Recommended Background Block (Escape Sequence) | NASM Byte Definition (`.data`) |
| :---: | :---: | :---: | :---: | :---: | :---: |
| `R` | **Red** | `0x1b[31m` | `0x1b[41m` | `0x1b[41m  0x1b[0m` | `db 0x1B, "[41m  ", 0x1B, "[0m"` |
| `G` | **Green** | `0x1b[32m` | `0x1b[42m` | `0x1b[42m  0x1b[0m` | `db 0x1B, "[42m  ", 0x1B, "[0m"` |
| `B` | **Blue** | `0x1b[34m` | `0x1b[44m` | `0x1b[44m  0x1b[0m` | `db 0x1B, "[44m  ", 0x1B, "[0m"` |
| `Y` | **Yellow** | `0x1b[33m` | `0x1b[43m` | `0x1b[43m  0x1b[0m` | `db 0x1B, "[43m  ", 0x1B, "[0m"` |
| `V` | **Violet / Magenta** | `0x1b[35m` | `0x1b[45m` | `0x1b[45m  0x1b[0m` | `db 0x1B, "[45m  ", 0x1B, "[0m"` |
| `W` | **White** | `0x1b[37m` | `0x1b[47m` | `0x1b[47m  0x1b[0m` | `db 0x1B, "[47m  ", 0x1B, "[0m"` |
| `0` | **Black** | `0x1b[30m` | `0x1b[40m` | `0x1b[40m  0x1b[0m` | `db 0x1B, "[40m  ", 0x1B, "[0m"` |
| *(Reset)* | *Default* | `0x1b[39m` | `0x1b[49m` | `0x1b[0m` | `db 0x1B, "[0m"` |

---

## Step-by-Step Implementation Guide

1. **Check Command-Line Arguments (`argc`, `argv`):**
   - Ensure the user passed at least one argument.
   - Obtain the pointer to the filename (`argv[1]`).
   - If missing, print a friendly error or usage message: `./displayfile <file.txt>` and exit.

2. **Open the File:**
   - Call the `sys_open` (or `sys_openat`) system call with read-only flags (`O_RDONLY = 0`).
   - Verify the returned file descriptor (FD). A negative return value indicates an error (e.g. file does not exist).

3. **Read File Content:**
   - Call `sys_read` to read bytes from the file descriptor into a buffer allocated in `.bss` or on the stack.
   - Note the number of bytes read returned by the system call.

4. **Iterate and Render:**
   - Loop over each byte in the buffer:
     - If it is `'R'`, write the red ANSI escape sequence.
     - If it is `'G'`, write the green ANSI escape sequence.
     - ... (repeat for `'B'`, `'Y'`, `'V'`, `'W'`, `'0'`, and your custom colors).
     - If it is a newline (`\n` = `10`), write a newline byte directly to `stdout`.
     - For spaces or any other characters, handle them appropriately (e.g. print two regular spaces or reset color).

5. **Clean Up and Exit:**
   - Call `sys_close` with the file descriptor.
   - Reset the terminal attributes with `0x1b[0m` (good practice to avoid leaving the user's terminal colored).
   - Call `sys_exit` with return code `0`.

---

## System & Architecture Guides

System call numbers, register conventions, and argument passing vary across operating systems and CPU architectures. Check the specific guide for your machine:

- **Linux (Intel / AMD x86_64):**
  - [Guide & Syscall Reference](HelloWorld/Linux/x86_64/README.md)
  
- **Linux (ARM64 / aarch64):**
  - [Guide & Syscall Reference](HelloWorld/Linux/arm64/README.md)
- **macOS (Apple Silicon M1/M2/M3/M4 arm64):**
  - [Guide & Syscall Reference](HelloWorld/macOS/arm64/README.md)
- **macOS (Intel x86_64):**
  - [Guide & Syscall Reference](HelloWorld/macOS/x86_64/README.md)
- **Windows (WSL):**
  - [Windows Setup Guide](HelloWorld/Windows/README.md)
