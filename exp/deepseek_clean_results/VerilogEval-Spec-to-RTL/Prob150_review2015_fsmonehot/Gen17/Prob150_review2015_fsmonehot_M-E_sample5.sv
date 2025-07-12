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

    // State group detection
    wire in_start_group = |state[3:0];  // S, S1, S11, S110
    wire in_shift_group = |state[7:4];  // B0-B3
    wire in_count_state = state[8];
    wire in_wait_state = state[9];

    // Transition conditions
    wire start_to_S1 = state[0] & d;
    wire start_to_S11 = state[1] & d;
    wire start_to_S110 = state[2] & ~d;
    wire start_to_B0 = state[3] & d;
    wire count_to_wait = in_count_state & done_counting;
    wire wait_to_S = in_wait_state & ack;

    // Next state logic using priority encoding
    assign S_next = (state[0] & ~d) |       // S stays on d=0
                   (state[1] & ~d) |       // S1->S on d=0
                   (state[3] & ~d) |       // S110->S on d=0
                   wait_to_S;              // Wait->S on ack

    assign S1_next = start_to_S1;          // Only S->S1 on d=1
    assign B3_next = state[6];             // B2 always goes to B3
    assign Count_next = state[7] |         // B3->Count
                       (in_count_state & ~done_counting);
    assign Wait_next = count_to_wait |     // Count->Wait
                      (in_wait_state & ~ack);

    // Output logic based on state groups
    assign shift_ena = in_shift_group;     // All shift states enable
    assign counting = in_count_state;      // Only Count state
    assign done = in_wait_state;           // Only Wait state

    // Additional next-state signals for remaining states
    // (Not required outputs but included for completeness)
    wire S11_next = start_to_S11;
    wire S110_next = start_to_S110;
    wire B0_next = state[3] & d;           // S110->B0 on d=1
    wire B1_next = state[4];               // B0->B1
    wire B2_next = state[5];               // B1->B2

endmodule