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
    wire S110_curr = state[3];
    wire B0_curr   = state[4];
    wire B2_curr   = state[6];
    wire B3_curr   = state[7];
    wire Count_curr= state[8];
    wire Wait_curr = state[9];

    // Optimized next state logic
    wire S_next_from_S = S_curr & ~d;
    wire S_next_from_others = (S1_curr & ~d) | (S110_curr & ~d) | (Wait_curr & ack);
    assign S_next = S_next_from_S | S_next_from_others;  // Parallel OR trees

    assign S1_next = S_curr & d;           // S->S1 only when d=1

    assign B3_next = B2_curr;              // B2->B3 always (just a wire)

    assign Count_next = B3_curr |          // B3->Count always
                       (Count_curr & ~done_counting); // Count stays until done

    assign Wait_next = (Count_curr & done_counting) | // Count->Wait when done
                      (Wait_curr & ~ack);            // Wait stays until ack

    // Optimized output logic
    assign shift_ena = B0_curr;            // Only need to check B0 since states are sequential
    assign counting = Count_curr;          // Active in Count state
    assign done = Wait_curr;               // Active in Wait state

endmodule