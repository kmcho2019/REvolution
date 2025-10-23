module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define state bits for readability
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];
    wire s5 = state[5];
    wire s6 = state[6];
    wire s7 = state[7];
    wire s8 = state[8];
    wire s9 = state[9];

    // Next state logic - corrected version
    assign next_state[0] = (s0 & ~in) |  // S0 stays on 0
                          (s1 & ~in) |  // S1 -> S0 on 0
                          (s2 & ~in) |  // S2 -> S0 on 0
                          (s3 & ~in) |  // S3 -> S0 on 0
                          (s4 & ~in) |  // S4 -> S0 on 0
                          (s7 & ~in) |  // S7 -> S0 on 0
                          (s8 & ~in) |  // S8 -> S0 on 0
                          (s9 & ~in);   // S9 -> S0 on 0

    assign next_state[1] = (s0 & in) |   // S0 -> S1 on 1
                          (s8 & in) |    // S8 -> S1 on 1
                          (s9 & in);     // S9 -> S1 on 1

    assign next_state[2] = (s1 & in);    // S1 -> S2 on 1

    assign next_state[3] = (s2 & in);    // S2 -> S3 on 1

    assign next_state[4] = (s3 & in);    // S3 -> S4 on 1

    assign next_state[5] = (s4 & in);    // S4 -> S5 on 1

    assign next_state[6] = (s5 & in);    // S5 -> S6 on 1

    assign next_state[7] = (s6 & in) |   // S6 -> S7 on 1
                          (s7 & in);     // S7 -> S7 on 1

    assign next_state[8] = (s5 & ~in);   // S5 -> S8 on 0

    assign next_state[9] = (s6 & ~in);   // S6 -> S9 on 0

    // Output logic (unchanged, correct)
    assign out1 = s8 | s9;              // S8 or S9 sets out1
    assign out2 = s7 | s9;              // S7 or S9 sets out2

endmodule