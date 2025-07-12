module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Balanced hierarchical OR grouping for next_state[0] to reduce fan-in:
    // States transitioning to S0 on input 0: S0, S1, S2, S3, S4, S7, S8, S9
    wire groupA = state[0] | state[1] | state[2];     // S0, S1, S2
    wire groupB = state[3] | state[4];                // S3, S4
    wire groupC = state[7] | state[8] | state[9];     // S7, S8, S9

    assign next_state[0] = (groupA & zero_in) | (groupB & zero_in) | (groupC & zero_in);

    // Other next_state bits: direct combinational assignments from FSM transitions
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] & one_in) | (state[7] & one_in);
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Output logic using bitmasking for concise OR reduction
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9);  // S8 or S9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9);  // S7 or S9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule