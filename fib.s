	.file	"fib.c"
	.option pic
	.text
	.align	1
	.type	fib, @function
fib:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	ld	a4,-40(s0)
	li	a5,1
	bgtu	a4,a5,.L2
	ld	a5,-40(s0)
	j	.L3
.L2:
	ld	a5,-40(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	fib
	mv	s1,a0
	ld	a5,-40(s0)
	addi	a5,a5,-2
	mv	a0,a5
	call	fib
	mv	a5,a0
	add	a5,s1,a5
.L3:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	fib, .-fib
	.section	.rodata
	.align	3
.LC0:
	.string	"%lu \n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	ra,8(sp)
	sd	s0,0(sp)
	addi	s0,sp,16
	li	a0,42
	call	fib
	mv	a5,a0
	mv	a1,a5
	lla	a0,.LC0
	call	printf@plt
	li	a5,0
	mv	a0,a5
	ld	ra,8(sp)
	ld	s0,0(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
