
# declare data space and string outputs
.data
    buffer: .space 64
    variable: .space 64
    input:  .space 4
    str1:  .asciiz "\n>>>"
    str2:  .asciiz "Invalid input\n"
    str3:  .asciiz "Valid input\n"
    str4:  .asciiz " = \n"
    character:  .space 4
.text

# output instructions and free variables as needed
main: 
    # output >>> display
    li $v0, 4       # Load for output
    la $a0, str1    # Load and print string asking for number
    syscall
    
    # save input from user
    li $v0, 8       	 # take in input
    la $a0, buffer  	 # load byte space into address
    li $a1, 64           # allot the byte space for string
    syscall
    
    # set variables needed for counting and load first character
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    
    # variables for use in counts
    la $t4, 0
    la $t5, 0
    la $t6, 0
    la $t7, 0
    la $t8, 0
    la $t0, 10
    
    j firstcharcheck
    
# end of main should not reach
li $v0, 10
syscall

# check that an operator exists and that it is not the first character entry
opcheck:
    beq $a2, $zero, equalscountcheck  # if no operators found then print invalid
    beq $a2, '=', equalscount      # if an operator is found 
    beq $a2, '(', checknumexception
    beq $a2, ')', checknumexception
    blt $a2, '(', validspacecheck
    bgt $a2, 'z', invalid
    blt $a2, '0', invalidcharacterchecknum
    blt $a2, 'A', invalidcharactercheckupper
    blt $a2, 'a', invalidcharacterchecklower
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j opcheck
    
validspacecheck:
    ble $a2, ' ', checknumexception
    j invalid
    
invalidcharacterchecknum:
    beq $a2, '*', checknumexception
    beq $a2, '/', checknumexception
    beq $a2, '-', checknumexception
    beq $a2, '+', checknumexception
    bgt $a2, ')', invalid
    j opcheck
   
checknumexception:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j opcheck

invalidcharactercheckupper:
    beq $a2, '=', checknumexception
    bgt $a2, '9', invalid
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j opcheck

invalidcharacterchecklower:
    bgt $a2, 'Z', invalid
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j opcheck
    
equalscount:
    addi $t8, $t8, 1
    bgt $t8, 1, invalid
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j opcheck
    
equalscountcheck:
    ble $t8 1, pass1
    j invalid

# check first variable and if there is none then print invalid
firstcharcheck:
    beq $a2, $zero, invalid
    beq $a2, '=', invalid
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, ')', invalid
    ble $a2, '9', firstnumcheck
    ble $a2, 'Z', firstlettercheckupper
    ble $a2, 'z', firstletterchecklower
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstcharcheck

# pass characters if variable is more then 1 character long
firstnumcheck:
    bge $a2, '0', pass5
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstcharcheck

firstletterchecklower: 
    bge $a2, 'a', pass5
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstcharcheck 
    
firstlettercheckupper: 
    bge $a2, 'A', pass5
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstcharcheck 

# check if entry has an operator
firstopcheck:
    beq $a2, '=', secopcheck
    beq $a2, '/', secopcheck
    beq $a2, '*', secopcheck
    beq $a2, '+', secopcheck
    beq $a2, '-', secopcheck
    beq $a2, $zero, pass2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstopcheck

# check for another operator that may be invalid
secopcheck:
    beq $a2, $zero, invalid
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, 0xa, invalid
    beq $a2, '=', invalid
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, ')', invalid
    beq $a2, ' ', argucheck
    j firstopcheck

# check if an argument variable is set
argucheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, $zero, invalid
    beq $a2, ')', invalid
    beq $a2, '=', invalid
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, ' ', argucheck
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j firstopcheck

pass1:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    j firstopcheck
    
pass2:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    j parthfind
 
pass3:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    j varcheck
    
pass4:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    j numcheck
    
pass5:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    j opcheck
    
pass6:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    lb $a3, ($t3) #gets first char of sentence
    mul $s2, $s2, $zero # first number
    mul $s3, $s3, $zero # second number
    mul $s4, $s4, $zero # third number
    mul $s5, $s5, $zero # fourth number
    mul $s6, $s6, $zero # fifth number
    mul $s7, $s7, $zero # result number
    mul $t4, $t4, $zero # first operator
    mul $t5, $t5, $zero # second operator
    mul $t6, $t6, $zero # third operator
    mul $t7, $t7, $zero # fourth operator
    mul $t0, $t0, $zero # operator count
    j variableoperators

# check that use of paranthese is valid. should be equal number of right and left
parthfind:
    beq $a2, $zero, parthcheck
    beq $a2, '(', leftparthcount
    beq $a2, ')', rightparthcount
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j parthfind

# count the number of left paranthese 
leftparthcount:
    addi $t4, $t4, 1
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j parthfind

# count the number of right paranthese
rightparthcount:
    addi $t5, $t5, 1
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j parthfind

# if both counts are equal than pass and if not then print invalid
parthcheck:
    beq $t4, $t5, pass3
    bne $t4, $t5, invalid

# check the number of variables in input. Should only be 1.  
varcheck:
    beq $a2, $zero, varnumcheck
    bge $a2, 'a', lettercheck
    bge $a2, 'A', lettercheck
    bge $a2, '0', numberscheck
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j varcheck
    
numberscheck: 
    ble $a2, '9', isoperators
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j varcheck

# being over aggresive 
isoperators:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, $zero, varnumcheck
    ble $a2, '9', numberscheck
    beq $a2, ' ', isoperatorsspace
    beq $a2, '=', varcheck
    beq $a2, '/', varcheck
    beq $a2, '*', varcheck
    beq $a2, '+', varcheck
    beq $a2, '-', varcheck
    j invalid
    
isoperatorsspace:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', isoperatorsspace
    beq $a2, '=', varcheck
    beq $a2, '/', varcheck
    beq $a2, '*', varcheck
    beq $a2, '+', varcheck
    beq $a2, '-', varcheck
    j invalid
   
# allow for multiletter variables
lettercheck:
    ble $a2, 'Z', spacecheck
    ble $a2, 'z', spacecheck
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j varcheck

# if first varible then check that it is valid. if varible at the end check for equals operator
spacecheck:
    beq $t6, 0, firstvarcheckright
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, 0xa, excepcheck
    beq $a2, ' ', varcount
    beq $a2, '=', varcount
    beq $a2, '/', varcount
    beq $a2, '*', varcount
    beq $a2, '+', varcount
    beq $a2, '-', varcount
    beq $a2, ')', varcount
    j varcheck
    
# make sure that given varible is valid and only contains letters
firstvarcheckright:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, $zero, varnumcheck
    beq $a2, 0xa, excepcheck
    beq $a2, ' ', firstvarcheckright
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, '=', varcount
    beq $a2, ')', bracketcheck
    bge $a2, '0', ignorenumcheck
    ble $a2, 'Z', ignorelettercheckupper
    ble $a2, 'z', ignoreletterchecklower
    j firstvarcheckleft

# if there are brackets make sure they are used in a valid way. Should not be within letters of variable.
bracketcheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ')', bracketcheck
    beq $a2, '=', varcount
    bge $a2, '0', invalidnum
    ble $a2, 'Z', invalidupper
    ble $a2, 'z', invalidlower
    beq $a2, '/', varcount
    beq $a2, '*', varcount
    beq $a2, '+', varcount
    beq $a2, '-', varcount
    beq $a2, 0xa, firstvarcheckright
    beq $a2, $zero, varnumcheck
    beq $a2, ' ', firstvarcheckright
    j invalid
    
invalidnum:
    ble $a2, '9', invalid
    j firstvarcheckright

invalidlower: 
    bge $a2, 'a', invalid
    j firstvarcheckright 
    
invalidupper: 
    bge $a2, 'A', invalid
    j firstvarcheckright 
    
# if number in varible without operative then input is invalid
ignorenumcheck:
    ble $a2, '9', invalid
    j firstvarcheckright

ignoreletterchecklower: 
    bge $a2, 'a', firstvarcheckright
    j invalid 
    
ignorelettercheckupper: 
    bge $a2, 'A', firstvarcheckright
    j invalid 

# if variable is at the end of input then check for equals operator. 
firstvarcheckleft:
    addi $t3, $t3, -1
    lb $a2, ($t3)
    beq $t3, 0x10010000, invalid
    beq $a2, '=', varnumcheck
    j firstvarcheckleft
    
# check that an equals operator is in the input with variable
excepcheck:
    addi $t3, $t3, -1
    lb $a2, ($t3)
    beq $t6, 1, invalid
    beq $t3, 0x10010000, invalid
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, '=', operatorfound
    j excepcheck
    
operatorfound:
   addi $t6, $t6, 1
   j varnumcheck

# check number of variables in the input
varcount:
    addi $t6, $t6, 1
    la $t8, ($t3)
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, '(', invalid
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    j varcheck

# if more than 1 variable print invalid. should only have 1 varible if using them. 
varnumcheck:
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    beq $t6, 1, pass4
    bgt $t6, 1, invalid
    blt $t6, 1, pass4
    
# if varible is found check that equals opeator exists
equalscheck:
    beq $a2, $zero, invalid  # if no operators found then print invalid
    beq $a2, '=', pass4 # if an operator is found 
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j equalscheck
    
# check that input contains a numerical value
numcheck:
    beq $a2, $zero, invalid
    bge $a2, '0', numuppercheck
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j numcheck

# contains a number between 0 and 9
numuppercheck:
    ble $a2, '9', pass6
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j numcheck
    
variableoperators:
    bge $a2, '0', variableoperatorvariableconfirm
    bge $a2, 'a', variableoperatorvariableconfirm
    bge $a2, 'A', variableoperatorvariableconfirm
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j variableoperators
    
variableoperatorvariableconfirm:
    ble $a2, '9', checkvariableexist
    beq $a2, $a3, found
    beq $a2, '(', found
    ble $a2, 'Z', confirmnoinvalidoperators
    ble $a2, 'z', confirmnoinvalidoperators
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j variableoperators
    
confirmnoinvalidoperators:
    addi $t3, $t3, -1
    lb $a2, ($t3)
    beq $a2, '/', invalid
    beq $a2, '*', invalid
    beq $a2, '+', invalid
    beq $a2, '-', invalid
    beq $a2, '=', invalid
    beq $a2, '(', found
    j confirmnoinvalidoperators
    
checkvariableexist:
    bge $t6, 1, invalid
    j found
    

# if input is valid print valid
found:
    la $a0, str3    # Load and print string asking for number
    li $v0, 4
    syscall
    
    la $t3, buffer
    lb $a2, ($t3) #gets first char of sentence
    la $t4, 0 # store variable
    la $t5, 0 # store up to 4 numbers
    la $t6, 0
    la $t7, 0
    la $t8, 0
    la $a3, variable
    li $v0,8                   # syscall for string read
    j startmath
   
# if input is not valid print invalid. 
invalid:
    la $a0, str2    # Load and print string asking for number
    li $v0, 4
    syscall
    j main

# detect if first character is a variable then store it for output
startmath:
    bge $a2, 'a', storevariablestart
    bge $a2, 'A', storevariablestart
    bge $a2, '0', storevariablestart
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j startmath
   
# look for variable if exisits else move to number storage
storevariablestart:
    ble $a2, '9', storenumbers
    ble $a2, 'Z', loadvariableaddress	
    ble $a2, 'z', loadvariableaddress
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j startmath
    
# save entire variable length until end marker
loadvariableaddress:
    lb $v0, 0($t3)
    beq $v0, '=', finishstore
    beq $v0, ')', finishstore
    beq $v0, ' ', finishstore
    sb $v0, 0($a3)
    addi $a3,$a3, 1               # advance destination pointer
    addi $t3, $t3, 1               # advance source pointer
    j loadvariableaddress
    
# output the variable to be used for assigned value
finishstore:         
    sb $zero,0($a3)            # add EOS
    la $a0, variable
    li $v0, 4
    syscall
    
    li $v0, 4       # Load for output
    la $a0, str4    # Load and print string asking for number
    syscall
    
    j storenumbers
    
# look for number to store in the first register
storenumbers:
    bge $a2, '0', firstnumberstorecheck
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j storenumbers
    
# confirm value is a number and move to storage
firstnumberstorecheck:
    ble $a2, '9', firstnumberstore
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j storenumbers
    
# convert ascii value into decimal then save to register. If another digit is found then move last digit to next left decimal place
firstnumberstore:
    addi $a2, $a2, -48
    mul $s2, $s2, 10
    add $s2, $s2, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspaces
    beq $a2, '(', skipspaces
    beq $a2, ')', skipspaces
    beq $a2, '-', secondnumberstorecheck
    beq $a2, '+', secondnumberstorecheck
    beq $a2, '*', secondnumberstorecheck
    beq $a2, '/', secondnumberstorecheck
    beq $a2, 0xa, nooperatoransswer
    beq $a2, $zero, nooperatoransswer
    j firstnumberstore
    
# when searching for a number ignore spaces and paranthesis until an operator is found then move on to save to next register
skipspaces:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspaces
    beq $a2, '(', skipspaces
    beq $a2, ')', skipspaces
    beq $a2, '-', secondnumberstorecheck
    beq $a2, '+', secondnumberstorecheck
    beq $a2, '*', secondnumberstorecheck
    beq $a2, '/', secondnumberstorecheck
    beq $a2, 0xa, nooperatoransswer
    beq $a2, $zero, nooperatoransswer
    j firstnumberstore
   
# look for next number variable
secondnumberstorecheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    bge $a2, '0', secondnumberstore
    j secondnumberstorecheck
    
# convert ascii value into decimal then save to register. If another digit is found then move last digit to next left decimal place
secondnumberstore:
    addi $a2, $a2, -48
    mul $s3, $s3, 10
    add $s3, $s3, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacessecond
    beq $a2, '(', skipspacessecond
    beq $a2, ')', skipspacessecond
    beq $a2, '-', thirdnumberstorecheck
    beq $a2, '+', thirdnumberstorecheck
    beq $a2, '*', thirdnumberstorecheck
    beq $a2, '/', thirdnumberstorecheck
    beq $a2, 0xa, oneoperatoranswerstart
    beq $a2, $zero, oneoperatoranswerstart
    j secondnumberstore
    
# when searching for a number ignore spaces and paranthesis until an operator is found then move on to save to next register
skipspacessecond:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacessecond
    beq $a2, '(', skipspacessecond
    beq $a2, ')', skipspacessecond
    beq $a2, '-', thirdnumberstorecheck
    beq $a2, '+', thirdnumberstorecheck
    beq $a2, '*', thirdnumberstorecheck
    beq $a2, '/', thirdnumberstorecheck
    beq $a2, 0xa, oneoperatoranswerstart
    beq $a2, $zero, oneoperatoranswerstart
    j secondnumberstore
    
thirdnumberstorecheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    bge $a2, '0', thirdnumberstore
    j thirdnumberstorecheck
    
# convert ascii value into decimal then save to register. If another digit is found then move last digit to next left decimal place
thirdnumberstore:
    addi $a2, $a2, -48
    mul $s4, $s4, 10
    add $s4, $s4, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesthird
    beq $a2, '(', skipspacesthird
    beq $a2, ')', skipspacesthird
    beq $a2, '-', fourthnumberstorecheck
    beq $a2, '+', fourthnumberstorecheck
    beq $a2, '*', fourthnumberstorecheck
    beq $a2, '/', fourthnumberstorecheck
    beq $a2, 0xa, twooperatoranswerstart
    beq $a2, $zero, twooperatoranswerstart
    j thirdnumberstore
    
# when searching for a number ignore spaces and paranthesis until an operator is found then move on to save to next register
skipspacesthird:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesthird
    beq $a2, '(', skipspacesthird
    beq $a2, ')', skipspacesthird
    beq $a2, '-', fourthnumberstorecheck
    beq $a2, '+', fourthnumberstorecheck
    beq $a2, '*', fourthnumberstorecheck
    beq $a2, '/', fourthnumberstorecheck
    beq $a2, 0xa, twooperatoranswerstart
    beq $a2, $zero, twooperatoranswerstart
    j thirdnumberstore
    
fourthnumberstorecheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    bge $a2, '0', fourthnumberstore
    j fourthnumberstorecheck
    
# convert ascii value into decimal then save to register. If another digit is found then move last digit to next left decimal place
fourthnumberstore:
    addi $a2, $a2, -48
    mul $s5, $s5, 10
    add $s5, $s5, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesfourth
    beq $a2, '(', skipspacesfourth
    beq $a2, ')', skipspacesfourth
    beq $a2, '-', fifthnumberstorecheck
    beq $a2, '+', fifthnumberstorecheck
    beq $a2, '*', fifthnumberstorecheck
    beq $a2, '/', fifthnumberstorecheck
    beq $a2, 0xa, threeoperatorstorestart
    beq $a2, $zero, threeoperatorstorestart
    j fourthnumberstore
    
# when searching for a number ignore spaces and paranthesis until an operator is found then move on to save to next register
skipspacesfourth:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesfourth
    beq $a2, '(', skipspacesfourth
    beq $a2, ')', skipspacesfourth
    beq $a2, '-', fifthnumberstorecheck
    beq $a2, '+', fifthnumberstorecheck
    beq $a2, '*', fifthnumberstorecheck
    beq $a2, '/', fifthnumberstorecheck
    beq $a2, 0xa, threeoperatorstorestart
    beq $a2, $zero, threeoperatorstorestart
    j fourthnumberstore
    
fifthnumberstorecheck:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    bge $a2, '0', fifthnumberstore
    j fifthnumberstorecheck
    
# convert ascii value into decimal then save to register. If another digit is found then move last digit to next left decimal place
fifthnumberstore:
    addi $a2, $a2, -48
    mul $s6, $s6, 10
    add $s6, $s6, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesfifth
    beq $a2, '(', skipspacesfifth
    beq $a2, ')', skipspacesfifth
    beq $a2, '-', invalid
    beq $a2, '+', invalid
    beq $a2, '*', invalid
    beq $a2, '/', invalid
    beq $a2, 0xa, fouroperatoranswerstart
    beq $a2, $zero, fouroperatoranswerstart
    j fourthnumberstore
    
    
# when searching for a number ignore spaces and paranthesis until an operator is found then move on to save to next register
skipspacesfifth:
    addi $t3, $t3, 1
    lb $a2, ($t3)
    beq $a2, ' ', skipspacesfifth
    beq $a2, '(', skipspacesfifth
    beq $a2, ')', skipspacesfifth
    beq $a2, '-', invalid
    beq $a2, '+', invalid
    beq $a2, '*', invalid
    beq $a2, '/', invalid
    beq $a2, 0xa, fouroperatoranswerstart
    beq $a2, $zero, fouroperatoranswerstart
    j fourthnumberstore
    
# simply output the decimal entered if no operator is found besides =
nooperatoransswer:
    li  $v0, 1
    add $a0, $s2, $zero
    syscall 
    
    j main
    
# store operator if found
oneoperatoranswerstart:
    la $t3, buffer
    lb $a2, ($t3)
    j oneoperatoranswer
    
oneoperatoranswer:
    beq $a2, '-', oneoperatorminus
    beq $a2, '+', oneoperatorplus
    beq $a2, '*', oneoperatormulti
    beq $a2, '/', oneoperatordiv
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j oneoperatoranswer
    
# perform operation then output
oneoperatorminus:
    sub $s6, $s2, $s3
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
oneoperatorplus:
    add $s6, $s2, $s3
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
oneoperatormulti:
    mulo $s6, $s2, $s3
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
oneoperatordiv:
    div  $s6, $s2, $s3
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerstart:
    la $t3, buffer
    lb $a2, ($t3)
    j twooperatoranswer
    
twooperatoranswer:
    beq $a2, '-', twooperatorsstore
    beq $a2, '+', twooperatorsstore
    beq $a2, '*', twooperatorsstore
    beq $a2, '/', twooperatorsstore
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j twooperatoranswer
    
twooperatorsstore:
    beq $t0, 1, twooperatorsstoresecond
    addi $t0, $t0, 1 
    add $t4, $t4, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j twooperatoranswer
    
twooperatorsstoresecond:
    add $t5, $t5, $a2
    j twooperatoranswerfinal
    
threeoperatorstorestart:
    la $t3, buffer
    lb $a2, ($t3)
    j threeoperatoranswer
    
threeoperatoranswer:
    beq $a2, '-', threeoperatorsstore
    beq $a2, '+', threeoperatorsstore
    beq $a2, '*', threeoperatorsstore
    beq $a2, '/', threeoperatorsstore
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j threeoperatoranswer
    
threeoperatorsstore:
    beq $t0, 1, threeoperatorsstoresecond
    beq $t0, 2, threeoperatorsstorethird
    addi $t0, $t0, 1 
    add $t4, $t4, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j threeoperatoranswer
    
threeoperatorsstoresecond:
    add $t5, $t5, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    addi $t0, $t0, 1
    j threeoperatoranswer
    
threeoperatorsstorethird:
    add $t6, $t6, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j threeoperatoranswerfinal
    
# order of operations used if multiple operators found branch out then detect order of operation again until result is found then output and loop back to main
threeoperatoranswerfinal:
    beq $t4, '*', threeoperatoranswerfinalmulti
    beq $t4, '/', threeoperatoranswerfinaldiv
    beq $t5, '*', threeoperatoranswerfinalmultipriority
    beq $t5, '/', threeoperatoranswerfinaldivpriority
    beq $t6, '*', threeoperatoranswerfinalmultiprioritylast
    beq $t6, '/', threeoperatoranswerfinaldivprioritylast
    beq $t4, '+', threeoperatoranswerfinaladd
    beq $t4, '-', threeoperatoranswerfinalsub
    beq $t5, '+', threeoperatoranswerfinaladdpriority
    beq $t6, '+', threeoperatoranswerfinaladdprioritylast
    j invalid	
    
threeoperatoranswerfinalmultiprioritylast:
    mulo $s6, $s4, $s5
    j threeoperatoranswerfinaloperativeprioritylaststart
    
threeoperatoranswerfinaldivprioritylast:
    div $s6, $s4, $s5
    j threeoperatoranswerfinaloperativeprioritylaststart
    
threeoperatoranswerfinaladdprioritylast:
    add $s6, $s4, $s5
    j threeoperatoranswerfinaloperativeprioritylaststart
    
threeoperatoranswerfinaloperativeprioritylaststart:
    beq $t4, '/', threeoperatoranswerfinaldivwithsecondfirstlast
    beq $t5, '*', threeoperatoranswerfinalmultiprioritywithsecondlast
    beq $t5, '/', threeoperatoranswerfinaldivprioritywithsecondlast
    beq $t4, '+', threeoperatoranswerfinaladdwithsecondfirstlast
    beq $t4, '-', threeoperatoranswerfinalsubwithsecondfirstlast
    beq $t5, '+', threeoperatoranswerfinaladdprioritywithsecondlast
    j invalid
    
threeoperatoranswerfinalmultiprioritywithsecondlast:
    mulo $s6, $s3, $s6
    j threeoperatoranswerfinaloperativeprioritylaststartsecond
    
threeoperatoranswerfinaldivprioritywithsecondlast:
    div $s6, $s3, $s6
    j threeoperatoranswerfinaloperativeprioritylaststartsecond
    
threeoperatoranswerfinaladdprioritywithsecondlast:
    add $s6, $s3, $s6
    j threeoperatoranswerfinaloperativeprioritylaststartsecond
    
threeoperatoranswerfinaldivwithsecondfirstlast:
    div $s7, $s2, $s3
    j threeoperatoranswerfinaloperativepriorityfirstlaststartsecond
    
threeoperatoranswerfinaladdwithsecondfirstlast:
    add $s7, $s2, $s3
    j threeoperatoranswerfinaloperativepriorityfirstlaststartsecond
    
threeoperatoranswerfinalsubwithsecondfirstlast:
    sub $s7, $s2, $s3
    j threeoperatoranswerfinaloperativepriorityfirstlaststartsecond
    
threeoperatoranswerfinaloperativeprioritylaststartsecond:
    beq $t4, '*', threeoperatoranswerfinalmultiprioritywithfirstlastanswer
    beq $t4, '/', threeoperatoranswerfinaldivprioritywithfirstlastanswer
    beq $t4, '+', threeoperatoranswerfinaladdprioritywithfirstlastanswer
    beq $t4, '-', threeoperatoranswerfinalsubprioritywithfirstlastanswer
    j invalid
    
threeoperatoranswerfinaloperativepriorityfirstlaststartsecond:
    beq $t5, '*', threeoperatoranswerfinalmultiprioritywithsecondlastanswer
    beq $t5, '/', threeoperatoranswerfinaldivprioritywithsecondlastanswer
    beq $t5, '+', threeoperatoranswerfinaladdprioritywithsecondlastanswer
    beq $t5, '-', threeoperatoranswerfinalsubprioritywithsecondlastanswer
    j invalid
    
threeoperatoranswerfinalmultiprioritywithfirstlastanswer:
    mulo $s6, $s6, $s2

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaldivprioritywithfirstlastanswer:
    div $s6, $s2, $s6

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdprioritywithfirstlastanswer:
    add $s6, $s6, $s2

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main

threeoperatoranswerfinalsubprioritywithfirstlastanswer:
    sub $s6, $s2, $s6

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalmultiprioritywithsecondlastanswer:
    mulo $s6, $s6, $s7

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaldivprioritywithsecondlastanswer:
    div $s6, $s7, $s6

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdprioritywithsecondlastanswer:
    add $s6, $s6, $s7

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalsubprioritywithsecondlastanswer:
    sub $s6, $s7, $s6

    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main

    
threeoperatoranswerfinalmultipriority:
    mulo $s6, $s3, $s4
    j threeoperatoranswerfinaloperativepriority
    
threeoperatoranswerfinaldivpriority:
    div $s6, $s3, $s4
    j threeoperatoranswerfinaloperativepriority
    
threeoperatoranswerfinaladdpriority:
    add $s6, $s3, $s4
    j threeoperatoranswerfinaloperativepriority
    
threeoperatoranswerfinaloperativepriority:
    beq $t4, '/', threeoperatoranswerfinaldivwithsecondfirstsecond
    beq $t6, '*', threeoperatoranswerfinalmultiprioritywithsecondlastsecond
    beq $t6, '/', threeoperatoranswerfinaldivprioritywithsecondlastsecond
    beq $t4, '+', threeoperatoranswerfinaladdwithsecondfirstsecond
    beq $t4, '-', threeoperatoranswerfinalsubwithsecondfirstsecond
    beq $t6, '+', threeoperatoranswerfinaladdprioritywithsecondlastsecond
    j invalid 
    
threeoperatoranswerfinaldivwithsecondfirstsecond: 
    div $s6, $s2, $s6
    j threeoperatoranswerfinaloperativeprioritylast
    
threeoperatoranswerfinaladdwithsecondfirstsecond:
    add $s6, $s2, $s6
    j threeoperatoranswerfinaloperativeprioritylast
    
threeoperatoranswerfinalsubwithsecondfirstsecond:
    sub $s6, $s2, $s6
    j threeoperatoranswerfinaloperativeprioritylast
    
threeoperatoranswerfinalmultiprioritywithsecondlastsecond:
    mulo $s6, $s6, $s5
    j threeoperatoranswerfinaloperativepriorityfirst
    
threeoperatoranswerfinaldivprioritywithsecondlastsecond:
    div $s6, $s6, $s5
    j threeoperatoranswerfinaloperativepriorityfirst
    
threeoperatoranswerfinaladdprioritywithsecondlastsecond:
    add $s6, $s6, $s5
    j threeoperatoranswerfinaloperativepriorityfirst
    
threeoperatoranswerfinaloperativeprioritylast:
    beq $t6, '/', threeoperatoranswerfinaldivwithsecondandfirst
    beq $t6, '+', threeoperatoranswerfinaladdwithsecondandfirst
    beq $t6, '-', threeoperatoranswerfinalsubwithsecondandfirst
    j invalid
    
threeoperatoranswerfinaloperativepriorityfirst:
    beq $t4, '/', threeoperatoranswerfinaldivwithsecondandthird
    beq $t4, '+', threeoperatoranswerfinaladdwithsecondandthird
    beq $t4, '-', threeoperatoranswerfinalsubwithsecondandthird
    j invalid
    
threeoperatoranswerfinaldivwithsecondandfirst:
    div $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdwithsecondandfirst:
    add $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalsubwithsecondandfirst:
    sub $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaldivwithsecondandthird:
    div $s6, $s2, $s6
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdwithsecondandthird:
    add $s6, $s2, $s6
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalsubwithsecondandthird:
    sub $s6, $s2, $s6
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalmulti:
    mulo $s6, $s2, $s3
    j threeoperatoranswerfinalmultisecondwithfirst
    
threeoperatoranswerfinaldiv:
    div $s6, $s2, $s3
    j threeoperatoranswerfinalmultisecondwithfirst
    
threeoperatoranswerfinaladd:
    add $s6, $s2, $s3
    j threeoperatoranswerfinalmultisecondwithfirst
    
threeoperatoranswerfinalsub:
    sub $s6, $s2, $s3
    j threeoperatoranswerfinalmultisecondwithfirst
    
threeoperatoranswerfinalmultisecondwithfirst:
    beq $t5, '*', threeoperatoranswerfinalmultiprioritywithfirst
    beq $t5, '/', threeoperatoranswerfinaldivprioritywithfirst
    beq $t6, '*', threeoperatoranswerfinalmultiprioritylastwithfirst
    beq $t6, '/', threeoperatoranswerfinaldivprioritylastwithfirst
    beq $t5, '+', threeoperatoranswerfinaladdprioritywithfirst
    beq $t5, '-', threeoperatoranswerfinalsubprioritywithfirst
    beq $t6, '+', threeoperatoranswerfinaladdprioritylastwithfirst
    
threeoperatoranswerfinalmultiprioritylastwithfirst:
    mulo $s7, $s4, $s5
    j threeoperatoranswerfinalmultithirdwithfirstsecond
    
threeoperatoranswerfinaldivprioritylastwithfirst:
    div $s7, $s4, $s5
    j threeoperatoranswerfinalmultithirdwithfirstsecond
    
threeoperatoranswerfinaladdprioritylastwithfirst:
    add $s7, $s4, $s5
    j threeoperatoranswerfinalmultithirdwithfirstsecond
    
threeoperatoranswerfinalmultithirdwithfirstsecond:
    beq $t5, '/', threeoperatoranswerfinaldivprioritywithfirstthird
    beq $t5, '+', threeoperatoranswerfinaladdprioritywithfirstthird
    beq $t5, '-', threeoperatoranswerfinalsubprioritywithfirstthird
    
threeoperatoranswerfinalsubprioritywithfirstthird:
    sub $s6, $s6, $s7
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaldivprioritywithfirstthird:
    div $s6, $s6, $s7
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdprioritywithfirstthird:
    add $s6, $s6, $s7
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalmultiprioritywithfirst:
    mulo $s6, $s6, $s4
    j threeoperatoranswerfinalmultithirdwithfirst
    
threeoperatoranswerfinaldivprioritywithfirst:
    div $s6, $s6, $s4
    j threeoperatoranswerfinalmultithirdwithfirst
    
threeoperatoranswerfinaladdprioritywithfirst:
    add $s6, $s6, $s4
    j threeoperatoranswerfinalmultithirdwithfirst
    
threeoperatoranswerfinalsubprioritywithfirst:
    sub $s6, $s6, $s4
    j threeoperatoranswerfinalmultithirdwithfirst
    
threeoperatoranswerfinalmultithirdwithfirst:
    beq $t6, '*', threeoperatoranswerfinalmultiprioritylastwithfirstsecond
    beq $t6, '/', threeoperatoranswerfinaldivprioritylastwithfirstsecond
    beq $t6, '+', threeoperatoranswerfinaladdprioritylastwithfirstsecond
    beq $t6, '-', threeoperatoranswerfinalsubprioritylastwithfirstsecond
    
threeoperatoranswerfinalmultiprioritylastwithfirstsecond:
    mulo $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaldivprioritylastwithfirstsecond:
    div $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinaladdprioritylastwithfirstsecond:
    add $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
threeoperatoranswerfinalsubprioritylastwithfirstsecond:
    sub $s6, $s6, $s5
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinal:
    beq $t4, '*', twooperatoranswerfinalmulti
    beq $t4, '/', twooperatoranswerfinaldiv
    beq $t5, '*', twooperatoranswerfinalmultipriority
    beq $t5, '/', twooperatoranswerfinaldivpriority
    beq $t4, '+', twooperatoranswerfinaladd
    beq $t4, '-', twooperatoranswerfinalsub
    beq $t5, '+', twooperatoranswerfinaladdpriority
    beq $t5, '-', twooperatoranswerfinalsubpriority
    j invalid
     
twooperatoranswerfinalsub:
    sub $s6, $s2, $s3
    j twooperatoranswerfinalmultisecond
    
twooperatoranswerfinalsubpriority:
    sub $s6, $s3, $s4
    j twooperatoranswerfinalmultisecondpriorty
    
twooperatoranswerfinaladd:
    add $s6, $s2, $s3
    j twooperatoranswerfinalmultisecond
    
twooperatoranswerfinaladdpriority:
    add $s6, $s3, $s4
    j twooperatoranswerfinalmultisecondpriorty
    
twooperatoranswerfinaldiv:
    div $s6, $s2, $s3
    j twooperatoranswerfinalmultisecond
    
twooperatoranswerfinaldivpriority:
    div $s6, $s3, $s4
    j twooperatoranswerfinalmultisecondpriorty
    
twooperatoranswerfinalmulti:
    mulo $s6, $s2, $s3
    j twooperatoranswerfinalmultisecond
    
twooperatoranswerfinalmultipriority:
    mulo $s6, $s3, $s4
    j twooperatoranswerfinalmultisecondpriorty
    
twooperatoranswerfinalmultisecondpriorty:
    beq $t4, '/', twooperatoranswerfinalmultidivpriorty
    beq $t4, '+', twooperatoranswerfinalmultipluspriorty
    beq $t4, '-', twooperatoranswerfinalmultiminuspriorty
    j invalid
    
twooperatoranswerfinalmultisecond:
    beq $t5, '*', twooperatoranswerfinalmultimulti
    beq $t5, '/', twooperatoranswerfinalmultidiv
    beq $t5, '+', twooperatoranswerfinalmultiplus
    beq $t5, '-', twooperatoranswerfinalmultiminus
    j invalid
    
twooperatoranswerfinalmultidivpriorty:
    div $s6, $s2, $s6
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultipluspriorty:
    add $s6, $s6, $s2
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultiminuspriorty:
    sub $s6, $s2, $s6
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultimulti:
    mulo $s6, $s6, $s4
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultidiv:
    div $s6, $s6, $s4
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultiplus:
    add $s6, $s6, $s4
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
twooperatoranswerfinalmultiminus:
    sub $s6, $s6, $s4
    
    li  $v0, 1
    add $a0, $s6, $zero # result
    syscall
    
    j main
    
fouroperatoranswerstart:
    la $t3, buffer
    lb $a2, ($t3)
    j fouroperatoranswer
    
fouroperatoranswer:
    beq $a2, '-', fouroperatorsstore
    beq $a2, '+', fouroperatorsstore
    beq $a2, '*', fouroperatorsstore
    beq $a2, '/', fouroperatorsstore
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j fouroperatoranswer
    
fouroperatorsstore:
    beq $t0, 1, fouroperatorsstoresecond
    beq $t0, 2, fouroperatorsstorethird
    beq $t0, 3, fouroperatorsstorefour
    addi $t0, $t0, 1 
    add $t4, $t4, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j fouroperatoranswer
    
fouroperatorsstoresecond: 
    add $t5, $t5, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    addi $t0, $t0, 1
    j fouroperatoranswer
    
fouroperatorsstorethird:
    add $t6, $t6, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    addi $t0, $t0, 1
    j fouroperatoranswer
    
fouroperatorsstorefour:
    add $t7, $t7, $a2
    addi $t3, $t3, 1
    lb $a2, ($t3)
    j fouroperatoranswerfinal
    
fouroperatoranswerfinal:
    beq $t4, '*', fouroperatorfirstoperatormulti
    beq $t4, '/', fouroperatorfirstoperatordiv
    beq $t4, '+', fouroperatorfirstoperatorplus
    beq $t4, '-', fouroperatorfirstoperatorsub
    j invalid
    
fouroperatorfirstoperatormulti:
    mulo $s7, $s2, $s3
    j fouroperatorsecondoperator
    
fouroperatorfirstoperatordiv:
    div $s7, $s2, $s3
    j fouroperatorsecondoperator
    
fouroperatorfirstoperatorplus:
    add $s7, $s2, $s3
    j fouroperatorsecondoperator
    
fouroperatorfirstoperatorsub:
    sub $s7, $s2, $s3
    j fouroperatorsecondoperator
    
fouroperatorsecondoperator:
    beq $t5, '*', fouroperatorsecondoperatormulti
    beq $t5, '/', fouroperatorsecondoperatordiv
    beq $t5, '+', fouroperatorsecondoperatorplus
    beq $t5, '-', fouroperatorsecondoperatorsub
    j invalid
    
fouroperatorsecondoperatormulti:
    mulo $s7, $s7, $s4
    j fouroperatorthirdoperator
    
fouroperatorsecondoperatordiv:
    div $s7, $s7, $s4
    j fouroperatorthirdoperator
    
fouroperatorsecondoperatorplus:
    add $s7, $s7, $s4
    j fouroperatorthirdoperator
    
fouroperatorsecondoperatorsub:
    sub $s7, $s7, $s4
    j fouroperatorthirdoperator
    
fouroperatorthirdoperator:
    beq $t6, '*', fouroperatorthirdoperatormulti
    beq $t6, '/', fouroperatorthirdoperatordiv
    beq $t6, '+', fouroperatorthirdoperatorplus
    beq $t6, '-', fouroperatorthirdoperatorsub
    j invalid
    
fouroperatorthirdoperatormulti:
    mulo $s7, $s7, $s5
    j fouroperatorfourthoperator
    
fouroperatorthirdoperatordiv:
    div $s7, $s7, $s5
    j fouroperatorfourthoperator
    
fouroperatorthirdoperatorplus:
    add $s7, $s7, $s5
    j fouroperatorfourthoperator
    
fouroperatorthirdoperatorsub:
    sub $s7, $s7, $s5
    j fouroperatorfourthoperator
    
fouroperatorfourthoperator:
    beq $t7, '*', fouroperatorfourthoperatormulti
    beq $t7, '/', fouroperatorfourthoperatordiv
    beq $t7, '+', fouroperatorfourthoperatorplus
    beq $t7, '-', fouroperatorfourthoperatorsub
    j invalid
    
fouroperatorfourthoperatormulti:
    mulo $s7, $s7, $s6
    
    li  $v0, 1
    add $a0, $s7, $zero # result
    syscall
    
    j main
    
fouroperatorfourthoperatordiv:
    div $s7, $s7, $s6
    
    li  $v0, 1
    add $a0, $s7, $zero # result
    syscall
    
    j main
    
fouroperatorfourthoperatorplus:
    add $s7, $s7, $s6
    
    li  $v0, 1
    add $a0, $s7, $zero # result
    syscall
    
    j main
    
fouroperatorfourthoperatorsub:
    sub $s7, $s7, $s6
     
    li  $v0, 1
    add $a0, $s7, $zero # result
    syscall
    
    j main

    
