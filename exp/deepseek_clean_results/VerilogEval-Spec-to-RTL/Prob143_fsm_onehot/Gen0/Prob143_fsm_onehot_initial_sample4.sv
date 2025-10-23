module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Next state logic
    assign next_state[0] = (state[0] & ~in) |  // S0 stays on 0
                          (state[1] & ~in) |  // S1 -> S0 on 0
                          (state[2] & ~in) |  // S2 -> S0 on 0
                          (state[3] & ~in) |  // S3 -> S0 on 0
                          (state[4] & ~in) |  // S4 -> S0 on 0
                          (state[5] & ~in) |  // S5 -> S8 on 0 (not S0)
                          (state[6] & ~in) |  // S6 -> S9 on 0 (not S0)
                          (state[7] & ~in) |  // S7 -> S0 on 0
                          (state[8] & ~in) |  // S8 -> S0 on 0
                          (state[9] & ~in);   // S9 -> S0 on 0

    assign next_state[1] = (state[0] & in) |   // S0 -> S1 on 1
                          (state[8] & in) |    // S8 -> S1 on 1
                          (state[9] & in);    // S9 -> S1 on 1

    assign next_state[2] = (state[1] & in);    // S1 -> S2 on 1

    assign next_state[3] = (state[2] & in);    // S2 -> S3 on 1

    assign next_state[4] = (state[3] & in);    // S3 -> S4 on 1

    assign next_state[5] = (state[4] & in);    // S4 -> S5 on 1

    assign next_state[6] = (state[5] & in);    // S5 -> S6 on 1

    assign next_state[7] = (state[6] & in) |   // S6 -> S7 on 1
                          (state[7] & in);     // S7 -> S7 on 1

    assign next_state[8] = (state[5] & ~in);   // S5 -> S8 on 0

    assign next_state[9] = (state[6] & ~in);   // S6 -> S9 on 0

    // Output logic
    assign out1 = state[8] | state[9];         // S8 or S9 sets out1
    assign out2 = state[7] | state[9];         // S7 or S9 sets out2

endmodule