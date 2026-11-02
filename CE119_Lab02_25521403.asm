.data
score_arr:  .word 4, 4, 4, 4, 4
n:          .word 5
grade_tab:  .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
hist:       .word 0, 0, 0, 0
min:.asciiz "min= "
max:.asciiz "max= "
prompt1:.asciiz "g0="
prompt2:.asciiz "g1="
prompt3:.asciiz "g2="
prompt4:.asciiz "g3="
newline: .asciiz "\n"
space: .asciiz " "
e: .word 4
.text
main:
    la   $a0, score_arr       
    lw   $a1, n               
    jal  stats
    la   $a0, score_arr    
    lw   $a1, n              
    la   $a2, grade_tab       
    la   $a3, hist            
    jal  histogram
    move $t7,$v0
    la   $a0, min
    li   $v0 4
    syscall 
    move $a0 ,$t7
    li   $v0,1
    syscall
    la $a0,space
    li $v0,4
    syscall
    move $t7,$v1
    la $a0, max
    li   $v0 4
    syscall 
    move $a0 ,$t7
li $v0, 1
    syscall
    la   $a0, newline
    li   $v0 4
    syscall
    la $s0, hist
    lw $a1, e
    move $t0, $a1
    la $a0, prompt1
    li $v0,4
    syscall
    jal print_h
    la $a0,space
    li $v0,4
    syscall
    la $a0, prompt2
    li $v0,4
    syscall
    jal print_h
    la $a0,space
    li $v0,4
    syscall
la $a0, prompt3
    li $v0,4
    syscall
    jal print_h
    la $a0,space
    li $v0,4
    syscall
    la $a0, prompt4
    li $v0,4
    syscall
    jal print_h
    li   $v0, 10
    syscall
stats:
    lw   $t0, 0($a0)       
    move $v0, $t0             
    move $v1, $t0             
    addi $t1, $a0, 4        
    addi $t2, $a1, -1         
stats_loop:
    beq  $t2, $zero, stats_done  
    lw   $t3, 0($t1)          
    bge  $t3, $v0, check_max
    move $v0, $t3            
check_max:
    ble  $t3, $v1, stats_next
    move $v1, $t3            
stats_next:
    addi $t1, $t1, 4          
    addi $t2, $t2, -1        
    j    stats_loop
stats_done:
    jr   $ra           
histogram:
    move $t0, $a0             
    move $t1, $a1             
hist_loop:
    beq  $t1, $zero, hist_done
    lw   $t2, 0($t0)          
    add  $t3, $a2, $t2       
    lbu  $t4, 0($t3)         
    sll  $t5, $t4, 2         
    add  $t5, $a3, $t5        
    lw   $t6, 0($t5)        
    addi $t6, $t6, 1         
    sw   $t6, 0($t5)         
    addi $t0, $t0, 4      
    addi $t1, $t1, -1         
    j    hist_loop
hist_done:
    jr   $ra     
print_h:
beq $t0,$zero, endp
lw $t1,0($s0)
move $a0 ,$t1
li $v0, 1
syscall
addi $s0, $s0,4
addi $t0,$t0,-1
jr $ra
endp:
jr $ra   