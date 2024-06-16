.data
queue:    .space 20           
front:      .word 0            
rear:       .word 0             
size:       .word 0             
menu:    .asciiz "\n1. Enqueue\n2. Dequeue\n3. Display\n4. Exit\nChoose an option: "
enq_msg: .asciiz "Enter a number to enqueue: "
deq_msg: .asciiz "\nDequeued number: "
disp_msg: .asciiz "\nQueue: "
full_msg:  .asciiz "Queue is full!\n"
empty_msg: .asciiz "Queue is empty!\n"
newline:   .asciiz "\n"
exit_msg:  .asciiz "You exit the program\n"

.text
    .globl main

main:
    # Main menu loop
    li $v0, 4
    la $a0, menu
    syscall

    li $v0, 5               
    syscall
    move $t0, $v0           

    beq $t0, 1, call_enqueue
    beq $t0, 2, call_dequeue
    beq $t0, 3, call_display
    beq $t0, 4, call_exit

    j main                  

call_enqueue:
    jal enqueue
    j main

call_dequeue:
    jal dequeue
    j main

call_display:
    jal display
    j main

call_exit:
    jal exit

enqueue:
    la $t1, size
    lw $t2, 0($t1)
    li $t3, 5               
    beq $t2, $t3, queue_full

    li $v0, 4
    la $a0, enq_msg
    syscall

    li $v0, 5              
    syscall
    move $t4, $v0

    la $t5, rear
    lw $t6, 0($t5)
    la $t7, queue
    mul $t8, $t6, 4
    add $t9, $t7, $t8
    sw $t4, 0($t9)

    addi $t6, $t6, 1
    li $t3, 5
    rem $t6, $t6, $t3       # rear = (rear + 1) % 5
    sw $t6, 0($t5)

    lw $t2, 0($t1)
    addi $t2, $t2, 1
    sw $t2, 0($t1)
    jr $ra

queue_full:
    li $v0, 4
    la $a0, full_msg
    syscall
    jr $ra

dequeue:
    la $t1, size
    lw $t2, 0($t1)
    beqz $t2, queue_empty

    la $t3, front
    lw $t4, 0($t3)
    la $t5, queue
    mul $t6, $t4, 4
    add $t7, $t5, $t6
    lw $t8, 0($t7)

    li $v0, 4
    la $a0, deq_msg
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    addi $t4, $t4, 1
    li $t9, 5
    rem $t4, $t4, $t9       
    sw $t4, 0($t3)

    lw $t2, 0($t1)
    subu $t2, $t2, 1
    sw $t2, 0($t1)
    jr $ra

queue_empty:
    li $v0, 4
    la $a0, empty_msg
    syscall
    jr $ra

display:
    li $v0, 4
    la $a0, disp_msg
    syscall

    la $t0, size
    lw $t1, 0($t0)
    beqz $t1, end_display

    la $t2, front
    lw $t3, 0($t2)
    la $t4, rear
    lw $t5, 0($t4)
    move $t6, $t3

display_loop:
    la $t7, queue
    mul $t8, $t6, 4
    add $t9, $t7, $t8  
    lw $t0, 0($t9)     

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    addi $t6, $t6, 1
    li $t8, 5
    rem $t6, $t6, $t8
    bne $t6, $t5, display_loop

end_display:
    jr $ra

exit:
    li $v0, 4
    la $a0, exit_msg
    syscall

    li $v0, 10
    syscall
