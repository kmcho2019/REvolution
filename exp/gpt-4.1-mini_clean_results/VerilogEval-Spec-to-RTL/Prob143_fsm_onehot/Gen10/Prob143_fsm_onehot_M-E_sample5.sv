module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Per-state next state vectors, initialized to zero
    wire [9:0] ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;

    // For each state, define next_state vector according to the FSM and input 'in'
    assign ns0 = state[0] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;  // S0: --0--> S0, --1--> S1
    assign ns1 = state[1] ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0;  // S1: --0--> S0, --1--> S2
    assign ns2 = state[2] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;  // S2: --0--> S0, --1--> S3
    assign ns3 = state[3] ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0;  // S3: --0--> S0, --1--> S4
    assign ns4 = state[4] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;  // S4: --0--> S0, --1--> S5
    assign ns5 = state[5] ? (in ? 10'b0001000000 : 10'b0000010000) : 10'b0;  // S5: --0--> S8, --1--> S6
    assign ns6 = state[6] ? (in ? 10'b0010000000 : 10'b0100000000) : 10'b0;  // S6: --0--> S9, --1--> S7
    assign ns7 = state[7] ? (in ? 10'b1000000000 : 10'b0000000001) : 10'b0;  // S7: --0--> S0, --1--> S7
    assign ns8 = state[8] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;  // S8: --0--> S0, --1--> S1
    assign ns9 = state[9] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;  // S9: --0--> S0, --1--> S1

    // Aggregate all next states by ORing all partial next state vectors
    assign next_state = ns0 | ns1 | ns2 | ns3 | ns4 | ns5 | ns6 | ns7 | ns8 | ns9;

    // Outputs: out1 is high if S8 or S9 is active in current state
    //          out2 is high if S7 or S9 is active in current state
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule