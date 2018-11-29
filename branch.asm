	.data
newline: .asciiz "\n"
head: .asciiz "Fibonacci Numbers by, Nathan Sun\n\n"
getname: .asciiz "What is your name?:\n"
buffer: .space 64
inst: .asciiz "How many Fibonacci numbers should I display?\n"
inst2: .asciiz "Enter an integer in the range [1..47]: "
wronginput: .asciiz "That number was out of range, try again.\n\n"
greeting: .asciiz "Hi, "
space: .asciiz "    "
#amount: .word
.eqv lower_limit 1
.eqv upper_limit 47
end: .asciiz "Goodbye, "

		
	.text
	#print the heading
	la   $a0, head
	li   $v0, 4
	syscall		

	#prompt for name
	la   $a0, getname
	li   $v0, 4
	syscall
	
	#get name and store in name	
	li $v0, 8 #take in input
        la $a0, buffer #load byte space into address
        li $a1, 20 # allot the byte space for string
        move $t0, $a0 #save string to t0
        syscall
	
	#print greeting
	la   $a0, greeting
	li   $v0, 4
	syscall
	
	#print name
	la $a0, buffer #reload byte space to primary address
        move $a0, $t0 # primary address = t0 address (load pointer)
        li $v0, 4 # print string
        syscall
	
	#print an extra new line
	la   $a0, newline
	li   $v0, 4
	syscall

	#print inst "How many...."
loop:	la   $a0, inst
	li   $v0, 4
	syscall
	
	#print second line of instr "Enter an int...."
	la   $a0, inst2
	li   $v0, 4
	syscall
	
	#get the number
	li $v0, 5
	syscall
	move $t1, $v0 		#NUMBER stored in $t1
	
	#check if less than 0
	blez $t1, op1
	
	#check is greater than upper_limit
	
	
	#if valid entry, then jmp to next segment
	j fib
	
	#invalid input so print corresponding statement
op1:	la   $a0, wronginput
	li   $v0, 4
	syscall
	
	j loop
	
fib:	li $v0, 1		#load print int opcode
	li $a0, 0		#load 0
	syscall			#print first fib num 0
	
	la   $a0, space		#print 4 spaces
	li   $v0, 4
	syscall
	
	li $a1, 0		#will hold prev
	li $a2, 1		#will hold cur
				#$a3 will be next and $a4 can be buffer
	
	li $v0, 1		#load print int opcode
	li $a0, 1		#load 1
	syscall			#print second fib num 1
	
	la   $a0, space		#print 4 spaces
	li   $v0, 4
	syscall
	
	subi $t3, $t1, 2	#we put the number of fib nums to cal in $t3
	li $t4, 2		#whenever $t4 is divisible by 5, print newline
	li $t5, 5		#load $t5 to be 5 to div
	
fiblp:	#fib loop
	add $a3, $a1, $a2
	move $a1, $a2		#make prev = cur
	move $a2, $a3		#make cur = next
	addi $t4, $t4, 1	#increase $t4 by 1 to check if print newline
	div  $t4, $t5		#divide $t4 by 5 and check HI for remainder
	mfhi $t6		#move remainder to $t6
	bne $t6, 0, notz
	j isz
	
notz: 	la $a0, ($a3)		#load next fib #
	li $v0, 1		#load print int opcode
	syscall			#print next fib #
	
	la   $a0, space		#print 4 spaces
	li   $v0, 4
	syscall
	
	subi $t3, $t3, 1	#decrement nun of fib nums by 1
	bne $t3, 0, fiblp
	j ending
	
isz:	la $a0, ($a3)		#load next fib #
	li $v0, 1		#load print int opcode
	syscall			#print next fib #
	
	la   $a0, newline	#print a new line
	li   $v0, 4
	syscall
	
	subi $t3, $t3, 1	#decrement nun of fib nums by 1
	bne $t3, 0, fiblp
	j ending
	
	
	#fib loop is over, time to print the ending
	#print an extra new line
ending:	la   $a0, newline
	li   $v0, 4
	syscall
	
	#print the ending
	la   $a0, end
	li   $v0, 4
	syscall

	#print name
	la $a0, buffer #reload byte space to primary address
        move $a0, $t0 # primary address = t0 address (load pointer)
        li $v0, 4 # print string
        syscall
	
