module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate wires for each possible transition to next states
    wire ns0_from_s0, ns0_from_s1, ns0_from_s2, ns0_from_s3, ns0_from_s4;
    wire ns0_from_s7, ns0_from_s8, ns0_from_s9;

    assign ns0_from_s0 = state[0] & ~in;
    assign ns0_from_s1 = state[1] & ~in;
    assign ns0_from_s2 = state[2] & ~in;
    assign ns0_from_s3 = state[3] & ~in;
    assign ns0_from_s4 = state[4] & ~in;
    assign ns0_from_s7 = state[7] & ~in;
    assign ns0_from_s8 = state[8] & ~in;
    assign ns0_from_s9 = state[9] & ~in;

    assign next_state[0] = ns0_from_s0 | ns0_from_s1 | ns0_from_s2 | ns0_from_s3 | 
                           ns0_from_s4 | ns0_from_s7 | ns0_from_s8 | ns0_from_s9;

    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    assign out1 = |(state & 10'b1100000000); // state[9] or state[8]
    assign out2 = state[7] | state[9];

endmodule