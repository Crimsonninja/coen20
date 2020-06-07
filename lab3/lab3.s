            .syntax     unified
            .cpu        cortex-m4
            .text
            .thumb_func
            .align       2

            .global     UseLDRB
UseLDRB:    .rept       512
            LDRB        R2, [R1],1          // We load the source into the destination through different register and increment by 1 (since it's 8 bits)
            STRB        R2, [R0],1
            .endr

            BX          LR

            .global     UseLDRH
UseLDRH:    .rept       256
            LDRH        R2, [R1], 2         //  We load the source into the destination through different register and increment by 2 (since it's 16 bits)
            STRH        R2, [R0], 2
            .endr

            BX          LR

            .global     UseLDR
UseLDR:     .rept       128
            LDR        R2, [R1], 4          //  We load the source into the destination through different register and increment by 4 (since it's 32 bits)
            STR        R2, [R0], 4
            .endr

            BX         LR

            .global     UseLDRD
UseLDRD:    .rept       64
            LDRD        R2, R3, [R1], 8     //  We load the source into the destination through two different registers and increment by 8 (since it's 64 bits)
            STRD        R2, R3, [R0], 8
            .endr

            BX          LR

            .global     UseLDMIA
UseLDMIA:   PUSH        {R4-R12}            // Preserve Registers R4-R11
            .rept        11
            LDMIA       R1!, {R2-R12}       // Load multiple registers 11 words of 4 bytes
            STMIA       R0!, {R2-R12}       // totals 44 bytes each time (484 bytes since repeating 11 times)
            .endr

            LDMIA       R1,{R2-R8}          // copy remaining 28 bytes for total of 512
            STMIA       R0,{R2-R8}

            POP         {R4-R12}            // Restore registers R4-R11
            BX          LR
            .end

