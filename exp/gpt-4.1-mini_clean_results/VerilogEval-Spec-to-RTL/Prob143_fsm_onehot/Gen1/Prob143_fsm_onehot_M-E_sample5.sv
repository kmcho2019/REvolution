module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Current state one-hot bits for clarity
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

    // next_state bits derived from the FSM transitions:
    // For each next state, OR all sources that transit into it based on input

    // next_state[0] = S0 next states: from S0(0),S1(0),S2(0),S3(0),S4(0),S7(0),S8(0),S9(0)
    wire next_s0_from_s0 = s0 & (~in);
    wire next_s0_from_s1 = s1 & (~in);
    wire next_s0_from_s2 = s2 & (~in);
    wire next_s0_from_s3 = s3 & (~in);
    wire next_s0_from_s4 = s4 & (~in);
    wire next_s0_from_s7 = s7 & (~in);
    wire next_s0_from_s8 = s8 & (~in);
    wire next_s0_from_s9 = s9 & (~in);
    wire next_state0 = next_s0_from_s0 | next_s0_from_s1 | next_s0_from_s2 | next_s0_from_s3 | next_s0_from_s4 | next_s0_from_s7 | next_s0_from_s8 | next_s0_from_s9;

    // next_state[1] = S1 next states: from S0(1),S8(1),S9(1)
    wire next_s1_from_s0 = s0 & in;
    wire next_s1_from_s8 = s8 & in;
    wire next_s1_from_s9 = s9 & in;
    wire next_state1 = next_s1_from_s0 | next_s1_from_s8 | next_s1_from_s9;

    // next_state[2] = S2 next states: from S1(1)
    wire next_state2 = s1 & in;

    // next_state[3] = S3 next states: from S2(1)
    wire next_state3 = s2 & in;

    // next_state[4] = S4 next states: from S3(1)
    wire next_state4 = s3 & in;

    // next_state[5] = S5 next states: from S4(1)
    wire next_state5 = s4 & in;

    // next_state[6] = S6 next states: from S5(1)
    wire next_state6 = s5 & in;

    // next_state[7] = S7 next states: from S6(1), S7(1)
    wire next_s7_from_s6 = s6 & in;
    wire next_s7_from_s7 = s7 & in;
    wire next_state7 = next_s7_from_s6 | next_s7_from_s7;

    // next_state[8] = S8 next states: from S5(0)
    wire next_state8 = s5 & (~in);

    // next_state[9] = S9 next states: from S6(0)
    wire next_state9 = s6 & (~in);

    assign next_state = {next_state9, next_state8, next_state7, next_state6, next_state5, next_state4, next_state3, next_state2, next_state1, next_state0};

    // Outputs:
    // out1 = OR of out1 contributions of all active states
    // out2 = OR of out2 contributions of all active states
    // Only S7(0,1), S8(1,0), S9(1,1) have non-zero outputs

    wire out1_s7 = 1'b0; // S7 out1=0
    wire out2_s7 = 1'b1;
    wire out1_s8 = 1'b1;
    wire out2_s8 = 1'b0;
    wire out1_s9 = 1'b1;
    wire out2_s9 = 1'b1;

    // Combine outputs across all active states
    assign out1 = (s7 & out1_s7) | (s8 & out1_s8) | (s9 & out1_s9);
    assign out2 = (s7 & out2_s7) | (s8 & out2_s8) | (s9 & out2_s9);

endmodule