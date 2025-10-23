module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical OR tree for states that transition to S0 on input 0
    wire group1 = state[0] | state[1] | state[2];   // S0, S1, S2
    wire group2 = state[3] | state[4];              // S3, S4
    wire group3 = state[7] | state[8] | state[9];   // S7, S8, S9

    assign next_state[0] = (group1 & zero_in) | (group2 & zero_in) | (group3 & zero_in);

    // next_state[1] from S0, S8, S9 on input 1
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;

    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;

    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs from states with specified output bits
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule