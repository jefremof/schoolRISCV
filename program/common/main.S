# RISC-V fifo queue
#
# Mark Efremov, 2024
#



            .text

start:          mv a0, zero     # queue size counter
                mv a1, zero     # result
                li t1, 8      # max queue size

.loop_not_BF:   
                addi a0, a0, 1
                .byte 0x2a, 0x00, 0x05, 0x00      # push a0
                bne a0, t1, .loop_not_BF
.loop_not_BEM:  
                .byte 0x34, 0x05, 0x00, 0x00      # pop a0
                add a1, a0, a1
                bne a0, t1, .loop_not_BEM
                mv a0, a1

