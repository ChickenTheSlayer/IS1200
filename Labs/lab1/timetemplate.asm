  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop
	
time2string:  PUSH $a0
        PUSH $s0
        PUSH $s1
        PUSH $ra

        move $s0, $a0
        addi $s1, $0, 0        #s1 = i
        li   $t1, 0x0000f000    #t1 contains masking number
        addi $t2, $0, 12    #t2 contains shift number 

        loop:    add $t3, $s1, $s0    #t3 goes from base address
            beq $s1, 5, zerobyte    #i = 5 -> done
            nop
            beq $s1, 2, semicolon    #i = 2 -> put the semicolon in
            nop
            and $t0, $a1, $t1
            srlv $a0, $t0, $t2
            add $t3, $s1, $s0
            jal hexasc
            nop
            move $t0, $v0
            sb $t0, 0($t3)
            addi $s1, $s1, 1    #i++
            srl $t1, $t1, 4        #t1 > 0x0f00 > 0x00f0 > 0x000f
            addi $t2, $t2, -4    #t2 = t2 - 4
            j loop
            nop

        semicolon: li $t0, 0x3a
               sb $t0, 0($t3)
               addi $s1, $s1, 1
               j loop
               nop

        zerobyte: li $t0, 0x0
              sb $t0, 0($t3)

        andi $t4, $a1, 0x00ff
        beq $t4, 0, DING
        nop
        j Done
        nop

        DING:     li $t0, 0x44    #D
            sb $t0, 0($s0)
            li $t0, 0x49    #I
            sb $t0, 1($s0)
            li $t0, 0x4e    #N
            sb $t0, 2($s0)
            li $t0, 0x47    #G
            sb $t0, 3($s0)
            li $t0, 0x0
            sb $t0, 4($s0)
            sb $0, 5($s0)    #Clears unused space
        Done:
            POP $ra
            POP $s1
            POP $s0
            POP $a0

        jr $ra
        nop
	
delay:

# Test run
	PUSH ($ra)
	
	li $t2, 10000 #constant written according to computer

	move $t1, $a0 #


	while:

	# ms > 0;
	ble $t1, 0, exit
	
	nop
		
	# ms = ms - 1;
	sub $t1, $t1, 1
		
	li $t0, 0 #int i
	
		for:
		
		# i < constant
		beq $t0, $t2, while
		nop
		addi $t0, $t0, 1
			
		j for
		nop

exit:
	POP $ra
	jr $ra
	nop


  # you can write your code for subroutine "hexasc" below this line
  #
hexasc:
  	andi $t0,$a0,0x0f		# $a0 & 0x0000000f -> ignore all bits but the bits in least significant end
  
 	ble $t0,9,hexnumbers 		# branch if content of $t0 <= 9, else continue
 	nop
 	ble $t0,31,hexletters		# branch if conten of $t0 <= 15, else continue
 	nop						# check if this is needed, might be better to jr $ra
  
  	hexnumbers:			# if below or equal to 9
  		addi $v0,$t0,0x30	# $t0 | 0x00 00 00 30 -> add 0x30 to what's input -> we get "ascii"
  		jr $ra			# numbers 0 through 9 (0 through 9 decimal)
  		nop
  	
 	hexletters:			# if above 9 but below or equal to 15
 		addi $v0,$t0,0x37	# $t0 | 0x00 00 00 37 -> add 0x37 to what's input -> we get "ascii"
 		jr $ra			# letters accepted are A through F (10 through 15 decimal)
 		nop
