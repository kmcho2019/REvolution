module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate wires for next_state[0] transitions (multiple states transition to S0 on in==0)
    wire ns0_from_s0 = state[0] & ~in;
    wire ns0_from_s1 = state[1] & ~in;
    wire ns0_from_s2 = state[2] & ~in;
    wire ns0_from_s3 = state[3] & ~in;
    wire ns0_from_s4 = state[4] & ~in;
    wire ns0_from_s7 = state[7] & ~in;
    wire ns0_from_s8 = state[8] & ~in;
    wire ns0_from_s9 = state[9] & ~in;

    assign next_state[0] = ns0_from_s0 | ns0_from_s1 | ns0_from_s2 | ns0_from_s3 |
                           ns0_from_s4 | ns0_from_s7 | ns0_from_s8 | ns0_from_s9;

    // Direct combinational assignments for other next_state bits reflecting all transitions
    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Outputs:
    // out1 = 1 if currently in S8 or S9 (state[8] or state[9])
    // out2 = 1 if currently in S7 or S9 (state[7] or state[9])
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule