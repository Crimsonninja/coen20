                .syntax     unified
                .cpu        cortex-m4
                .text
                .thumb_func
                .align       2

                .global     Discriminant
Discriminant:   MUL         R1,R1,R1            // multiply b*b and store in R1
                LDR         R3,=4
                MUL         R3, R3, R2          // multiply 4 * c
                MLS         R0, R0, R3, R1      // multiply the result by a and subtract from b*b
                BX          LR

                .global     Root1
Root1:          SUB         R1, R2, R1          // subtract b from sqrt d and store in R1
                LDR         R3,=2
                MUL         R0, R0, R3          // multiply 2 * a
                SDIV        R0, R1, R0          // Divide the resultants
                BX          LR

                .global     Root2
Root2:          ADD         R1, R1, R2          // Add b and sqrt 2
                LDR         R3,=-1
                MUL         R1, R1, R3          // multiply result by -1
                LDR         R3,=2
                MUL         R0, R0, R3          // multiply 2 * a
                SDIV        R0, R1, R0          // Divide the resultants
                BX          LR

                .end

