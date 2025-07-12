module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = {10{1'b0}}; // Initialize next_state to zero
    assign out1 = 1'b0; // Initialize out1 to zero
    assign out2 = 1'b0; // Initialize out2 to zero

    // S0 to S1 or S0
    assign next_state[1] = state[0] & in;
    assign next_state[0] = state[0] & ~in;

    // S1 to S2 or S0
    assign next_state[2] = state[1] & in;
    assign next_state[0] = next_state[0] | (state[1] & ~in);

    // S2 to S3 or S0
    assign next_state[3] = state[2] & in;
    assign next_state[0] = next_state[0] | (state[2] & ~in);

    // S3 to S4 or S0
    assign next_state[4] = state[3] & in;
    assign next_state[0] = next_state[0] | (state[3] & ~in);

    // S4 to S5 or S0
    assign next_state[5] = state[4] & in;
    assign next_state[0] = next_state[0] | (state[4] & ~in);

    // S5 to S6 or S8
    assign next_state[6] = state[5] & in;
    assign next_state[8] = state[5] & ~in;

    // S6 to S7 or S9
    assign next_state[7] = state[6] & in;
    assign next_state[9] = state[6] & ~in;

    // S7 (self-loop or to S0)
    assign next_state[7] = next_state[7] | (state[7] & in);
    assign next_state[0] = next_state[0] | (state[7] & ~in);
    assign out2 = state[7];

    // S8 (to S1 or S0)
    assign next_state[1] = next_state[1] | (state[8] & in);
    assign next_state[0] = next_state[0] | (state[8] & ~in);
    assign out1 = state[8];

    // S9 (to S1 or S0)
    assign next_state[1] = next_state[1] | (state[9] & in);
    assign next_state[0] = next_state[0] | (state[9] & ~in);
    assign out1 = out1 | state[9];
    assign out2 = out2 | state[9];

endmodule