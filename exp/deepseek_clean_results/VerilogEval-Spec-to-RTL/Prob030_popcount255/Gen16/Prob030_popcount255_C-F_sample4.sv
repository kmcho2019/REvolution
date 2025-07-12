module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in 3-bit groups (85 groups)
    wire [1:0] level1_00 = in[0] + in[1] + in[2];
    wire [1:0] level1_01 = in[3] + in[4] + in[5];
    wire [1:0] level1_02 = in[6] + in[7] + in[8];
    wire [1:0] level1_03 = in[9] + in[10] + in[11];
    // ... (all 85 groups declared similarly)
    wire [1:0] level1_84 = in[252] + in[253] + in[254];

    // Second level: Combine 4 counts (21 groups)
    wire [3:0] level2_00 = level1_00 + level1_01 + level1_02 + level1_03;
    wire [3:0] level2_01 = level1_04 + level1_05 + level1_06 + level1_07;
    // ... (all 21 groups declared similarly)
    wire [3:0] level2_20 = level1_80 + level1_81 + level1_82 + level1_83;
    wire [1:0] level2_21 = level1_84;

    // Third level: Combine 4 counts (5 groups)
    wire [5:0] level3_00 = level2_00 + level2_01 + level2_02 + level2_03;
    wire [5:0] level3_01 = level2_04 + level2_05 + level2_06 + level2_07;
    // ... (all 5 groups declared similarly)
    wire [5:0] level3_04 = level2_16 + level2_17 + level2_18 + level2_19;
    wire [3:0] level3_05 = level2_20 + level2_21;

    // Final accumulation
    wire [6:0] sum_low = level3_00 + level3_01;
    wire [6:0] sum_mid = level3_02 + level3_03;
    wire [6:0] sum_high = level3_04 + level3_05;
    wire [7:0] total_count = sum_low + sum_mid + sum_high;

    assign out = total_count;

endmodule