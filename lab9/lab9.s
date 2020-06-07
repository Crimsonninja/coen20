                .syntax     unified
                .cpu        cortex-m4
                .text
                .thumb_func
                .align       2

// void SIMD_USatAdd(uint8_t bytes[], uint32_t count, uint_8 amount
                .global     SIMD_USatAdd
SIMD_USatAdd:   PUSH        {R4-R11}        // Push all registers
                BFI         R2,R2,8,8       // Two 8 bit copies of amount
                BFI         R2,R2,16,16     // Four 8 bit copies of amount

woot:           CMP         R1,40           // when there are less than 40
                BLO         loop            // jump to clean-up loop
                LDMIA       R0,{R3-R12}     // load multiple registers with R0
                UQADD8      R3, R3, R2      // add all registers with amount
                UQADD8      R4, R4, R2
                UQADD8      R5, R5, R2
                UQADD8      R6, R6, R2
                UQADD8      R7, R7, R2
                UQADD8      R8, R8, R2
                UQADD8      R9, R9, R2
                UQADD8      R10, R10, R2
                UQADD8      R11, R11, R2
                UQADD8      R12, R12, R2
                STMIA       R0!,{R3-R12}    // store back into R0
                SUB         R1,R1,40        // decrement by 40
                B           woot            // repeat


loop:           CBZ         R1,done         // clean up loop (from book)
                LDR         R3,[R0]         // load R3 with the byte
                UQADD8      R3,R3,R2        // add amount to R3
                STR         R3,[R0],4       // Store back into R3
                SUB         R1,R1,4         // Decrement by 4
                B           loop
done:           POP         {R4-R11}        // Pop all registers
                BX          LR

                .end

