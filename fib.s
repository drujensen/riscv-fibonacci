fib:
    li t0, 2
    bge a0, t0, recursive
    ret
recursive:
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    mv s0, a0
    addi a0, s0, -1
    call fib
    mv s1, a0
    addi a0, s0, -2
    call fib
    add a0, s1, a0
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    addi sp, sp, 24
    ret

    .globl main
main:
    addi sp, sp, -8
    sd ra, 0(sp)
    li a0, 42
    call fib
    mv a1, a0
    la a0, format
    call printf@plt
    li a0, 0
    ld ra, 0(sp)
    addi sp, sp, 8
    ret
format:
    .asciz "%lu \n"
