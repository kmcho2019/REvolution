module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // For each next state, determine which current states and input cause transition to it.
    // next_state[SX] = OR over all states that transition to SX when in is applied.

    // next_state[0] (S0) is next on input=0 from states: S0, S1, S2, S3, S4, S7, S8, S9
    assign next_state[0] = (
        (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & zero_in
    );

    // next_state[1] (S1) is next on input=1 from states: S0, S8, S9
    assign next_state[1] = (
        (state[0] | state[8] | state[9]) & one_in
    );

    // next_state[2] (S2) is next on input=1 from state: S1
    assign next_state[2] = state[1] & one_in;

    // next_state[3] (S3) is next on input=1 from state: S2
    assign next_state[3] = state[2] & one_in;

    // next_state[4] (S4) is next on input=1 from state: S3
    assign next_state[4] = state[3] & one_in;

    // next_state[5] (S5) is next on input=1 from state: S4
    assign next_state[5] = state[4] & one_in;

    // next_state[6] (S6) is next on input=1 from state: S5
    assign next_state[6] = state[5] & one_in;

    // next_state[7] (S7) is next on input=1 from states: S6, S7
    assign next_state[7] = (state[6] | state[7]) & one_in;

    // next_state[8] (S8) is next on input=0 from state: S5
    assign next_state[8] = state[5] & zero_in;

    // next_state[9] (S9) is next on input=0 from state: S6
    assign next_state[9] = state[6] & zero_in;

    // Outputs:
    // out1 = 1 if in states S8 or S9
    assign out1 = state[8] | state[9];

    // out2 = 1 if in states S7 or S9
    assign out2 = state[7] | state[9];

endmodule