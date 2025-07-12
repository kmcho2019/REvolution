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

    // Common sub-expressions
    wire S_to_S1 = S_curr & d;
    wire S1_to_S = S1_curr & ~d;
    wire S110_to_S = S110_curr & ~d;
    wire Wait_to_S = Wait_curr & ack;

    // Next state logic
    assign S_next = S_to_S1 | S1_to_S | S110_to_S | Wait_to_S;
    assign S1_next = S_to_S1;
    assign B3_next = B2_curr;
    assign Count_next = B3_curr | (Count_curr & ~done_counting);
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Output logic - optimized for minimal operations
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule