module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 3 (85 groups)
    wire [6:0] sum3_00 = in[2:0];
    wire [6:0] sum3_01 = in[5:3];
    wire [6:0] sum3_02 = in[8:6];
    // ... (similar for sum3_03 to sum3_83)
    wire [6:0] sum3_83 = in[251:249];
    wire [6:0] sum3_84 = in[254:252];  // Partial group (only 3 bits)

    // Second level: Sum level1 results in groups of 5 (17 groups)
    wire [8:0] sum5_00 = sum3_00 + sum3_01 + sum3_02 + sum3_03 + sum3_04;
    wire [8:0] sum5_01 = sum3_05 + sum3_06 + sum3_07 + sum3_08 + sum3_09;
    // ... (similar for sum5_02 to sum5_15)
    wire [8:0] sum5_15 = sum3_75 + sum3_76 + sum3_77 + sum3_78 + sum3_79;
    wire [8:0] sum5_16 = sum3_80 + sum3_81 + sum3_82 + sum3_83 + sum3_84;

    // Balanced binary tree for final summation
    wire [8:0] stage1_0 = sum5_00 + sum5_01 + sum5_02 + sum5_03;
    wire [8:0] stage1_1 = sum5_04 + sum5_05 + sum5_06 + sum5_07;
    wire [8:0] stage1_2 = sum5_08 + sum5_09 + sum5_10 + sum5_11;
    wire [8:0] stage1_3 = sum5_12 + sum5_13 + sum5_14 + sum5_15;
    wire [8:0] stage1_4 = sum5_16;

    wire [9:0] stage2_0 = stage1_0 + stage1_1;
    wire [9:0] stage2_1 = stage1_2 + stage1_3;
    wire [9:0] stage2_2 = stage1_4;

    wire [10:0] stage3_0 = stage2_0 + stage2_1;
    wire [10:0] stage3_1 = stage2_2;

    assign out = stage3_0 + stage3_1;

endmodule