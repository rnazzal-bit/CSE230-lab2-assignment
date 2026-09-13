# CSE 230 - Lab 2: Conditional and Unconditional Branch Instructions
# Remove duplicate array values in place.
#
# Equivalent C code:
# for (int i = 0; i < size; i++) {
# int j = i + 1;
# while (j < size) {
# if (Array[i] == Array[j]) {
# for (int k = j; k + 1 < size; k++) {
# Array[k] = Array[k + 1];
# }
# size--;
# } else {
# j++;
# }
# }
# }
#
# Register usage:
# $s0 = array base address
# $s1 = current array size
# $t0 = i
# $t1 = j
# $t2 = k
# $t3 = comparison result
# $t4 = memory address
# $t5 = Array[i]
# $t6 = loaded array value
# $t7 = k + 1
#
# sll $zero, $zero, 0 is a no-operation instruction.
 addi $t0, $zero, 0 # i = 0
outer_loop:
 slt $t3, $t0, $s1 # check i < size
 beq $t3, $zero, done # stop if i >= size
 sll $zero, $zero, 0 # branch delay slot
 sll $t4, $t0, 2 # offset = i * 4
 add $t4, $s0, $t4 # address of Array[i]
 lw $t5, 0($t4) # t5 = Array[i]
 addi $t1, $t0, 1 # j = i + 1
inner_loop:
 slt $t3, $t1, $s1 # check j < size
 beq $t3, $zero, next_i # move on if j >= size
 sll $zero, $zero, 0 # branch delay slot
 sll $t4, $t1, 2 # offset = j * 4
 add $t4, $s0, $t4 # address of Array[j]
 lw $t6, 0($t4) # t6 = Array[j]
 sll $zero, $zero, 0 # load delay slot
 bne $t5, $t6, next_j # if Array[i] != Array[j], j++
 sll $zero, $zero, 0 # branch delay slot
 add $t2, $t1, $zero # k = j
shift_loop:
 addi $t7, $t2, 1 # t7 = k + 1
 slt $t3, $t7, $s1 # check k + 1 < size
 beq $t3, $zero, shrink # stop shifting if false
 sll $zero, $zero, 0 # branch delay slot
 sll $t4, $t2, 2 # offset = k * 4
 add $t4, $s0, $t4 # address of Array[k]
 lw $t6, 4($t4) # load Array[k + 1]
 sll $zero, $zero, 0 # load delay slot
 sw $t6, 0($t4) # Array[k] = Array[k + 1]
 addi $t2, $t2, 1 # k++
 j shift_loop
 sll $zero, $zero, 0 # jump delay slot
shrink:
 addi $s1, $s1, -1 # size--
 j inner_loop # check same j again after shifting
 sll $zero, $zero, 0 # jump delay slot
next_j:
 addi $t1, $t1, 1 # j++
 j inner_loop
 sll $zero, $zero, 0 # jump delay slot
next_i:
 addi $t0, $t0, 1 # i++
 j outer_loop
 sll $zero, $zero, 0 # jump delay slot
done:
 sll $zero, $zero, 0 # end of program
