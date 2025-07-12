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
    wire is_start_group = |state[3:0];  // S, S1, S11, S110
    wire is_shift_group = |state[7:4];  // B0-B3
    wire is_count_group = state[8];     // Count
    wire is_wait_group = state[9];     // Wait

    // Next state logic with priority encoding
    assign S_next = (is_start_group & ~d) | (is_wait_group & ack);
    assign S1_next = state[0] & d;
    
    // Shift group progression
    wire shift_progress = state[4] | state[5] | state[6];
    assign B3_next = state[6];  // B2->B3
    
    // Count/Wait progression
    assign Count_next = state[7] | (state[8] & ~done_counting);
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack);

    // Output logic - pre-computed based on next state
    wire next_is_shift = state[4] | state[5] | state[6] | state[7];
    assign shift_ena = next_is_shift;
    
    wire next_is_count = Count_next;
    assign counting = next_is_count;
    
    wire next_is_wait = Wait_next;
    assign done = next_is_wait;

endmodule