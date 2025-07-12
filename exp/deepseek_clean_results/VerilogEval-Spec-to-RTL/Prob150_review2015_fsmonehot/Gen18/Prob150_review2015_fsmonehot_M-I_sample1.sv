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

    // Simplified state detection (only what's needed for outputs)
    wire in_shift_group = |state[7:4];  // B0-B3

    // Transition conditions (separated for timing)
    wire S_stay = state[0] & ~d;
    wire S1_to_S = state[1] & ~d;
    wire S110_to_S = state[3] & ~d;
    wire Wait_to_S = state[9] & ack;
    
    // Next state logic with parallel paths
    assign S_next = S_stay | S1_to_S | S110_to_S | Wait_to_S;
    assign S1_next = state[0] & d;
    assign B3_next = state[6];
    assign Count_next = state[7] | (state[8] & ~done_counting);
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

    // Output logic (direct from state bits where possible)
    assign shift_ena = in_shift_group;
    assign counting = state[8];
    assign done = state[9];

endmodule