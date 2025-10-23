module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical grouping to reduce fan-in for next_state[0]
    wire ns0_groupA = (state[0] | state[1] | state[2]) & zero_in; // S0, S1, S2
    wire ns0_groupB = (state[3] | state[4]) & zero_in;            // S3, S4
    wire ns0_groupC = (state[7] | state[8] | state[9]) & zero_in; // S7, S8, S9

    assign next_state[0] = ns0_groupA | ns0_groupB | ns0_groupC;

    // Direct combinational assignments for other next_state bits
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs: use masked bitwise OR for clear and efficient logic
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // bits 9 and 8 set
    localparam [9:0] MASK_OUT2 = 10'b1000000000; // bits 9 and 7 set (note: 7th bit means bit 7)

    // out1 = state[8] | state[9]
    assign out1 = |(state & MASK_OUT1);

    // out2 = state[7] | state[9]
    assign out2 = |(state & ((1 << 7) | (1 << 9)));

endmodule