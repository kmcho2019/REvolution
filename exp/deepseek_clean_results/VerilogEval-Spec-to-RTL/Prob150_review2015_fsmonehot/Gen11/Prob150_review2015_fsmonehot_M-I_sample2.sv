module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoding: S=bit0, S1=bit1, S11=bit2, S110=bit3,
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

// Optimized next state logic
assign S_next = (state[0] | state[1] | state[3]) & ~d |  // S/S1/S110->S when d=0
                state[9] & ack;                          // Wait->S when ack=1

assign S1_next = state[0] & d;                           // S->S1 when d=1

assign B3_next = state[6];                               // B2->B3 always

assign Count_next = state[7] |                           // B3->Count always
                   (state[8] & ~done_counting);          // Count->Count when not done

assign Wait_next = state[8] & done_counting |            // Count->Wait when done
                   state[9];                             // Wait->Wait (ack check not needed)

// Optimized output logic - balanced OR tree for shift_ena
assign shift_ena = |state[7:4];                          // B0-B3 states (balanced OR)
assign counting = state[8];                              // Count state
assign done = state[9];                                  // Wait state

endmodule