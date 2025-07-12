module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoding: [S, S1, S11, S110, B0, B1, B2, B3, Count, Wait]
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state bits for clarity
    wire S_curr     = state[0];
    wire S1_curr    = state[1];
    wire S11_curr   = state[2];
    wire S110_curr  = state[3];
    wire B0_curr    = state[4];
    wire B1_curr    = state[5];
    wire B2_curr    = state[6];
    wire B3_curr    = state[7];
    wire Count_curr = state[8];
    wire Wait_curr  = state[9];

    // Next state logic
    assign S_next = (S_curr & ~d) |        // S stays when d=0
                   (S1_curr & ~d) |        // S1->S when d=0
                   (S110_curr & ~d) |      // S110->S when d=0
                   (Wait_curr & ack);      // Wait->S when ack=1

    assign S1_next = S_curr & d;           // Only S->S1 when d=1

    assign B3_next = B2_curr;              // B2->B3 always

    assign Count_next = B3_curr |          // B3->Count always
                       (Count_curr & ~done_counting); // Count stays when not done

    assign Wait_next = (Count_curr & done_counting) | // Count->Wait when done
                      (Wait_curr & ~ack);  // Wait stays when ack=0

    // Output logic
    assign shift_ena = |state[7:4];        // B0-B3 states (bits 4-7)
    assign counting = Count_curr;          // Count state (bit 8)
    assign done = Wait_curr;               // Wait state (bit 9)

endmodule