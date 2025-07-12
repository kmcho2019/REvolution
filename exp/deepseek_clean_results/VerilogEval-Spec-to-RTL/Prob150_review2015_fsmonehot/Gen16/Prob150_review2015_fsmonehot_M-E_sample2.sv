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
    wire in_shift_group = |state[7:4];  // B0-B3
    wire in_count_group = state[8];     // Count
    wire in_wait_group = state[9];      // Wait
    wire in_sequence_group = |state[3:0]; // S, S1, S11, S110

    // Output logic - determined by state groups
    assign shift_ena = in_shift_group;
    assign counting = in_count_group;
    assign done = in_wait_group;

    // Next-state logic with priority encoding
    assign S_next = (in_sequence_group & ~d & ~state[3]) |  // S, S1 transitions
                   (state[3] & ~d) |                      // S110 transition
                   (in_wait_group & ack);                  // Wait transition

    assign S1_next = state[0] & d;                         // Only from S state
    assign B3_next = state[6];                             // From B2 only
    assign Count_next = state[7] |                         // From B3
                       (in_count_group & ~done_counting);  // Count staying
    assign Wait_next = (in_count_group & done_counting) |  // From Count
                      (in_wait_group & ~ack);              // Wait staying

    // Additional next-state signals for completeness
    // (Not required by interface but included for reference)
    wire S11_next = state[1] & d;
    wire S110_next = state[2] & ~d;
    wire B0_next = state[3] & d;
    wire B1_next = state[4];
    wire B2_next = state[5];
endmodule