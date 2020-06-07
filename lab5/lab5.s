                .syntax     unified
                .cpu        cortex-m4
                .text
                .thumb_func
                .align       2

// void DeleteItem(int32_t data[], int32_t items, int32_t index);
                // R0 = &data[0]
                // R1 = items
                // R2 = index
                .global     DeleteItem
DeleteItem:     PUSH        {R4}
                ADD         R0, R0, R2, LSL 2       // position of item to delete
                SUB         R2, R1, R2              // # iterations is #items - #index

L1:             SUB         R2, R2, 1               // decrement index
                CBZ         R2, L2                  // loop
                LDR         R4,[R0,4]               // gets data[i+1]
                STR         R4,[R0],4               // store into data[i] and increment R0 by 4
                B           L1                      // repeat
L2:             POP         {R4}                    // return
                BX          LR


// void InsertItem(int32_t data[], int32_t items, int32_t index, int32_t value)
                // R0 = &data[0]
                // R1 = items
                // R2 = index
                // R3 = value
                .global     InsertItem
InsertItem:     PUSH        {R4}
                ADD         R0, R0, R1, LSL 2       // start at end of array
                SUB         R2, R1, R2              // # iterations is #items - #index

L3:             SUB         R2, R2, 1               // decrement index
                CBZ         R2, L4
                LDR         R4, [R0,-8]             // gets data[i-2]
                STR         R4,[R0,-4]              // store into data[i-1]
                SUB         R0,R0,4                 // subtract 4 from address
                B           L3
L4:             STR         R3,[R0,-4]              // store value into data[i-1]
                POP         {R4}
                BX          LR

        .end

