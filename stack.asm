.data

chuoi: .asciiz "([]([] "   
mongoac: .asciiz "("  
dongngoac: .asciiz ")" 
dauphay: .asciiz " ," 
.text

main:
la   $a0, chuoi
    jal  check_brackets    
    move $t0,$v0
    move $t1, $v1
    li $v0,4
    la $a0,mongoac
    syscall
    li $v0,1
    move $a0,$t0
    syscall
    li $v0,4
    la $a0,dauphay
    syscall
    li $v0,1
    move $a0,$t1
    syscall
    li $v0,4
    la $a0,dongngoac
    syscall
    li   $v0, 10
    syscall
check_brackets:
    move $t9, $sp            
    move $t0, $a0            
    li   $t1, 0             

cb_loop:
    lbu  $t2, 0($t0)         
    addi $t1, $t1, 1         

  
    beq  $t2, $zero, cb_check_end
    li   $t3, '('           
    beq  $t2, $t3, cb_push
    li   $t3, '['            
    beq  $t2, $t3, cb_push
    li   $t3, '{'          
    beq  $t2, $t3, cb_push
    li   $t3, ')'            
    beq  $t2, $t3, cb_check_close
    li   $t3, ']'            
    beq  $t2, $t3, cb_check_close
    li   $t3, '}'            
    beq  $t2, $t3, cb_check_close
    j    cb_next
cb_push:
    addi $sp, $sp, -4
    sw   $t2, 0($sp)
    j    cb_next
cb_check_close:
    beq  $sp, $t9, err_close_empty 
    lw   $t4, 0($sp)
    addi $sp, $sp, 4
    li   $t3, ')'
    bne  $t2, $t3, check_bracket_square
    li   $t5, '('
    bne  $t4, $t5, err_mismatch   
    j    cb_next
check_bracket_square:
    li   $t3, ']'
    bne  $t2, $t3, check_bracket_curly
    li   $t5, '['
    bne  $t4, $t5, err_mismatch   
    j    cb_next
check_bracket_curly:
    li   $t5, '{'
    bne  $t4, $t5, err_mismatch 
cb_next:
    addi $t0, $t0, 1      
    j    cb_loop
cb_check_end:
    bne  $sp, $t9, err_unclosed
    li   $v0, 0
    li   $v1, 0
    j    cb_exit
err_mismatch:
    move $v0, $t1            
    li   $v1, 1              
    j    cb_exit
err_close_empty:
    move $v0, $t1          
    li   $v1, 2               
    j    cb_exit
err_unclosed:
    move $v0, $t1             
    li   $v1, 3               
    j    cb_exit
cb_exit:
    move $sp, $t9             
    jr   $ra                 
    
