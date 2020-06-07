        .syntax     unified
        .cpu        cortex-m4
        .text
        .thumb_func
        .align       2

// @author: Jonathan Trinh
// Lab2 - 10/3/2017

// uint32_t  Ten32(void);
            .global     Ten32
Ten32:      LDR         R0,=10     // Since what is return is R0, we load R0 with the constant 10
            BX          LR

// uint64_t  Ten64(void);
            .global     Ten64
Ten64:      LDR         R1,=0       // To return a 64 bit integer, we need to zero extend R0, by loading R1 with 0s
            LDR         R0,=10      // Load R0 with 10
            BX          LR

// uint32_t  Incr(uint32_n);
            .global     Incr
Incr:       ADD         R0,R0,1     //  Add 1 to the parameter (whatever is loaded into R0) and load it back into R0
            BX          LR

// uint32_t  Nested1(void);
            .global     Nested1
Nested1:    PUSH        {LR}
            BL          rand        // call rand function
            ADD         R0,R0,1     // since what is returned is R0, add 1 to it and store it back in R0
            POP         {PC}

// uint32_t  Nested2(void);
            .global     Nested2
Nested2:    PUSH        {R4,LR}
            BL          rand        // call rand function (this changes R0 through R3), hence why we needed to preserve R4 above
            MOV         R4,R0       // save the output into R4
            BL          rand        // call rand function again
            ADD         R0,R0,R4    // add the result of this function call to R4 and store it back inside R0
            POP         {R4,PC}     // Free R4 and the Link Register

// void PrintTwo(char *format, uint32_t n)
            .global     PrintTwo
PrintTwo:   PUSH        {R4,R5,LR}
            MOV         R4,R0       // save *format and n into registers R4 and R5 (We will use them later)
            MOV         R5,R1
            BL          printf      // call printf on R0 and R1 which contain *format and n respectively
            MOV         R0,R4       // move R4 back into R0
            ADD         R1,R5,1     // and add 1 to n (Adding R5 to 1) and store it into R1
            BL          printf      // finally call printf again
            POP         {PC}

        .end

