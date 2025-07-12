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
    wire in_sequence = |state[3:0];      // S, S1, S11, S110
    wire in_bitproc  = |state[7:4];      // B0-B3
    wire in_count    = state[8];         // Count
    wire in_wait     = state[9];         // Wait

    // Sequence detector logic
    wire seq_detected = state[3];        // S110 state
    wire [1:0] seq_state = {state[2], state[1]}; // S1/S11 state encoding

    // Next state logic
    assign S_next = (in_sequence & ((state[0] & ~d) |        // S + d=0
                                   (state[1] & ~d) |         // S1 + d=0
                                   (state[3] & ~d))) |       // S110 + d=0
                   (in_wait & ack);                          // Wait + ack

    assign S1_next = in_sequence & ((state[0] & d) |         // S + d=1
                                   (state[1] & d & ~state[2])); // S1 + d=1 (not S11)

    assign B3_next = state[6];  // B2 always goes to B3

    assign Count_next = state[7] |                          // B3 -> Count
                       (in_count & ~done_counting);          // Count stays if not done

    assign Wait_next = (in_count & done_counting) |         // Count -> Wait
                      (in_wait & ~ack);                     // Wait stays if no ack

    // Output logic
    assign shift_ena = |state[7:4];  // Any B0-B3 state
    assign counting  = in_count;
    assign done      = in_wait;

    // Additional next-state signals (not required but complete)
    wire S11_next  = in_sequence & state[1] & d;    // S1 + d=1 -> S11
    wire S110_next = in_sequence & state[2] & ~d;   // S11 + d=0 -> S110
    wire B0_next   = in_sequence & state[3] & d;    // S110 + d=1 -> B0

endmodule