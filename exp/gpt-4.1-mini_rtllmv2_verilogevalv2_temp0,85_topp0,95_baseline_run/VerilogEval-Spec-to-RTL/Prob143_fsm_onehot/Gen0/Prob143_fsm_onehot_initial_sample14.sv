module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state signals for each state based on input 'in'
    wire [9:0] ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;

    // For each active state, determine the next state bits based on 'in'
    // S0: 0->S0, 1->S1
    assign ns0[0] = state[0] & (~in);
    assign ns0[1] = state[0] & in;

    // S1: 0->S0, 1->S2
    assign ns1[0] = state[1] & (~in);
    assign ns1[2] = state[1] & in;

    // S2: 0->S0, 1->S3
    assign ns2[0] = state[2] & (~in);
    assign ns2[3] = state[2] & in;

    // S3: 0->S0, 1->S4
    assign ns3[0] = state[3] & (~in);
    assign ns3[4] = state[3] & in;

    // S4: 0->S0, 1->S5
    assign ns4[0] = state[4] & (~in);
    assign ns4[5] = state[4] & in;

    // S5: 0->S8, 1->S6
    assign ns5[8] = state[5] & (~in);
    assign ns5[6] = state[5] & in;

    // S6: 0->S9, 1->S7
    assign ns6[9] = state[6] & (~in);
    assign ns6[7] = state[6] & in;

    // S7: 0->S0, 1->S7
    assign ns7[0] = state[7] & (~in);
    assign ns7[7] = state[7] & in;

    // S8: 0->S0, 1->S1
    assign ns8[0] = state[8] & (~in);
    assign ns8[1] = state[8] & in;

    // S9: 0->S0, 1->S1
    assign ns9[0] = state[9] & (~in);
    assign ns9[1] = state[9] & in;

    // Combine all next state contributions by OR
    assign next_state = ns0 | ns1 | ns2 | ns3 | ns4 | ns5 | ns6 | ns7 | ns8 | ns9;

    // Outputs are zero unless otherwise specified:
    // S7 outputs (0,1)
    // S8 outputs (1,0)
    // S9 outputs (1,1)

    assign out1 = (state[8]) | (state[9]);  // out1 is 1 if state includes S8 or S9
    assign out2 = (state[7]) | (state[9]);  // out2 is 1 if state includes S7 or S9

endmodule