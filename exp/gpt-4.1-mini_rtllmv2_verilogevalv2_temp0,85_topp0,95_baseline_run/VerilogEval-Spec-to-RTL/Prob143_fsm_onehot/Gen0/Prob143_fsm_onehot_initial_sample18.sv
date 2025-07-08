module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state signals for each state
    wire ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;

    // From S0
    // S0(0,0) --0--> S0
    // S0(0,0) --1--> S1
    wire s0_0 = state[0] & ~in;
    wire s0_1 = state[0] &  in;

    // From S1
    // S1(0,0) --0--> S0
    // S1(0,0) --1--> S2
    wire s1_0 = state[1] & ~in;
    wire s1_2 = state[1] &  in;

    // From S2
    // S2(0,0) --0--> S0
    // S2(0,0) --1--> S3
    wire s2_0 = state[2] & ~in;
    wire s2_3 = state[2] &  in;

    // From S3
    // S3(0,0) --0--> S0
    // S3(0,0) --1--> S4
    wire s3_0 = state[3] & ~in;
    wire s3_4 = state[3] &  in;

    // From S4
    // S4(0,0) --0--> S0
    // S4(0,0) --1--> S5
    wire s4_0 = state[4] & ~in;
    wire s4_5 = state[4] &  in;

    // From S5
    // S5(0,0) --0--> S8
    // S5(0,0) --1--> S6
    wire s5_8 = state[5] & ~in;
    wire s5_6 = state[5] &  in;

    // From S6
    // S6(0,0) --0--> S9
    // S6(0,0) --1--> S7
    wire s6_9 = state[6] & ~in;
    wire s6_7 = state[6] &  in;

    // From S7
    // S7(0,1) --0--> S0
    // S7(0,1) --1--> S7
    wire s7_0 = state[7] & ~in;
    wire s7_7 = state[7] &  in;

    // From S8
    // S8(1,0) --0--> S0
    // S8(1,0) --1--> S1
    wire s8_0 = state[8] & ~in;
    wire s8_1 = state[8] &  in;

    // From S9
    // S9(1,1) --0--> S0
    // S9(1,1) --1--> S1
    wire s9_0 = state[9] & ~in;
    wire s9_1 = state[9] &  in;

    // next_state is OR of all transitions to each state
    assign ns0 = s0_0 | s1_0 | s2_0 | s3_0 | s4_0 | s7_0 | s8_0 | s9_0;
    assign ns1 = s0_1 | s8_1 | s9_1;
    assign ns2 = s1_2;
    assign ns3 = s2_3;
    assign ns4 = s3_4;
    assign ns5 = s4_5;
    assign ns6 = s5_6;
    assign ns7 = s6_7 | s7_7;
    assign ns8 = s5_8;
    assign ns9 = s6_9;

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs:
    // Only S7, S8 and S9 produce outputs
    // S7 = (0,1)
    // S8 = (1,0)
    // S9 = (1,1)
    assign out1 = (state[8]) | (state[9]);
    assign out2 = (state[7]) | (state[9]);

endmodule