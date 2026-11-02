.data
score_arr:  .word 8, 5, 2, 9, 6, 10, 3, 7, 4, 1   # M?ng ?i?m m?u
n:          .word 10
grade_tab:  .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
hist:       .word 0, 0, 0, 0

str_g:      .asciiz "g"
str_colon:  .asciiz ": "
str_bar:    .asciiz "|"
str_nl:     .asciiz "\n"

.text
.globl main

main:
    # 1. G?i hàm histogram ?? tính t?n su?t
    la   $a0, score_arr
    lw   $a1, n
    la   $a2, grade_tab
    la   $a3, hist
    jal  histogram

    # 2. G?i hàm draw_hist ?? v? bi?u ?? c?t
    la   $a0, hist            
    li   $a1, 4               
    jal  draw_hist

    # Thoát ch??ng trình
    li   $v0, 10
    syscall


# ==============================================================================
# Th? t?c: histogram (?Ã B? SUNG ??Y ??)
# Tham s?: $a0 = score_arr, $a1 = n, $a2 = grade_tab, $a3 = hist
# ==============================================================================
histogram:
    move $t0, $a0             # $t0 = con tr? duy?t m?ng ?i?m
    move $t1, $a1             # $t1 = s? ph?n t? n

hist_loop:
    beq  $t1, $zero, hist_done

    lw   $t2, 0($t0)          # ??c ?i?m s? s

    # Tra b?ng: group = grade_tab[s]
    add  $t3, $a2, $t2        
    lbu  $t4, 0($t3)          # $t4 = nhóm ?i?m (0..3)

    # hist[group] = hist[group] + 1
    sll  $t5, $t4, 2          
    add  $t5, $a3, $t5        
    lw   $t6, 0($t5)          
    addi $t6, $t6, 1          
    sw   $t6, 0($t5)          

    addi $t0, $t0, 4          
    addi $t1, $t1, -1         
    j    hist_loop

hist_done:
    jr   $ra                  # Quay v? main


# ==============================================================================
# Th? t?c: draw_hist
# Tham s?: $a0 = hist, $a1 = 4
# ==============================================================================
draw_hist:
    move $t0, $a0             
    move $t1, $a1             
    li   $t2, 0               

dh_group_loop:
    beq  $t2, $t1, dh_done    

    li   $v0, 4
    la   $a0, str_g
    syscall

    li   $v0, 1
    move $a0, $t2
    syscall

    li   $v0, 4
    la   $a0, str_colon
    syscall

    lw   $t3, 0($t0)          

dh_bar_loop:
    beq  $t3, $zero, dh_next_group 
    li   $v0, 4
    la   $a0, str_bar
    syscall
    addi $t3, $t3, -1         
    j    dh_bar_loop

dh_next_group:
    li   $v0, 4
    la   $a0, str_nl
    syscall

    addi $t0, $t0, 4          
    addi $t2, $t2, 1          
    j    dh_group_loop

dh_done:
    jr   $ra