module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S=bit0, S1=bit1, S11=bit2, S110=bit3,
                        // B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state decoding with descriptive names
    wire current_S     = state[0];
    wire current_S1    = state[1];
    wire current_S11   = state[2];
    wire current_S110  = state[3];
    wire current_B0    = state[4];
    wire current_B1    = state[5];
    wire current_B2    = state[6];
    wire current_B3    = state[7];
    wire current_Count = state[8];
    wire current_Wait  = state[9];

    // Next state logic - optimized and grouped
    assign S_next = (current_S & ~d) |        // S stays when d=0
                   (current_S1 & ~d) |        // S1->S when d=0
                   (current_S110 & ~d) |      // S110->S when d=0
                   (current_Wait & ack);      // Wait->S when ack=1

    assign S1_next = current_S & d;           // S->S1 when d=1

    assign B3_next = current_B2;              // B2->B3 always

    assign Count_next = current_B3 |          // B3->Count always
                       (current_Count & ~done_counting); // Count stays when not done

    assign Wait_next = (current_Count & done_counting) | // Count->Wait when done
                      (current_Wait & ~ack);  // Wait stays when no ack

    // Output logic - direct and efficient
    assign done = current_Wait;               // Active in Wait state
    assign counting = current_Count;          // Active in Count state
    assign shift_ena = current_B0 | current_B1 | current_B2 | current_B3; // Active in B0-B3 states

endmodule