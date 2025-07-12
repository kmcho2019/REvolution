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

    // Intermediate signals for common patterns
    wire d_high = d;
    wire d_low = ~d;
    wire ack_high = ack;
    wire done_counting_high = done_counting;

    // Pattern detection state transitions (grouped by source state)
    wire s_transitions = state[0] & (d_low | d_high);
    wire s1_transitions = state[1] & d_low;
    wire s110_transitions = state[3] & d_low;
    wire wait_transitions = state[9] & ack_high;

    // Balanced OR tree for S_next
    wire s_next_part1 = s_transitions & d_low;
    wire s_next_part2 = s1_transitions | s110_transitions;
    assign S_next = s_next_part1 | s_next_part2 | wait_transitions;

    // Direct assignments for simple transitions
    assign S1_next = state[0] & d_high;
    assign B3_next = state[6];  // B2 always goes to B3

    // Counting-related transitions
    wire count_holds = state[8] & ~done_counting_high;
    assign Count_next = state[7] | count_holds;

    // Wait state transitions
    wire wait_holds = state[9] & ~ack_high;
    assign Wait_next = (state[8] & done_counting_high) | wait_holds;

    // Optimized output logic
    wire shift_states_01 = state[4] | state[5];  // B0 or B1
    wire shift_states_23 = state[6] | state[7];  // B2 or B3
    assign shift_ena = shift_states_01 | shift_states_23;  // Binary OR tree
    
    assign counting = state[8];  // Direct assignment
    assign done = state[9];      // Direct assignment

endmodule