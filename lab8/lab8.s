            .syntax     unified
            .cpu        cortex-m4
            .text
            .thumb_func
            .align       2



            // S0 = x
            // R0 = &a[0]
            // R1 = n;

one:        .float      1.0
zero:       .float      0.0

            .global     FloatPoly
FloatPoly:  VLDR        S1, zero        // S1 = poly
            VLDR        S2, one         // S2 = x2n

L1:         CBZ         R1, L2          // # of iterations is R1
            VLDR        S3,[R0]         // coef[i]
            VMLA.F32    S1,S2,S3        // poly = poly + coef[i] * x2n
            ADD         R0,R0,4
            VMUL.F32    S2,S2,S0
            SUB         R1,R1,1
            B           L1

L2:         VMOV        S0,S1
            BX          LR


            // R0 = x
            // R1 = &a[0]
            // R2 = n;
            .global     FixedPoly
FixedPoly:  PUSH        {R4,R5, R6, R7,R8}

            LDR         R3,=0           // R3 = poly
            LDR         R4,=1           // R4 = x2n
            LSL         R4,16           // Left shift x2n 16 times because Q16
L3:         CBZ         R2, L4
            LDR         R8,[R1]         // coef[i]
            SMULL       R5,R6,R4,R8     // multiply x2n and coef[i]
            ADD         R1,R1,4         // add 4 to address

            BFI         R7, R6, 0,16    // insert bits 0-16 of R6 into 0-16 of R7
            LSL         R7,16           // right shift R7 16 times to make room for the bits of R5
            LSR         R5,16           // right shift R5 16 times to get the most significant half of least significant part
            BFI         R7, R5, 0,16    // insert bits 0-16 of R5 into 0-16 of R7

            ADD         R3,R3,R7;       // add the product to "poly"
            SMULL       R5,R6,R4,R0     // multiply x2n and x

            BFI         R4, R6, 0,16    // same as above
            LSL         R4,16
            LSR         R5,16
            BFI         R4, R5, 0,16

            SUB         R2,R2,1
            B           L3

L4:         MOV         R0,R3
            POP         {R4,R5,R6,R7,R8}
            BX          LR

            .end

