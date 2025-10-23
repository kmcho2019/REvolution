module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define input complements for readability
    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical grouping of state bits to reduce fan-in for next_state[0]
    // next_state[0] = states that go to S0 on input=0
    wire ns0_group1 = (state[0] | state[1] | state[2]) & zero_in;
    wire ns0_group2 = (state[3] | state[4]) & zero_in;
    wire ns0_group3 = (state[7] | state[8] | state[9]) & zero_in;
    assign next_state[0] = ns0_group1 | ns0_group2 | ns0_group3;

    // Direct, explicit assignments for other next_state bits
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Output masks for clarity and synthesis efficiency
    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9); // out1 = 1 if in S8 or S9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // out2 = 1 if in S7 or S9

    // Outputs: OR reduction of masked state bits
    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule