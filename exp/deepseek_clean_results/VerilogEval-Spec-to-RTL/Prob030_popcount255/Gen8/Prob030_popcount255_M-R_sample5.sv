module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Parameters for bit widths
    parameter L1_WIDTH = 2;  // Level 1 counters (count 0-3)
    parameter L2_WIDTH = 4;  // Level 2 sums (0-9)
    parameter L3_WIDTH = 6;  // Level 3 sums (0-27)
    parameter L4_WIDTH = 8;  // Level 4 sums (0-255)

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [L1_WIDTH-1:0] l1_00 = in[0] + in[1] + in[2];
    wire [L1_WIDTH-1:0] l1_01 = in[3] + in[4] + in[5];
    wire [L1_WIDTH-1:0] l1_02 = in[6] + in[7] + in[8];
    // ... (all 85 chunks)
    wire [L1_WIDTH-1:0] l1_84 = in[252] + in[253] + in[254];

    // Level 2: Sum 3 level1 counters (28 groups of 3, 1 group of 1)
    wire [L2_WIDTH-1:0] l2_00 = l1_00 + l1_01 + l1_02;
    wire [L2_WIDTH-1:0] l2_01 = l1_03 + l1_04 + l1_05;
    // ... (28 groups)
    wire [L2_WIDTH-1:0] l2_28 = {2'b0, l1_84};  // Last counter

    // Level 3: Sum 3 level2 counters (9 groups of 3, 1 group of 2)
    wire [L3_WIDTH-1:0] l3_00 = l2_00 + l2_01 + l2_02;
    wire [L3_WIDTH-1:0] l3_01 = l2_03 + l2_04 + l2_05;
    // ... (9 groups)
    wire [L3_WIDTH-1:0] l3_09 = l2_27 + l2_28;

    // Level 4: Sum 3 level3 counters (3 groups of 3, 1 group of 1)
    wire [L4_WIDTH-1:0] l4_00 = l3_00 + l3_01 + l3_02;
    wire [L4_WIDTH-1:0] l4_01 = l3_03 + l3_04 + l3_05;
    wire [L4_WIDTH-1:0] l4_02 = l3_06 + l3_07 + l3_08;
    wire [L4_WIDTH-1:0] l4_03 = l3_09;

    // Final sum: Combine all level4 results
    assign out = l4_00 + l4_01 + l4_02 + l4_03;

endmodule