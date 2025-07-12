module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Group states based on next state transitions

    // States that go to S0 on input=0
    wire any_S0_0 = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & ~in;

    // next_state signals
    wire next_S0 = any_S0_0;

    wire next_S1 = ((state[0] | state[8] | state[9]) & in);
    wire next_S2 = (state[1] & in);
    wire next_S3 = (state[2] & in);
    wire next_S4 = (state[3] & in);
    wire next_S5 = (state[4] & in);
    wire next_S6 = (state[5] & in);
    wire next_S7 = (state[6] & in) | (state[7] & in);
    wire next_S8 = (state[5] & ~in);
    wire next_S9 = (state[6] & ~in);

    assign next_state[0] = next_S0;
    assign next_state[1] = next_S1;
    assign next_state[2] = next_S2;
    assign next_state[3] = next_S3;
    assign next_state[4] = next_S4;
    assign next_state[5] = next_S5;
    assign next_state[6] = next_S6;
    assign next_state[7] = next_S7;
    assign next_state[8] = next_S8;
    assign next_state[9] = next_S9;

    // Outputs directly decoded from states with outputs
    // S7 outputs (0,1), S8 outputs (1,0), S9 outputs (1,1)
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule