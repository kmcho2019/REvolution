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

    // Current state decoding with priority
    wire S_curr    = state[0];
    wire S1_curr   = state[1] & ~|state[9:2];
    wire S11_curr  = state[2] & ~|state[9:3];
    wire S110_curr = state[3] & ~|state[9:4];
    wire B0_curr   = state[4] & ~|state[9:5];
    wire B1_curr   = state[5] & ~|state[9:6];
    wire B2_curr   = state[6] & ~|state[9:7];
    wire B3_curr   = state[7] & ~|state[9:8];
    wire Count_curr= state[8] & ~state[9];
    wire Wait_curr = state[9];

    // Next state logic with priority encoding
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);
    assign Count_next = (B3_curr | (Count_curr & ~done_counting)) & ~Wait_next;
    assign B3_next = B2_curr & ~Count_next & ~Wait_next;
    assign B2_next = B1_curr & ~B3_next & ~Count_next & ~Wait_next;
    assign B1_next = B0_curr & ~B2_next & ~B3_next & ~Count_next & ~Wait_next;
    assign B0_next = (S110_curr & d) & ~B1_next & ~B2_next & ~B3_next & ~Count_next & ~Wait_next;
    assign S110_next = (S11_curr & ~d) & ~B0_next & ~B1_next & ~B2_next & ~B3_next & ~Count_next & ~Wait_next;
    assign S11_next = (S1_curr & d) & ~S110_next & ~B0_next & ~B1_next & ~B2_next & ~B3_next & ~Count_next & ~Wait_next;
    assign S1_next = (S_curr & d) & ~S11_next & ~S110_next & ~B0_next & ~B1_next & ~B2_next & ~B3_next & ~Count_next & ~Wait_next;
    assign S_next = ((S_curr | S1_curr | S110_curr) & ~d) | (Wait_curr & ack);

    // Output logic - pattern matched for efficiency
    assign shift_ena = |state[7:4];  // B0-B3 states
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule