module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical OR grouping for next_state[0] (next state S0 on input 0)
    // States transitioning to S0 on input 0: S0, S1, S2, S3, S4, S7, S8, S9
    // Split into three balanced groups, then combine:
    wire group0 = state[0] | state[1];             // S0, S1
    wire group1 = state[2] | state[3];             // S2, S3
    wire group2 = state[4];                         // S4
    wire group3 = state[7];                         // S7
    wire group4 = state[8] | state[9];             // S8, S9

    wire mid_groupA = group0 | group1;             // S0, S1, S2, S3
    wire mid_groupB = group2 | group3;             // S4, S7

    // Final next_state[0] combining all groups with zero_in
    assign next_state[0] = (mid_groupA & zero_in) 
                        | (mid_groupB & zero_in)
                        | (group4 & zero_in);

    // Direct combinational assignments for other next_state bits:
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs: use localparam masks with explicit reduction OR for clarity and synthesis friendliness
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);  // out1: active for states S8 or S9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);  // out2: active for states S7 or S9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule