module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next state signals for each state
    wire [9:0] ns;

    // Initialize all next state bits to zero
    // For each state bit active, determine next state based on input
    // Also accumulate outputs for states with outputs

    // S0 (state[0]): (out1,out2) = (0,0)
    // 0->S0(0), 1->S1(1)
    wire ns0_from_s0 = state[0] & ~in;
    wire ns1_from_s0 = state[0] &  in;

    // S1 (state[1]): (0,0)
    // 0->S0(0), 1->S2(2)
    wire ns0_from_s1 = state[1] & ~in;
    wire ns2_from_s1 = state[1] &  in;

    // S2 (state[2]): (0,0)
    // 0->S0(0), 1->S3(3)
    wire ns0_from_s2 = state[2] & ~in;
    wire ns3_from_s2 = state[2] &  in;

    // S3 (state[3]): (0,0)
    // 0->S0(0), 1->S4(4)
    wire ns0_from_s3 = state[3] & ~in;
    wire ns4_from_s3 = state[3] &  in;

    // S4 (state[4]): (0,0)
    // 0->S0(0), 1->S5(5)
    wire ns0_from_s4 = state[4] & ~in;
    wire ns5_from_s4 = state[4] &  in;

    // S5 (state[5]): (0,0)
    // 0->S8(8), 1->S6(6)
    wire ns8_from_s5 = state[5] & ~in;
    wire ns6_from_s5 = state[5] &  in;

    // S6 (state[6]): (0,0)
    // 0->S9(9), 1->S7(7)
    wire ns9_from_s6 = state[6] & ~in;
    wire ns7_from_s6 = state[6] &  in;

    // S7 (state[7]): (0,1)
    // 0->S0(0), 1->S7(7)
    wire ns0_from_s7 = state[7] & ~in;
    wire ns7_from_s7 = state[7] &  in;

    // S8 (state[8]): (1,0)
    // 0->S0(0), 1->S1(1)
    wire ns0_from_s8 = state[8] & ~in;
    wire ns1_from_s8 = state[8] &  in;

    // S9 (state[9]): (1,1)
    // 0->S0(0), 1->S1(1)
    wire ns0_from_s9 = state[9] & ~in;
    wire ns1_from_s9 = state[9] &  in;

    assign ns[0] = ns0_from_s0 | ns0_from_s1 | ns0_from_s2 | ns0_from_s3 | ns0_from_s4 |
                   ns0_from_s7 | ns0_from_s8 | ns0_from_s9;
    assign ns[1] = ns1_from_s0 | ns1_from_s8 | ns1_from_s9;
    assign ns[2] = ns2_from_s1;
    assign ns[3] = ns3_from_s2;
    assign ns[4] = ns4_from_s3;
    assign ns[5] = ns5_from_s4;
    assign ns[6] = ns6_from_s5;
    assign ns[7] = ns7_from_s6 | ns7_from_s7;
    assign ns[8] = ns8_from_s5;
    assign ns[9] = ns9_from_s6;

    assign next_state = ns;

    // Outputs:
    // out1 = 1 when in S8 or S9
    assign out1 = state[8] | state[9];

    // out2 = 1 when in S7 or S9
    assign out2 = state[7] | state[9];

endmodule