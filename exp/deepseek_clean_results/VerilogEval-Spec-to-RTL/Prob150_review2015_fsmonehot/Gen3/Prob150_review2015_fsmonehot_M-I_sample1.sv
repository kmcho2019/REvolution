module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// State bit positions (one-hot encoding):
// state[0] = S
// state[1] = S1
// state[2] = S11
// state[3] = S110
// state[4] = B0
// state[5] = B1
// state[6] = B2
// state[7] = B3
// state[8] = Count
// state[9] = Wait

// Next state logic
assign S_next = (state[0] & ~d) |        // S->S when d=0
                (state[1] & ~d) |        // S1->S when d=0
                (state[3] & ~d) |        // S110->S when d=0
                (state[9] & ack);        // Wait->S when ack=1

assign S1_next = (state[0] & d) |        // S->S1 when d=1
                 (state[1] & d) |        // S1->S1 when d=1
                 (state[2] & d);         // S11->S11 when d=1

assign B3_next = state[6];               // B2->B3 always

assign Count_next = state[7] |           // B3->Count always
                    (state[8] & ~done_counting); // Count->Count when not done

assign Wait_next = state[8] & done_counting; // Count->Wait when done

// Output logic
assign shift_ena = |state[7:4];          // B0-B3 states (bits 4-7)
assign counting = state[8];              // Count state
assign done = state[9];                  // Wait state

endmodule