module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // State encoding for readability
    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
               S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

    wire zero_in = ~in;
    wire one_in  =  in;

    // Optimize next_state[0]: combine all states that go to S0 on input=0 into a single OR,
    // then AND with zero_in to reduce gate count and depth.
    wire states_to_S0_on_0 = state[S0] | state[S1] | state[S2] | state[S3] | state[S4] |
                             state[S7] | state[S8] | state[S9];
    assign next_state[S0] = states_to_S0_on_0 & zero_in;

    // Other next_state signals as flat assignments for clarity and minimal logic:
    assign next_state[S1] = (state[S0] | state[S8] | state[S9]) & one_in;
    assign next_state[S2] = state[S1] & one_in;
    assign next_state[S3] = state[S2] & one_in;
    assign next_state[S4] = state[S3] & one_in;
    assign next_state[S5] = state[S4] & one_in;
    assign next_state[S6] = state[S5] & one_in;
    assign next_state[S7] = (state[S6] | state[S7]) & one_in;
    assign next_state[S8] = state[S5] & zero_in;
    assign next_state[S9] = state[S6] & zero_in;

    // Output logic optimized using explicit OR expressions instead of bitmask + reduction:
    // out1 = 1 if in S8 or S9
    assign out1 = state[S8] | state[S9];

    // out2 = 1 if in S7 or S9
    assign out2 = state[S7] | state[S9];

endmodule