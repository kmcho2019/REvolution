module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Initialize next_state to zero
    wire [9:0] ns_from_state [9:0];

    // For each state, define next state bits depending on input
    // S0 transitions
    assign ns_from_state[0] = {10{state[0] & ~in}} & 10'b0000000001 |  // S0--0-->S0
                             {10{state[0] &  in}} & 10'b0000000010;   // S0--1-->S1

    // S1 transitions
    assign ns_from_state[1] = {10{state[1] & ~in}} & 10'b0000000001 |  // S1--0-->S0
                             {10{state[1] &  in}} & 10'b0000000100;   // S1--1-->S2

    // S2 transitions
    assign ns_from_state[2] = {10{state[2] & ~in}} & 10'b0000000001 |  // S2--0-->S0
                             {10{state[2] &  in}} & 10'b0000001000;   // S2--1-->S3

    // S3 transitions
    assign ns_from_state[3] = {10{state[3] & ~in}} & 10'b0000000001 |  // S3--0-->S0
                             {10{state[3] &  in}} & 10'b0000010000;   // S3--1-->S4

    // S4 transitions
    assign ns_from_state[4] = {10{state[4] & ~in}} & 10'b0000000001 |  // S4--0-->S0
                             {10{state[4] &  in}} & 10'b0000100000;   // S4--1-->S5

    // S5 transitions
    assign ns_from_state[5] = {10{state[5] & ~in}} & 10'b0000010000 |  // S5--0-->S8 (bit 8)
                             {10{state[5] &  in}} & 10'b0001000000;   // S5--1-->S6 (bit 6)

    // S6 transitions
    assign ns_from_state[6] = {10{state[6] & ~in}} & 10'b0010000000 |  // S6--0-->S9 (bit 9)
                             {10{state[6] &  in}} & 10'b0000100000;   // S6--1-->S7 (bit 7)

    // S7 transitions
    assign ns_from_state[7] = {10{state[7] & ~in}} & 10'b0000000001 |  // S7--0-->S0
                             {10{state[7] &  in}} & 10'b1000000000;   // S7--1-->S7

    // S8 transitions
    assign ns_from_state[8] = {10{state[8] & ~in}} & 10'b0000000001 |  // S8--0-->S0
                             {10{state[8] &  in}} & 10'b0000000010;   // S8--1-->S1

    // S9 transitions
    assign ns_from_state[9] = {10{state[9] & ~in}} & 10'b0000000001 |  // S9--0-->S0
                             {10{state[9] &  in}} & 10'b0000000010;   // S9--1-->S1

    // Combine all contributions for next_state
    assign next_state = ns_from_state[0] | ns_from_state[1] | ns_from_state[2] | ns_from_state[3] | ns_from_state[4] |
                        ns_from_state[5] | ns_from_state[6] | ns_from_state[7] | ns_from_state[8] | ns_from_state[9];

    // Outputs from states with specified outputs
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule