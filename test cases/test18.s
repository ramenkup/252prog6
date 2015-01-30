# printStats puts two values at the top two spots in its stack.  This is where 
#    the number of homeruns and outs were placed when printStats 
#    is called.  A function is allowed to change its own stack.

# Changes the $s registers used by main. The average function should be
#    getting arguments from the $a registers and the stack, and not relying
#    on what is in the $s registers.

# From test12:
# Tests if $t registers are preserved (if needed) by average.
# printStats puts values into every $t register.

# From test13:
# Tests if $a registers used correctly when average calls printStats.
# printStats changes the contents of $a1, $a2, and $a3 before returning

# test with three batters, both average and slugging percentage
# First batter has no hits, but does have outs
# Second batter has hits and outs, with realistic values
# Third hitter has large values for some of the hits and for the
#    outs. This means the hits and outs *have* to be converted from int's
#    to float's in order to get the right answer.

.data

mainNumBatters:
   .word 3

mainBatter1:
   .word  27      # walks
   .word   0      # singles
   .word   0      # doubles
   .word   0      # triples
   .word   0      # home runs
   .word 423      # outs
mainBatter2:
   .word  27      # walks
   .word 101      # singles
   .word  22      # doubles
   .word   4      # triples
   .word  10      # home runs
   .word 423      # outs

mainBatter3:
   .word   102322 # walks
   .word  8000000 # singles
   .word       22 # doubles
   .word   500000 # triples
   .word       10 # home runs
   .word 23000000 # outs


.data
mainNewline:
         .asciiz  "\n"
mainBatterNumber:
         .asciiz  "Batter number: "
mainBattingAverage:
         .asciiz  "Batting average: "
mainSluggingPercentage:
         .asciiz  "Slugging percentage: "
mainOnbasePercentage:
         .asciiz  "On-base percentage: "

.text

main:
         # Function prologue -- even main has one
         addiu $sp, $sp, -24     # allocate stack space -- default of 24 here
         sw    $fp, 0($sp)       # save frame pointer of caller
         sw    $ra, 4($sp)       # save return address
         addiu $fp, $sp, 20      # setup frame pointer of main
         
         # for (i = 0; i < mainNumBatters; i++)
         #    compute batting average
         #    compute slugging average
         
         la    $s1, mainNumBatters
         lw    $s6, 0($s1)       # $s6 = number of batters
         addi  $s0, $zero, 0     # $s0 = i = 0
         la    $s1, mainBatter1  # $s1 = addr of current batter's stats

mainLoopBegin:         
         slt   $t0, $s0, $s6     # $t0 = i < number of batters
         beq   $t0, $zero, mainDone

         la    $a0, mainBatterNumber
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $s0, 1
         addi  $v0, $zero, 1
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall

         # Compute the batting average
         addi  $a0, $zero, 1      # $a0 = 1 = compute batting average
         lw    $a1,   0($s1)      # $a1 = walks
         lw    $a2,   4($s1)      # $a2 = singles
         lw    $a3,   8($s1)      # $a3 = doubles
         lw    $s2,  12($s1)      # $s2 = triples
         lw    $s3,  16($s1)      # $s3 = home runs
         lw    $s4,  20($s1)      # $s4 = outs
         
         sw    $s4,  -4($sp)      # put outs at top of average's stack
         sw    $s3,  -8($sp)      # put homeruns 2nd fm top of average's stack
         sw    $s2, -12($sp)      # put triples 3rd fm top of average's stack
         jal   average
         
         # Print the batting average
         mtc1  $v0, $f12          # get result fm $v0 before we print string
         la    $a0, mainBattingAverage
         addi  $v0, $zero, 4
         syscall
         addi  $v0, $zero, 2      # print the average
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
         syscall
         
         # do it for the slugging percentage
         addi  $a0, $zero, 2      # $a0 = 2 = compute slugging average
         lw    $a1,   0($s1)      # $a1 = walks
         lw    $a2,   4($s1)      # $a2 = singles
         lw    $a3,   8($s1)      # $a3 = doubles
         lw    $s2,  12($s1)      # $s2 = triples
         lw    $s3,  16($s1)      # $s3 = home runs
         lw    $s4,  20($s1)      # $s4 = outs

         sw    $s4,  -4($sp)      # put outs at top of average's stack
         sw    $s3,  -8($sp)      # put homeruns 2nd fm top of average's stack
         sw    $s2, -12($sp)      # put triples 3rd fm top of average's stack
         jal   average
         
         # Print the slugging percentage
         mtc1  $v0, $f12          # get result fm $v0 before we print string
         la    $a0, mainSluggingPercentage
         addi  $v0, $zero, 4
         syscall
         addi  $v0, $zero, 2      # print the percentage
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
         syscall

         # do it again for the on-base percentage
         addi  $a0, $zero, 3      # $a0 = 3 = compute slugging average
         lw    $a1,   0($s1)      # $a1 = walks
         lw    $a2,   4($s1)      # $a2 = singles
         lw    $a3,   8($s1)      # $a3 = doubles
         lw    $s2,  12($s1)      # $s2 = triples
         lw    $s3,  16($s1)      # $s3 = home runs
         lw    $s4,  20($s1)      # $s4 = outs

         sw    $s4,  -4($sp)      # put outs at top of average's stack
         sw    $s3,  -8($sp)      # put homeruns 2nd fm top of average's stack
         sw    $s2, -12($sp)      # put triples 3rd fm top of average's stack

         jal   average
         
         # Print the slugging percentage
         mtc1  $v0, $f12          # get result fm $v0 before we print string
         la    $a0, mainOnbasePercentage
         addi  $v0, $zero, 4
         syscall
         addi  $v0, $zero, 2      # print the percentage
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
         syscall

         addi  $s0, $s0, 1       # i++
         addi  $s1, $s1, 24      # $s1 = addr of next batter's stats
         j     mainLoopBegin
         
mainDone:
         # Epilogue for main -- restore stack & frame pointers and return
         lw    $ra, 4($sp)       # get return address from stack
         lw    $fp, 0($sp)       # restore frame pointer for caller
         addiu $sp, $sp, 24      # restore frame pointer for caller
         jr    $ra               # return to caller

.data
printStatsOuts:
         .asciiz "Outs:      "
printStatsWalks:
         .asciiz "Walks:     "
printStatsSingles:
         .asciiz "Singles:   "
printStatsDoubles:
         .asciiz "Doubles:   "
printStatsTriples:
         .asciiz "Triples:   "
printStatsHomeruns:
         .asciiz "Home runs: "
printStatsNewline:
         .asciiz "\n"

.text
printStats:
         # Function prologue
         addiu $sp, $sp, -32     # allocate stack space
         sw    $a3, 20($sp)      # save $a0 thru $a3
         sw    $a2, 16($sp)
         sw    $a1, 12($sp)
         sw    $a0, 8($sp)
         sw    $ra, 4($sp)       # save return address
         sw    $fp, 0($sp)       # save frame pointer of caller
         addiu $fp, $sp, 28      # setup frame pointer of average

         # printStats expects to find the following:
         # $a0 = walks
         # $a1 = singles
         # $a2 = doubles
         # $a3 = triples
         # 5th argument = homeruns
         # 6th argument = outs
         
         # print the outs
         la    $a0, printStatsOuts
         addi  $v0, $zero, 4
         syscall
         lw    $a0, 0($fp)       # the outs are at the top of our stack
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall

         # print the walks
         la    $a0, printStatsWalks
         addi  $v0, $zero, 4
         syscall
         lw    $a0, 8($sp)       # the walks were passed in $a0
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall

         # print the singles
         la    $a0, printStatsSingles
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $a1, 0        # the singles were passed in $a1
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall
         
         # print the doubles
         la    $a0, printStatsDoubles
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $a2, 0        # the doubles were passed in $a2
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall
         
         # print the triples
         la    $a0, printStatsTriples
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $a3, 0        # the doubles were passed in $a3
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall
         
         # print the homeruns
         la    $a0, printStatsHomeruns
         addi  $v0, $zero, 4
         syscall
         lw    $a0, -4($fp)       # the homeruns are 4 bytes below the top of our stack
         addi  $v0, $zero, 1
         syscall
         la    $a0, printStatsNewline
         addi  $v0, $zero, 4
         syscall

         # Put -1 in $t0, then copy that value to each of the $f registers
         addi  $t0, $zero, -1
         mtc1  $t0, $f0
         mtc1  $t0, $f1
         mtc1  $t0, $f2
         mtc1  $t0, $f3
         mtc1  $t0, $f4
         mtc1  $t0, $f5
         mtc1  $t0, $f6
         mtc1  $t0, $f7
         mtc1  $t0, $f8
         mtc1  $t0, $f9
         mtc1  $t0, $f10
         mtc1  $t0, $f11
         mtc1  $t0, $f12
         mtc1  $t0, $f13
         mtc1  $t0, $f14
         mtc1  $t0, $f15
         mtc1  $t0, $f16
         mtc1  $t0, $f17
         mtc1  $t0, $f18
         mtc1  $t0, $f19
         mtc1  $t0, $f20
         mtc1  $t0, $f21
         mtc1  $t0, $f22
         mtc1  $t0, $f23
         mtc1  $t0, $f24
         mtc1  $t0, $f25
         mtc1  $t0, $f26
         mtc1  $t0, $f27
         mtc1  $t0, $f28
         mtc1  $t0, $f29
         mtc1  $t0, $f30
         mtc1  $t0, $f31

         # Put various values in the $t registers
         addi  $t0, $zero, -1111
         addi  $t1, $zero, -2222
         addi  $t2, $zero, -3333
         addi  $t3, $zero, -4444
         addi  $t4, $zero, -5555
         addi  $t5, $zero, -6666
         addi  $t6, $zero, -7777
         addi  $t7, $zero, -8888
         addi  $t8, $zero, -9999
         addi  $t9, $zero, -1111

         # Put various values in the $a registers.
         addi  $a0, $zero, -1111
         addi  $a1, $zero, -1111
         addi  $a2, $zero, -2222
         addi  $a3, $zero, -3333

         # Put two values at the top two spots in our stack.  This is where
         #    the number of homeruns and outs were placed when printStats
         #    is called.  A function is allowed to change its own stack.
         addi  $t7, $zero, -1234
         sw    $t7,  0($fp)
         sw    $t7, -4($fp)

printStatsDone:
         # Epilogue for printStats -- restore stack & frame pointers and return
         lw    $ra, 4($sp)       # get return address from stack
         lw    $fp, 0($sp)       # restore frame pointer for caller
         addiu $sp, $sp, 32      # restore frame pointer for caller
         jr    $ra               # return to caller

# Your code goes below this line
