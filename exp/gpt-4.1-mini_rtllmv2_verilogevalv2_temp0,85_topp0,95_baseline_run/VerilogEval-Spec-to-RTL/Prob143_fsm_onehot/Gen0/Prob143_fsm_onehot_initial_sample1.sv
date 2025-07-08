module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);
    // Next state signals for each state S0..S9
    wire ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;
    wire o1, o2;

    // For each current state and input, determine next states
    // Multiple states active, so accumulate next states

    // S0 (state[0])
    wire ns0_S0_0 = state[0] & (~in); // S0 --0--> S0
    wire ns1_S0_1 = state[0] & in;    // S0 --1--> S1

    // S1 (state[1])
    wire ns0_S1_0 = state[1] & (~in); // S1 --0--> S0
    wire ns2_S1_1 = state[1] & in;    // S1 --1--> S2

    // S2 (state[2])
    wire ns0_S2_0 = state[2] & (~in); // S2 --0--> S0
    wire ns3_S2_1 = state[2] & in;    // S2 --1--> S3

    // S3 (state[3])
    wire ns0_S3_0 = state[3] & (~in); // S3 --0--> S0
    wire ns4_S3_1 = state[3] & in;    // S3 --1--> S4

    // S4 (state[4])
    wire ns0_S4_0 = state[4] & (~in); // S4 --0--> S0
    wire ns5_S4_1 = state[4] & in;    // S4 --1--> S5

    // S5 (state[5])
    wire ns8_S5_0 = state[5] & (~in); // S5 --0--> S8
    wire ns6_S5_1 = state[5] & in;    // S5 --1--> S6

    // S6 (state[6])
    wire ns9_S6_0 = state[6] & (~in); // S6 --0--> S9
    wire ns7_S6_1 = state[6] & in;    // S6 --1--> S7

    // S7 (state[7])
    wire ns0_S7_0 = state[7] & (~in); // S7 --0--> S0
    wire ns7_S7_1 = state[7] & in;    // S7 --1--> S7

    // S8 (state[8])
    wire ns0_S8_0 = state[8] & (~in); // S8 --0--> S0
    wire ns1_S8_1 = state[8] & in;    // S8 --1--> S1

    // S9 (state[9])
    wire ns0_S9_0 = state[9] & (~in); // S9 --0--> S0
    wire ns1_S9_1 = state[9] & in;    // S9 --1--> S1

    // Combine all next state assignments (OR all transitions leading to each state)
    assign ns0 = ns0_S0_0 | ns0_S1_0 | ns0_S2_0 | ns0_S3_0 | ns0_S4_0 | ns0_S7_0 | ns0_S8_0 | ns0_S9_0;
    assign ns1 = ns1_S0_1 | ns1_S8_1 | ns1_S9_1;
    assign ns2 = ns2_S1_1;
    assign ns3 = ns3_S2_1;
    assign ns4 = ns4_S3_1;
    assign ns5 = ns5_S4_1;
    assign ns6 = ns6_S5_1;
    assign ns7 = ns7_S6_1 | ns7_S7_1;
    assign ns8 = ns8_S5_0;
    assign ns9 = ns9_S6_0;

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs:
    // All zero except:
    // S7: out2 = 1 (state[7])
    // S8: out1 = 1 (state[8])
    // S9: out1=1, out2=1 (state[9])
    assign o1 = (state[8]) | (state[9]);
    assign o2 = (state[7]) | (state[9]);

    assign out1 = o1;
    assign out2 = o2;

endmodule