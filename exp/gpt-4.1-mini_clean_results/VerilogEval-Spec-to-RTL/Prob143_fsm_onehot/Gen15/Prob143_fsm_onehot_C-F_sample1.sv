module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Intermediate wires for groups of states transitioning to S0 (for balanced OR tree)
    wire ns0_from_groupA = (state[0] | state[1] | state[2]) & zero_in;   // S0, S1, S2
    wire ns0_from_groupB = (state[3] | state[4]) & zero_in;              // S3, S4
    wire ns0_from_groupC = (state[7] | state[8] | state[9]) & zero_in;   // S7, S8, S9

    assign next_state[0] = ns0_from_groupA | ns0_from_groupB | ns0_from_groupC;

    // Direct assignments for other next_state bits
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Outputs: combine concise bitmasking with explicit OR for clarity
    // out1: active for S8 or S9
    assign out1 = state[8] | state[9];

    // out2: active for S7 or S9
    assign out2 = state[7] | state[9];

endmodule