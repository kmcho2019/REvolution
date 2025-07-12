module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate signals for transitions to each next state

    // Next state 0 transitions (to S0)
    wire s0_from_s0 = state[0] & ~in;
    wire s0_from_s1 = state[1] & ~in;
    wire s0_from_s2 = state[2] & ~in;
    wire s0_from_s3 = state[3] & ~in;
    wire s0_from_s4 = state[4] & ~in;
    wire s0_from_s7 = state[7] & ~in;
    wire s0_from_s8 = state[8] & ~in;
    wire s0_from_s9 = state[9] & ~in;

    assign next_state[0] = s0_from_s0 | s0_from_s1 | s0_from_s2 | s0_from_s3
                         | s0_from_s4 | s0_from_s7 | s0_from_s8 | s0_from_s9;

    // Next state 1 transitions (to S1)
    wire s1_from_s0 = state[0] & in;
    wire s1_from_s8 = state[8] & in;
    wire s1_from_s9 = state[9] & in;

    assign next_state[1] = s1_from_s0 | s1_from_s8 | s1_from_s9;

    // Next state 2 transition
    wire s2_from_s1 = state[1] & in;
    assign next_state[2] = s2_from_s1;

    // Next state 3 transition
    wire s3_from_s2 = state[2] & in;
    assign next_state[3] = s3_from_s2;

    // Next state 4 transition
    wire s4_from_s3 = state[3] & in;
    assign next_state[4] = s4_from_s3;

    // Next state 5 transition
    wire s5_from_s4 = state[4] & in;
    assign next_state[5] = s5_from_s4;

    // Next state 6 transition
    wire s6_from_s5 = state[5] & in;
    assign next_state[6] = s6_from_s5;

    // Next state 7 transitions
    wire s7_from_s6 = state[6] & in;
    wire s7_from_s7 = state[7] & in;
    assign next_state[7] = s7_from_s6 | s7_from_s7;

    // Next state 8 transition
    wire s8_from_s5 = state[5] & ~in;
    assign next_state[8] = s8_from_s5;

    // Next state 9 transition
    wire s9_from_s6 = state[6] & ~in;
    assign next_state[9] = s9_from_s6;

    // Outputs computed from current states

    // out1 = 1 if in S8 or S9
    wire out1_s8 = state[8];
    wire out1_s9 = state[9];
    assign out1 = out1_s8 | out1_s9;

    // out2 = 1 if in S7 or S9
    wire out2_s7 = state[7];
    wire out2_s9 = state[9];
    assign out2 = out2_s7 | out2_s9;

endmodule