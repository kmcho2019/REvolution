module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] (S0) active if:
    // On input 0, from states: S0, S1, S2, S3, S4, S7, S8, S9
    assign next_state[0] = zero_in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]);

    // next_state[1] (S1) from: S0, S8, S9 with input 1
    assign next_state[1] = one_in & (state[0] | state[8] | state[9]);

    // next_state[2] (S2) from: S1 with input 1
    assign next_state[2] = one_in & state[1];

    // next_state[3] (S3) from: S2 with input 1
    assign next_state[3] = one_in & state[2];

    // next_state[4] (S4) from: S3 with input 1
    assign next_state[4] = one_in & state[3];

    // next_state[5] (S5) from: S4 with input 1
    assign next_state[5] = one_in & state[4];

    // next_state[6] (S6) from: S5 with input 1
    assign next_state[6] = one_in & state[5];

    // next_state[7] (S7) from: S6 and S7 with input 1
    assign next_state[7] = one_in & (state[6] | state[7]);

    // next_state[8] (S8) from: S5 with input 0
    assign next_state[8] = zero_in & state[5];

    // next_state[9] (S9) from: S6 with input 0
    assign next_state[9] = zero_in & state[6];

    // Outputs:
    // out1 = 1 if state includes S8 or S9
    assign out1 = state[8] | state[9];
    // out2 = 1 if state includes S7 or S9
    assign out2 = state[7] | state[9];

endmodule