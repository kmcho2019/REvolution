module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] is active when any of these current states receive input=0:
    // S0, S1, S2, S3, S4, S7, S8, S9
    assign next_state[0] =
        (state[0] & zero_in) |
        (state[1] & zero_in) |
        (state[2] & zero_in) |
        (state[3] & zero_in) |
        (state[4] & zero_in) |
        (state[7] & zero_in) |
        (state[8] & zero_in) |
        (state[9] & zero_in);

    // next_state[1] is active from S0, S8, S9 with input=1
    assign next_state[1] =
        (state[0] & one_in) |
        (state[8] & one_in) |
        (state[9] & one_in);

    // next_state[2] from S1 and input=1
    assign next_state[2] = state[1] & one_in;

    // next_state[3] from S2 and input=1
    assign next_state[3] = state[2] & one_in;

    // next_state[4] from S3 and input=1
    assign next_state[4] = state[3] & one_in;

    // next_state[5] from S4 and input=1
    assign next_state[5] = state[4] & one_in;

    // next_state[6] from S5 and input=1
    assign next_state[6] = state[5] & one_in;

    // next_state[7] from S6 or S7 and input=1
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);

    // next_state[8] from S5 and input=0
    assign next_state[8] = state[5] & zero_in;

    // next_state[9] from S6 and input=0
    assign next_state[9] = state[6] & zero_in;

    // Outputs computed as direct OR of the indicated states
    assign out1 = (state[8] | state[9]);
    assign out2 = (state[7] | state[9]);

endmodule