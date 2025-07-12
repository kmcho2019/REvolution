module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state signals initialization
    // For each next_state bit, accumulate contributions from all current states and input conditions

    wire zero = ~in;
    wire one  =  in;

    // From S0 (state[0])
    wire ns0_from_S0 = state[0] & zero; // S0 --0--> S0
    wire ns1_from_S0 = state[0] & one;  // S0 --1--> S1

    // From S1 (state[1])
    wire ns0_from_S1 = state[1] & zero; // S1 --0--> S0
    wire ns2_from_S1 = state[1] & one;  // S1 --1--> S2

    // From S2 (state[2])
    wire ns0_from_S2 = state[2] & zero; // S2 --0--> S0
    wire ns3_from_S2 = state[2] & one;  // S2 --1--> S3

    // From S3 (state[3])
    wire ns0_from_S3 = state[3] & zero; // S3 --0--> S0
    wire ns4_from_S3 = state[3] & one;  // S3 --1--> S4

    // From S4 (state[4])
    wire ns0_from_S4 = state[4] & zero; // S4 --0--> S0
    wire ns5_from_S4 = state[4] & one;  // S4 --1--> S5

    // From S5 (state[5])
    wire ns8_from_S5 = state[5] & zero; // S5 --0--> S8
    wire ns6_from_S5 = state[5] & one;  // S5 --1--> S6

    // From S6 (state[6])
    wire ns9_from_S6 = state[6] & zero; // S6 --0--> S9
    wire ns7_from_S6 = state[6] & one;  // S6 --1--> S7

    // From S7 (state[7])
    wire ns0_from_S7 = state[7] & zero; // S7 --0--> S0
    wire ns7_from_S7 = state[7] & one;  // S7 --1--> S7

    // From S8 (state[8])
    wire ns0_from_S8 = state[8] & zero; // S8 --0--> S0
    wire ns1_from_S8 = state[8] & one;  // S8 --1--> S1

    // From S9 (state[9])
    wire ns0_from_S9 = state[9] & zero; // S9 --0--> S0
    wire ns1_from_S9 = state[9] & one;  // S9 --1--> S1

    // Combine all contributions per next_state bit (OR accumulation)

    assign next_state[0] = ns0_from_S0 | ns0_from_S1 | ns0_from_S2 | ns0_from_S3 | ns0_from_S4 |
                           ns0_from_S7 | ns0_from_S8 | ns0_from_S9;

    assign next_state[1] = ns1_from_S0 | ns1_from_S8 | ns1_from_S9;

    assign next_state[2] = ns2_from_S1;

    assign next_state[3] = ns3_from_S2;

    assign next_state[4] = ns4_from_S3;

    assign next_state[5] = ns5_from_S4;

    assign next_state[6] = ns6_from_S5;

    assign next_state[7] = ns7_from_S6 | ns7_from_S7;

    assign next_state[8] = ns8_from_S5;

    assign next_state[9] = ns9_from_S6;

    // Outputs as OR of specified states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule