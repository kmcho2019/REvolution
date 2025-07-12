module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Group states that transit to S0 on input 0
    wire to_S0_lower = state[0] | state[1] | state[2] | state[3] | state[4];
    wire to_S0_upper = state[7] | state[8] | state[9];

    // Simplified next_state[0]: combine OR terms before AND with zero_in for minimal logic
    assign next_state[0] = (to_S0_lower | to_S0_upper) & zero_in;

    // Explicit per-state next_state assignments for clarity and synthesis friendliness
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Output masks for concise, synthesis-friendly output logic
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // S8 and S9 for out1
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // S7 and S9 for out2

    // Outputs computed with masked OR reductions to support multi-hot states
    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule