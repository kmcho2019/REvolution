module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define next_state contributions for each state for input=0 and input=1
    localparam [9:0] NS0_0 = 10'b0000000001; // S0 next when in=0
    localparam [9:0] NS0_1 = 10'b0000000010; // S1 next when in=1

    localparam [9:0] NS1_0 = 10'b0000000001; // S0
    localparam [9:0] NS1_1 = 10'b0000000100; // S2

    localparam [9:0] NS2_0 = 10'b0000000001; // S0
    localparam [9:0] NS2_1 = 10'b0000001000; // S3

    localparam [9:0] NS3_0 = 10'b0000000001; // S0
    localparam [9:0] NS3_1 = 10'b0000010000; // S4

    localparam [9:0] NS4_0 = 10'b0000000001; // S0
    localparam [9:0] NS4_1 = 10'b0000100000; // S5

    localparam [9:0] NS5_0 = 10'b0001000000; // S8
    localparam [9:0] NS5_1 = 10'b0000000000; // Initialize zero
    // Correction: S5(1) --> S6(1)
    localparam [9:0] NS5_1_REAL = 10'b0000010000; // S6

    localparam [9:0] NS6_0 = 10'b0010000000; // S9
    localparam [9:0] NS6_1 = 10'b0100000000; // S7

    localparam [9:0] NS7_0 = 10'b0000000001; // S0
    localparam [9:0] NS7_1 = 10'b0100000000; // S7

    localparam [9:0] NS8_0 = 10'b0000000001; // S0
    localparam [9:0] NS8_1 = 10'b0000000010; // S1

    localparam [9:0] NS9_0 = 10'b0000000001; // S0
    localparam [9:0] NS9_1 = 10'b0000000010; // S1

    // Compute next_state contributions for each state considering input
    wire [9:0] ns0 = state[0] ? (in ? NS0_1 : NS0_0) : 10'b0;
    wire [9:0] ns1 = state[1] ? (in ? NS1_1 : NS1_0) : 10'b0;
    wire [9:0] ns2 = state[2] ? (in ? NS2_1 : NS2_0) : 10'b0;
    wire [9:0] ns3 = state[3] ? (in ? NS3_1 : NS3_0) : 10'b0;
    wire [9:0] ns4 = state[4] ? (in ? NS4_1 : NS4_0) : 10'b0;
    wire [9:0] ns5 = state[5] ? (in ? NS5_1_REAL : NS5_0) : 10'b0;
    wire [9:0] ns6 = state[6] ? (in ? NS6_1 : NS6_0) : 10'b0;
    wire [9:0] ns7 = state[7] ? (in ? NS7_1 : NS7_0) : 10'b0;
    wire [9:0] ns8 = state[8] ? (in ? NS8_1 : NS8_0) : 10'b0;
    wire [9:0] ns9 = state[9] ? (in ? NS9_1 : NS9_0) : 10'b0;

    // OR all partial next_states for final next_state
    assign next_state = ns0 | ns1 | ns2 | ns3 | ns4 | ns5 | ns6 | ns7 | ns8 | ns9;

    // Output logic: assert out1 for S8 or S9 active; out2 for S7 or S9 active
    // Masks: S7 = bit7, S8 = bit8, S9 = bit9
    localparam [9:0] OUT1_MASK = (1 << 8) | (1 << 9); // bits 8 and 9
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9); // bits 7 and 9

    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

endmodule