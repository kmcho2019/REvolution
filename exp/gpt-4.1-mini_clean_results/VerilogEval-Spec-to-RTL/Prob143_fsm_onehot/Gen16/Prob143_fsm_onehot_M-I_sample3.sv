module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Masks for next_state transitions on input == 0
    // States that go to S0 on input=0:
    // S0,S1,S2,S3,S4,S7,S8,S9
    localparam [9:0] mask_S0_in0 = 
        (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3) |
        (1 << 4) | (1 << 7) | (1 << 8) | (1 << 9);

    // Masks for next_state transitions on input == 1
    // For each next state, we define which current states cause transition on input=1:
    localparam [9:0] mask_S1_in1 = (1 << 0) | (1 << 8) | (1 << 9);
    localparam [9:0] mask_S2_in1 = (1 << 1);
    localparam [9:0] mask_S3_in1 = (1 << 2);
    localparam [9:0] mask_S4_in1 = (1 << 3);
    localparam [9:0] mask_S5_in1 = (1 << 4);
    localparam [9:0] mask_S6_in1 = (1 << 5);
    localparam [9:0] mask_S7_in1 = (1 << 6) | (1 << 7);

    // Masks for next_state transitions on input == 0 (for states other than S0)
    localparam [9:0] mask_S8_in0 = (1 << 5);
    localparam [9:0] mask_S9_in0 = (1 << 6);

    // Compute next_state bits using vector operations for each condition
    wire [9:0] next_S0 = (state & mask_S0_in0) & {10{in == 1'b0}};
    wire [9:0] next_S1 = (state & mask_S1_in1) & {10{in == 1'b1}};
    wire [9:0] next_S2 = (state & mask_S2_in1) & {10{in == 1'b1}};
    wire [9:0] next_S3 = (state & mask_S3_in1) & {10{in == 1'b1}};
    wire [9:0] next_S4 = (state & mask_S4_in1) & {10{in == 1'b1}};
    wire [9:0] next_S5 = (state & mask_S5_in1) & {10{in == 1'b1}};
    wire [9:0] next_S6 = (state & mask_S6_in1) & {10{in == 1'b1}};
    wire [9:0] next_S7 = (state & mask_S7_in1) & {10{in == 1'b1}};
    wire [9:0] next_S8 = (state & mask_S8_in0) & {10{in == 1'b0}};
    wire [9:0] next_S9 = (state & mask_S9_in0) & {10{in == 1'b0}};

    // For each next state bit, OR the bits where transitions lead to it.
    // Since next_state is one-hot, only one bit per state, we extract one bit per transition mask.

    assign next_state[0] = |next_S0;
    assign next_state[1] = |next_S1;
    assign next_state[2] = |next_S2;
    assign next_state[3] = |next_S3;
    assign next_state[4] = |next_S4;
    assign next_state[5] = |next_S5;
    assign next_state[6] = |next_S6;
    assign next_state[7] = |next_S7;
    assign next_state[8] = |next_S8;
    assign next_state[9] = |next_S9;

    // Outputs:
    // out1 = state in S8 or S9
    // out2 = state in S7 or S9

    assign out1 = |(state & ((1 << 8) | (1 << 9)));
    assign out2 = |(state & ((1 << 7) | (1 << 9)));

endmodule