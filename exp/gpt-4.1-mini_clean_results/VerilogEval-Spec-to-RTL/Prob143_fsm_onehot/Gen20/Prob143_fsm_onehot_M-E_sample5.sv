module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Decode each active state bit into wires for clarity
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

    // Compute next_state bits as OR of all transitions from active states on input conditions

    // next_state[0] transitions to S0 on input=0 from multiple states
    wire ns0_from_s0 = s0 & ~in;
    wire ns0_from_s1 = s1 & ~in;
    wire ns0_from_s2 = s2 & ~in;
    wire ns0_from_s3 = s3 & ~in;
    wire ns0_from_s4 = s4 & ~in;
    wire ns0_from_s7 = s7 & ~in;
    wire ns0_from_s8 = s8 & ~in;
    wire ns0_from_s9 = s9 & ~in;

    assign next_state[0] = ns0_from_s0 | ns0_from_s1 | ns0_from_s2 | ns0_from_s3 | ns0_from_s4 | ns0_from_s7 | ns0_from_s8 | ns0_from_s9;

    // next_state[1] transitions to S1 on input=1 from S0, S8, and S9
    wire ns1_from_s0 = s0 & in;
    wire ns1_from_s8 = s8 & in;
    wire ns1_from_s9 = s9 & in;

    assign next_state[1] = ns1_from_s0 | ns1_from_s8 | ns1_from_s9;

    // next_state[2] = from S1 on in=1
    assign next_state[2] = s1 & in;

    // next_state[3] = from S2 on in=1
    assign next_state[3] = s2 & in;

    // next_state[4] = from S3 on in=1
    assign next_state[4] = s3 & in;

    // next_state[5] = from S4 on in=1
    assign next_state[5] = s4 & in;

    // next_state[6] = from S5 on in=1
    assign next_state[6] = s5 & in;

    // next_state[7] = from S6 on in=1 or from S7 on in=1
    wire ns7_from_s6 = s6 & in;
    wire ns7_from_s7 = s7 & in;
    assign next_state[7] = ns7_from_s6 | ns7_from_s7;

    // next_state[8] = from S5 on in=0
    assign next_state[8] = s5 & ~in;

    // next_state[9] = from S6 on in=0
    assign next_state[9] = s6 & ~in;

    // Outputs: 
    // out1 is 1 when S8 or S9 active
    assign out1 = s8 | s9;

    // out2 is 1 when S7 or S9 active
    assign out2 = s7 | s9;

endmodule