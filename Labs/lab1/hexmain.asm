  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

# We use S-registers in assignement 3 on hexasc. therefore no s-register here

	.text
main:
	li	$a0, 19	# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
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
