# test with only one batter and only computes the batting average
# The batting average should be 0

.data

mainNumBatters:
   .word 1

mainBatter1:
   .word   2  # walks
   .word   0  # singles
   .word   0  # doubles
   .word   0  # triples
   .word   0  # home runs
   .word   0  # outs


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
         
         la    $s0, mainNumBatters
         lw    $s7, 0($s0)       # $s7 = number of batters
         addi  $s6, $zero, 0     # $s6 = i = 0
         la    $s0, mainBatter1  # $s0 = addr of current batter's stats

mainLoopBegin:         
         slt   $t0, $s6, $s7     # $t0 = i < number of batters
         beq   $t0, $zero, mainDone

         la    $a0, mainBatterNumber
         addi  $v0, $zero, 4
         syscall
         addi  $a0, $s6, 1
         addi  $v0, $zero, 1
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall

         # Compute the batting average
         addi  $a0, $zero, 1      # $a0 = 1 = compute batting average
         lw    $a1,   0($s0)      # $a1 = walks
         lw    $a2,   4($s0)      # $a2 = singles
         lw    $a3,   8($s0)      # $a3 = doubles
         lw    $s1,  12($s0)      # $s1 = triples
         lw    $s2,  16($s0)      # $s2 = home runs
         lw    $s3,  20($s0)      # $s3 = outs
         
         sw    $s3,  -4($sp)      # put outs at top of average's stack
         sw    $s2,  -8($sp)      # put homeruns 2nd fm top of average's stack
         sw    $s1, -12($sp)      # put triples 3rd fm top of average's stack
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
         
         addi  $s6, $s6, 1       # i++
         addi  $s0, $s0, 24      # $s0 = addr of next batter's stats
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

printStatsDone:
         # Epilogue for printStats -- restore stack & frame pointers and return
         lw    $ra, 4($sp)       # get return address from stack
         lw    $fp, 0($sp)       # restore frame pointer for caller
         addiu $sp, $sp, 32      # restore frame pointer for caller
         jr    $ra               # return to caller

# Your code goes below this line
