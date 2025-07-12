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

    // State grouping
    wire in_pattern = state[0] | state[1] | state[2] | state[3];  // S, S1, S11, S110
    wire in_shifting = state[4] | state[5] | state[6] | state[7];  // B0-B3
    wire in_count_wait = state[8] | state[9];                     // Count, Wait

    // Next state logic with optimized grouping
    assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[3] & ~d) | (state[9] & ack);
    assign S1_next = state[0] & d;
    assign B3_next = state[6];  // B2 -> B3 transition
    
    // Optimized counting/wait transitions
    wire count_continue = state[8] & ~done_counting;
    wire count_done = state[8] & done_counting;
    assign Count_next = state[7] | count_continue;  // B3 or continue counting
    assign Wait_next = count_done | (state[9] & ~ack);

    // Output logic with hierarchical optimization
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = in_shifting;  // Active in all shifting states

endmodule