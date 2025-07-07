module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state bits
    wire [9:0] ns;

    // For each state, determine next state bits based on input and current state bit
    // S0 (state[0])
    wire [9:0] ns_S0 = (state[0]) ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // S1 (state[1])
    wire [9:0] ns_S1 = (state[1]) ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    // S2 (state[2])
    wire [9:0] ns_S2 = (state[2]) ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // S3 (state[3])
    wire [9:0] ns_S3 = (state[3]) ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    // S4 (state[4])
    wire [9:0] ns_S4 = (state[4]) ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0;
    // S5 (state[5])
    wire [9:0] ns_S5 = (state[5]) ? (in ? 10'b0000010000 : 10'b1000000000) : 10'b0;
    // S6 (state[6])
    wire [9:0] ns_S6 = (state[6]) ? (in ? 10'b0100000000 : 10'b1000000000) : 10'b0;
    // S7 (state[7])
    wire [9:0] ns_S7 = (state[7]) ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0;
    // S8 (state[8])
    wire [9:0] ns_S8 = (state[8]) ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    // S9 (state[9])
    wire [9:0] ns_S9 = (state[9]) ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0;

    // Combine all next states (OR)
    assign next_state = ns_S0 | ns_S1 | ns_S2 | ns_S3 | ns_S4 | ns_S5 | ns_S6 | ns_S7 | ns_S8 | ns_S9;

    // Outputs:
    // out1 = 1 only in S8 and S9
    // out2 = 1 only in S7 and S9
    assign out1 = (state[8] | state[9]);
    assign out2 = (state[7] | state[9]);

endmodule