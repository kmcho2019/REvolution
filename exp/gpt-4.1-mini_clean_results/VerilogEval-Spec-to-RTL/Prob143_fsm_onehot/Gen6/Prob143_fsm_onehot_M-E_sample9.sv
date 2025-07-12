module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);
    // Partial next_state vectors generated from each state block
    wire [9:0] ns_from_S0;
    wire [9:0] ns_from_S1;
    wire [9:0] ns_from_S2;
    wire [9:0] ns_from_S3;
    wire [9:0] ns_from_S4;
    wire [9:0] ns_from_S5;
    wire [9:0] ns_from_S6;
    wire [9:0] ns_from_S7;
    wire [9:0] ns_from_S8;
    wire [9:0] ns_from_S9;

    // From S0
    assign ns_from_S0 = in ? 10'b0000000010 : 10'b0000000001; // S1 or S0

    // From S1
    assign ns_from_S1 = in ? 10'b0000000100 : 10'b0000000001; // S2 or S0

    // From S2
    assign ns_from_S2 = in ? 10'b0000001000 : 10'b0000000001; // S3 or S0

    // From S3
    assign ns_from_S3 = in ? 10'b0000010000 : 10'b0000000001; // S4 or S0

    // From S4
    assign ns_from_S4 = in ? 10'b0000100000 : 10'b0000000001; // S5 or S0

    // From S5
    assign ns_from_S5 = in ? 10'b0000010000_00000000 : 10'b0010000000; // S6 or S8
    // Breaking above into 10 bits:
    // S6 is bit 6, S8 is bit 8
    // So: in=1: bit6=1, in=0: bit8=1
    assign ns_from_S5 = in ? (10'b0000000100 << 3) : (10'b0000000001 << 8); // 0x40 or 0x100

    // From S6
    assign ns_from_S6 = in ? 10'b0000001000000 : 10'b1000000000;
    // 10 bits: bit7 for S7, bit9 for S9
    assign ns_from_S6 = in ? (10'b0000000001 << 7) : (10'b0000000001 << 9);

    // From S7
    assign ns_from_S7 = in ? 10'b00000010000000 : 10'b0000000001;
    // S7 or S0
    // bit7 or bit0
    assign ns_from_S7 = in ? (10'b0000000001 << 7) : (10'b0000000001 << 0);

    // From S8
    assign ns_from_S8 = in ? 10'b0000000010 : 10'b0000000001; // S1 or S0

    // From S9
    assign ns_from_S9 = in ? 10'b0000000010 : 10'b0000000001; // S1 or S0

    // Now mask with current state to keep contribution only if state active
    wire [9:0] ns_from_S0_masked = ns_from_S0   & {10{state[0]}};
    wire [9:0] ns_from_S1_masked = ns_from_S1   & {10{state[1]}};
    wire [9:0] ns_from_S2_masked = ns_from_S2   & {10{state[2]}};
    wire [9:0] ns_from_S3_masked = ns_from_S3   & {10{state[3]}};
    wire [9:0] ns_from_S4_masked = ns_from_S4   & {10{state[4]}};
    wire [9:0] ns_from_S5_masked = ns_from_S5   & {10{state[5]}};
    wire [9:0] ns_from_S6_masked = ns_from_S6   & {10{state[6]}};
    wire [9:0] ns_from_S7_masked = ns_from_S7   & {10{state[7]}};
    wire [9:0] ns_from_S8_masked = ns_from_S8   & {10{state[8]}};
    wire [9:0] ns_from_S9_masked = ns_from_S9   & {10{state[9]}};

    // Combine all contributions with OR to get final next_state
    assign next_state = ns_from_S0_masked |
                        ns_from_S1_masked |
                        ns_from_S2_masked |
                        ns_from_S3_masked |
                        ns_from_S4_masked |
                        ns_from_S5_masked |
                        ns_from_S6_masked |
                        ns_from_S7_masked |
                        ns_from_S8_masked |
                        ns_from_S9_masked;

    // Outputs per state
    // out1=1 when in S8 or S9
    assign out1 = state[8] | state[9];
    // out2=1 when in S7 or S9
    assign out2 = state[7] | state[9];

endmodule