; Build and link:
;   nasm -f elf64 displayfile.asm -o displayfile.o
;   ld -s displayfile.o -o displayfile
;
; Run:
;   ./displayfile example.txt
;
; Refer to task.md and HelloWorld/Linux/x86_64/README.md for instructions and system call details.

global _start

section .data
    ; Define ANSI escape sequences for colors here

section .bss
    ; Allocate buffer for reading file contents here

section .text
_start:
    ; 1. Check command-line arguments (argc, argv[1])
    ; 2. Open file (sys_open)
    ; 3. Read file into buffer (sys_read)
    ; 4. Parse characters and write ANSI escape codes to stdout (sys_write)
    ; 5. Close file (sys_close) and exit (sys_exit)