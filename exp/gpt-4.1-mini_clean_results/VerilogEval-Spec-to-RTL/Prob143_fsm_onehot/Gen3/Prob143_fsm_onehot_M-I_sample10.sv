module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state 0 transitions: from states S0, S1, S2, S3, S4, S7, S8, S9 on input 0
    assign next_state[0] = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & ~in;

    // Other next states transitions on input conditions
    assign next_state[1] = (state[0] | state[8] | state[9]) & in;
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] | state[7]) & in;
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Outputs out1 = state[8] OR state[9], out2 = state[7] OR state[9]
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule