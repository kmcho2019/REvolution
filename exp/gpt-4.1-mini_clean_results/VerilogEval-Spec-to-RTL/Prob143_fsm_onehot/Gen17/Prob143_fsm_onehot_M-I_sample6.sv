module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Precompute common groups for area reduction and balanced OR tree
    wire low_states = state[0] | state[1] | state[2] | state[3] | state[4];  // S0 to S4
    wire high_states = state[7] | state[8] | state[9];                      // S7, S8, S9

    // Balanced OR tree for next_state[0] input=0 transitions:
    // States transitioning to S0 on input 0:
    // S0, S1, S2, S3, S4, S7, S8, S9
    // Combining to two groups plus state[7] explicitly (since it's not in low_states)
    wire group1 = low_states;            // S0 - S4
    wire group2 = high_states;           // S7, S8, S9

    // next_state[0] = (S0|S1|S2|S3|S4|S7|S8|S9) & ~in
    assign next_state[0] = (group1 | group2) & zero_in;

    // Direct combinational assignments with some sharing for next_state[1]
    // next_state[1] = (S0 | S8 | S9) & in
    wire s0_s8_s9 = state[0] | state[8] | state[9];
    assign next_state[1] = s0_s8_s9 & one_in;

    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs via bitmasking (maintain as is for minimal logic)
    localparam [9:0] MASK_OUT1 = 10'b0110000000;  // bits 8 and 9 set
    localparam [9:0] MASK_OUT2 = 10'b0100000010;  // bits 7 and 9 set

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule