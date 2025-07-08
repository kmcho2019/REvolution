module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Compute next_state bits by ORing transitions from all active states
    wire [9:0] ns_S0, ns_S1, ns_S2, ns_S3, ns_S4, ns_S5, ns_S6, ns_S7, ns_S8, ns_S9;

    // From S0: (0,0) --0--> S0, --1--> S1
    assign ns_S0 = state[0] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // From S1: (0,0) --0--> S0, --1--> S2
    assign ns_S1 = state[1] ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    // From S2: (0,0) --0--> S0, --1--> S3
    assign ns_S2 = state[2] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // From S3: (0,0) --0--> S0, --1--> S4
    assign ns_S3 = state[3] ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    // From S4: (0,0) --0--> S0, --1--> S5
    assign ns_S4 = state[4] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    // From S5: (0,0) --0--> S8, --1--> S6
    assign ns_S5 = state[5] ? (in ? 10'b0001000000 : 10'b1000000000) : 10'b0;
    // From S6: (0,0) --0--> S9, --1--> S7
    assign ns_S6 = state[6] ? (in ? 10'b0100000000 : 10'b0010000000) : 10'b0;
    // From S7: (0,1) --0--> S0, --1--> S7
    assign ns_S7 = state[7] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // From S8: (1,0) --0--> S0, --1--> S1
    assign ns_S8 = state[8] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // From S9: (1,1) --0--> S0, --1--> S1
    assign ns_S9 = state[9] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;

    // Combine all next states
    assign next_state = ns_S0 | ns_S1 | ns_S2 | ns_S3 | ns_S4 | ns_S5 | ns_S6 | ns_S7 | ns_S8 | ns_S9;

    // Outputs: (out1, out2) = (0,1) in S7, (1,0) in S8, (1,1) in S9, else 0
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule