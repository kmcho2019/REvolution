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

    // Extract current state bits (one-hot encoding)
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

    // Optimized intermediate signals
    wire return_to_S = (S_curr | S1_curr) & ~d | S110_curr & ~d;
    wire count_done = Count_curr & done_counting;
    wire wait_ack = Wait_curr & ack;

    // Optimized next state logic
    assign S_next = return_to_S | wait_ack;
    assign S1_next = S_curr & d;
    assign B3_next = B2_curr;
    assign Count_next = B3_curr | (Count_curr & ~done_counting);
    assign Wait_next = count_done | (Wait_curr & ~ack);

    // Optimized output logic
    assign shift_ena = |state[4:7];  // B0-B3 states
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule