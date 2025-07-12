module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot: S(0), S1(1), S11(2), S110(3),
                        // B0(4), B1(5), B2(6), B3(7), Count(8), Wait(9)
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
    wire S_curr = state[0];
    wire S1_curr = state[1];
    wire S110_curr = state[3];
    wire B2_curr = state[6];
    wire B3_curr = state[7];
    wire Count_curr = state[8];
    wire Wait_curr = state[9];

    // Common transition conditions
    wire return_to_S = (S_curr | S1_curr | S110_curr) & ~d;
    wire wait_to_S = Wait_curr & ack;

    // Next state logic
    assign S_next = return_to_S | wait_to_S;
    assign S1_next = S_curr & d;
    assign B3_next = B2_curr;
    assign Count_next = B3_curr | (Count_curr & ~done_counting);
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Output logic
    assign shift_ena = |state[7:4];  // B0-B3 states
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule