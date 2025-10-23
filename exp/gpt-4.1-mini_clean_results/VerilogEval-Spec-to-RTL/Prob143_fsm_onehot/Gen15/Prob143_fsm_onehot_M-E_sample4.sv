module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] is active if input=0 and current state is one of:
    // S0, S1, S2, S3, S4, S7, S8, S9
    assign next_state[0] = (
        (state[0]) |
        (state[1]) |
        (state[2]) |
        (state[3]) |
        (state[4]) |
        (state[7]) |
        (state[8]) |
        (state[9])
    ) & zero_in;

    // next_state[1] active if input=1 and current state is S0, S8, or S9
    assign next_state[1] = (
        (state[0]) |
        (state[8]) |
        (state[9])
    ) & one_in;

    // next_state[2] active if input=1 and current state is S1
    assign next_state[2] = state[1] & one_in;

    // next_state[3] active if input=1 and current state is S2
    assign next_state[3] = state[2] & one_in;

    // next_state[4] active if input=1 and current state is S3
    assign next_state[4] = state[3] & one_in;

    // next_state[5] active if input=1 and current state is S4
    assign next_state[5] = state[4] & one_in;

    // next_state[6] active if input=1 and current state is S5
    assign next_state[6] = state[5] & one_in;

    // next_state[7] active if input=1 and current state is S6 or S7
    assign next_state[7] = (state[6] | state[7]) & one_in;

    // next_state[8] active if input=0 and current state is S5
    assign next_state[8] = state[5] & zero_in;

    // next_state[9] active if input=0 and current state is S6
    assign next_state[9] = state[6] & zero_in;

    // Outputs: out1 = 1 if current state is S8 or S9
    assign out1 = state[8] | state[9];

    // Outputs: out2 = 1 if current state is S7 or S9
    assign out2 = state[7] | state[9];

endmodule