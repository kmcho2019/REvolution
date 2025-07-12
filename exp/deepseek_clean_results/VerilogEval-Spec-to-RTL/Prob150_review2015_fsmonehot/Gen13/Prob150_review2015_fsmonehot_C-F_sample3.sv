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

    // Current state signals (one-hot encoding)
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

    // Optimized next state logic
    assign S_next = ((S_curr | S1_curr | S110_curr) & ~d) | (Wait_curr & ack);
    assign S1_next = S_curr & d;
    assign B3_next = B2_curr;
    assign Count_next = B3_curr | (Count_curr & ~done_counting);
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Output logic (Moore machine)
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule