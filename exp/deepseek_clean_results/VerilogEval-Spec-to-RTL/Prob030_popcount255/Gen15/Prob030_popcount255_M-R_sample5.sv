module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 3 (85 groups)
    wire [6:0] level1_00 = in[0] + in[1] + in[2];
    wire [6:0] level1_01 = in[3] + in[4] + in[5];
    wire [6:0] level1_02 = in[6] + in[7] + in[8];
    // ... (similar assignments for level1_03 to level1_83)
    wire [6:0] level1_83 = in[249] + in[250] + in[251];
    wire [6:0] level1_84 = in[252] + in[253] + in[254];

    // Second level: Sum level1 results in groups of 5 (17 groups)
    wire [8:0] level2_00 = level1_00 + level1_01 + level1_02 + level1_03 + level1_04;
    wire [8:0] level2_01 = level1_05 + level1_06 + level1_07 + level1_08 + level1_09;
    // ... (similar assignments for level2_02 to level2_16)
    wire [8:0] level2_16 = level1_80 + level1_81 + level1_82 + level1_83 + level1_84;

    // Final sum using balanced tree addition
    wire [8:0] sum_a = level2_00 + level2_01 + level2_02 + level2_03;
    wire [8:0] sum_b = level2_04 + level2_05 + level2_06 + level2_07;
    wire [8:0] sum_c = level2_08 + level2_09 + level2_10 + level2_11;
    wire [8:0] sum_d = level2_12 + level2_13 + level2_14 + level2_15;
    wire [8:0] sum_e = level2_16;
    
    wire [8:0] sum_ab = sum_a + sum_b;
    wire [8:0] sum_cd = sum_c + sum_d;
    wire [8:0] sum_abcd = sum_ab + sum_cd;
    
    assign out = sum_abcd + sum_e;

endmodule