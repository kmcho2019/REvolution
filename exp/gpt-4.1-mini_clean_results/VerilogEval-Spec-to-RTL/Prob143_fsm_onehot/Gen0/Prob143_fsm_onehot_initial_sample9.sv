module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // For readability: alias input bit
    wire i = in;

    // We will create next_state signals by ORing transitions from all active states.
    // For each state, depending on input, we set the next state bit accordingly.

    // Declare next_state bits individually for clarity
    wire ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;

    // Outputs from each active state (ORed)
    wire o1, o2;

    // The FSM transitions as per the given state diagram:

    // S0 (state[0]):
    // 0->S0, 1->S1
    wire ns0_from_s0 = state[0] & (i == 0);
    wire ns1_from_s0 = state[0] & (i == 1);

    // S1 (state[1]):
    // 0->S0, 1->S2
    wire ns0_from_s1 = state[1] & (i == 0);
    wire ns2_from_s1 = state[1] & (i == 1);

    // S2 (state[2]):
    // 0->S0, 1->S3
    wire ns0_from_s2 = state[2] & (i == 0);
    wire ns3_from_s2 = state[2] & (i == 1);

    // S3 (state[3]):
    // 0->S0, 1->S4
    wire ns0_from_s3 = state[3] & (i == 0);
    wire ns4_from_s3 = state[3] & (i == 1);

    // S4 (state[4]):
    // 0->S0, 1->S5
    wire ns0_from_s4 = state[4] & (i == 0);
    wire ns5_from_s4 = state[4] & (i == 1);

    // S5 (state[5]):
    // 0->S8, 1->S6
    wire ns8_from_s5 = state[5] & (i == 0);
    wire ns6_from_s5 = state[5] & (i == 1);

    // S6 (state[6]):
    // 0->S9, 1->S7
    wire ns9_from_s6 = state[6] & (i == 0);
    wire ns7_from_s6 = state[6] & (i == 1);

    // S7 (state[7]):
    // outputs (0,1)
    // 0->S0, 1->S7
    wire ns0_from_s7 = state[7] & (i == 0);
    wire ns7_from_s7 = state[7] & (i == 1);

    // S8 (state[8]):
    // outputs (1,0)
    // 0->S0, 1->S1
    wire ns0_from_s8 = state[8] & (i == 0);
    wire ns1_from_s8 = state[8] & (i == 1);

    // S9 (state[9]):
    // outputs (1,1)
    // 0->S0, 1->S1
    wire ns0_from_s9 = state[9] & (i == 0);
    wire ns1_from_s9 = state[9] & (i == 1);

    // Assign next_state bits by ORing all transitions to that state:

    assign ns0 = ns0_from_s0 | ns0_from_s1 | ns0_from_s2 | ns0_from_s3 | ns0_from_s4 |
                 ns0_from_s7 | ns0_from_s8 | ns0_from_s9;

    assign ns1 = ns1_from_s0 | ns1_from_s8 | ns1_from_s9;

    assign ns2 = ns2_from_s1;

    assign ns3 = ns3_from_s2;

    assign ns4 = ns4_from_s3;

    assign ns5 = ns5_from_s4;

    assign ns6 = ns6_from_s5;

    assign ns7 = ns7_from_s6 | ns7_from_s7;

    assign ns8 = ns8_from_s5;

    assign ns9 = ns9_from_s6;

    assign next_state = {ns9, ns8, ns7, ns6, ns5, ns4, ns3, ns2, ns1, ns0};

    // Outputs out1 and out2:

    // From the specification:
    // Only S7 outputs (0,1) => out1=0, out2=1
    // Only S8 outputs (1,0) => out1=1, out2=0
    // Only S9 outputs (1,1) => out1=1, out2=1
    // All other states output (0,0)

    // If multiple states active, output is OR of each state's outputs.

    assign o1 = (state[8]) | (state[9]);       // out1 = 1 if S8 or S9 active
    assign o2 = (state[7]) | (state[9]);       // out2 = 1 if S7 or S9 active

    assign out1 = o1;
    assign out2 = o2;

endmodule