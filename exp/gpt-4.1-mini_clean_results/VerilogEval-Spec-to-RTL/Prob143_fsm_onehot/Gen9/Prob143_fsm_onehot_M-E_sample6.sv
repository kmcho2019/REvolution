module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Decode current states into individual wires for clarity
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire s4 = state[4];
    wire s5 = state[5];
    wire s6 = state[6];
    wire s7 = state[7];
    wire s8 = state[8];
    wire s9 = state[9];

    // Compute next_state bits by OR of all conditions leading to that next state
    assign next_state[0] = (s0 & ~in) | (s1 & ~in) | (s2 & ~in) | (s3 & ~in) |
                           (s4 & ~in) | (s7 & ~in) | (s8 & ~in) | (s9 & ~in);

    assign next_state[1] = (s0 & in) | (s8 & in) | (s9 & in);
    assign next_state[2] = s1 & in;
    assign next_state[3] = s2 & in;
    assign next_state[4] = s3 & in;
    assign next_state[5] = s4 & in;
    assign next_state[6] = s5 & in;
    assign next_state[7] = (s6 & in) | (s7 & in);
    assign next_state[8] = s5 & ~in;
    assign next_state[9] = s6 & ~in;

    // Outputs are only asserted for specified states, otherwise zero
    // out1: high if S8 or S9 active
    assign out1 = s8 | s9;

    // out2: high if S7 or S9 active
    assign out2 = s7 | s9;

endmodule