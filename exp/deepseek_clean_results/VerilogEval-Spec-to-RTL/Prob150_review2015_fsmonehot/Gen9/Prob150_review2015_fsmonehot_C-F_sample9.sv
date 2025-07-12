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

    // Current state decoding
    wire S_curr    = state[0];
    wire S1_curr   = state[1];
    wire S11_curr  = state[2];
    wire S110_curr = state[3];
    wire B0_curr   = state[4];
    wire B1_curr   = state[5];
    wire B2_curr   = state[6];
    wire B3_curr   = state[7];
    wire Count_curr= state[8];
    wire Wait_curr = state[9];

    // Next state logic (optimized combination)
    assign S_next = (S_curr & ~d) |        // S stays when d=0
                   (S1_curr & ~d) |        // S1->S when d=0
                   (S110_curr & ~d) |      // S110->S when d=0
                   (Wait_curr & ack);      // Wait->S when ack=1

    assign S1_next = S_curr & d;           // S->S1 only when d=1

    assign B3_next = B2_curr;              // B2->B3 always

    assign Count_next = B3_curr |          // B3->Count always
                       (Count_curr & ~done_counting); // Count stays until done

    assign Wait_next = (Count_curr & done_counting) | // Count->Wait when done
                      (Wait_curr & ~ack);            // Wait stays until ack

    // Output logic
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;  // Active in B states
    assign counting = Count_curr;          // Active in Count state
    assign done = Wait_curr;               // Active in Wait state

endmodule