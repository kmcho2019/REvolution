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

    // State group indicators
    wire is_pattern = |state[3:0];     // S, S1, S11, S110
    wire is_shifting = |state[7:4];    // B0-B3
    wire is_control = |state[9:8];     // Count, Wait

    // Pattern detection transitions
    wire s_condition = (~d & (state[0] | state[1] | state[3])) | 
                      (state[9] & ack);
    assign S_next = s_condition;
    
    wire s1_condition = state[0] & d;
    assign S1_next = s1_condition;

    // Shifting group transitions (linear progression)
    assign B3_next = state[6];  // B2 always goes to B3

    // Control group transitions
    wire count_condition = state[7] | (state[8] & ~done_counting);
    assign Count_next = count_condition;
    
    wire wait_condition = (state[8] & done_counting) | 
                         (state[9] & ~ack);
    assign Wait_next = wait_condition;

    // Optimized output logic
    assign shift_ena = is_shifting;  // All shifting states enable shift
    assign counting = state[8];      // Only Count state asserts counting
    assign done = state[9];          // Only Wait state asserts done

endmodule