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

    // State group definitions
    wire is_pattern_state = |state[3:0];    // S, S1, S11, S110
    wire is_shift_state = |state[7:4];      // B0-B3
    wire is_count_state = state[8];         // Count
    wire is_wait_state = state[9];          // Wait

    // Parallel next-state prediction
    wire pattern_to_S = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d);
    wire pattern_to_S1 = state[0] & d;
    wire pattern_to_B0 = state[3] & d;
    wire count_to_wait = is_count_state & done_counting;
    wire wait_to_S = is_wait_state & ack;

    // Next state assignments using group conditions
    assign S_next = pattern_to_S | wait_to_S;
    assign S1_next = pattern_to_S1;
    assign B3_next = state[6];  // B2 always goes to B3
    assign Count_next = state[7] | (is_count_state & ~done_counting);
    assign Wait_next = count_to_wait | (is_wait_state & ~ack);

    // Output logic using state groups
    assign shift_ena = is_shift_state;
    assign counting = is_count_state;
    assign done = is_wait_state;

endmodule