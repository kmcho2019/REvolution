module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[i] is 1 if any current active state transitions to Si given input in

    // According to FSM:
    // S0 -> S0 if in=0, else S1
    // S1 -> S0 if in=0, else S2
    // S2 -> S0 if in=0, else S3
    // S3 -> S0 if in=0, else S4
    // S4 -> S0 if in=0, else S5
    // S5 -> S8 if in=0, else S6
    // S6 -> S9 if in=0, else S7
    // S7 -> S0 if in=0, else S7
    // S8 -> S0 if in=0, else S1
    // S9 -> S0 if in=0, else S1

    // next_state[0] = from any state that transitions to S0 on given input:
    // from S0 on in=0
    // from S1 on in=0
    // from S2 on in=0
    // from S3 on in=0
    // from S4 on in=0
    // from S7 on in=0
    // from S8 on in=0
    // from S9 on in=0
    wire s0_to_s0 = state[0] & ~in;
    wire s1_to_s0 = state[1] & ~in;
    wire s2_to_s0 = state[2] & ~in;
    wire s3_to_s0 = state[3] & ~in;
    wire s4_to_s0 = state[4] & ~in;
    wire s7_to_s0 = state[7] & ~in;
    wire s8_to_s0 = state[8] & ~in;
    wire s9_to_s0 = state[9] & ~in;

    // next_state[1] = from S0 on in=1, from S8 on in=1, from S9 on in=1
    wire s0_to_s1 = state[0] & in;
    wire s8_to_s1 = state[8] & in;
    wire s9_to_s1 = state[9] & in;

    // next_state[2] = from S1 on in=1
    wire s1_to_s2 = state[1] & in;

    // next_state[3] = from S2 on in=1
    wire s2_to_s3 = state[2] & in;

    // next_state[4] = from S3 on in=1
    wire s3_to_s4 = state[3] & in;

    // next_state[5] = from S4 on in=1
    wire s4_to_s5 = state[4] & in;

    // next_state[6] = from S5 on in=1
    wire s5_to_s6 = state[5] & in;

    // next_state[7] = from S6 on in=1, from S7 on in=1
    wire s6_to_s7 = state[6] & in;
    wire s7_to_s7 = state[7] & in;

    // next_state[8] = from S5 on in=0
    wire s5_to_s8 = state[5] & ~in;

    // next_state[9] = from S6 on in=0
    wire s6_to_s9 = state[6] & ~in;

    assign next_state[0] = s0_to_s0 | s1_to_s0 | s2_to_s0 | s3_to_s0 | s4_to_s0 | s7_to_s0 | s8_to_s0 | s9_to_s0;
    assign next_state[1] = s0_to_s1 | s8_to_s1 | s9_to_s1;
    assign next_state[2] = s1_to_s2;
    assign next_state[3] = s2_to_s3;
    assign next_state[4] = s3_to_s4;
    assign next_state[5] = s4_to_s5;
    assign next_state[6] = s5_to_s6;
    assign next_state[7] = s6_to_s7 | s7_to_s7;
    assign next_state[8] = s5_to_s8;
    assign next_state[9] = s6_to_s9;

    // Output logic:
    // out1 = 1 when S8 or S9 is active
    // out2 = 1 when S7 or S9 is active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule