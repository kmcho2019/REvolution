module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [169:0] level1; // 85 x 2-bit counters
    assign level1[1:0]   = in[0] + in[1] + in[2];
    assign level1[3:2]   = in[3] + in[4] + in[5];
    assign level1[5:4]   = in[6] + in[7] + in[8];
    // ... (81 more assignments for all 85 chunks)
    assign level1[169:168] = in[252] + in[253] + in[254];

    // Level 2: Sum 3 level1 counters (28 full groups + 1 partial)
    wire [115:0] level2; // 29 x 4-bit sums
    assign level2[3:0]   = level1[1:0] + level1[3:2] + level1[5:4];
    assign level2[7:4]   = level1[7:6] + level1[9:8] + level1[11:10];
    // ... (26 more assignments for full groups)
    assign level2[115:112] = level1[169:168]; // Last partial group

    // Level 3: Sum 3 level2 counters (9 full groups + 1 partial)
    wire [63:0] level3; // 10 x 6-bit sums
    assign level3[5:0]   = level2[3:0] + level2[7:4] + level2[11:8];
    assign level3[11:6]  = level2[15:12] + level2[19:16] + level2[23:20];
    // ... (7 more assignments for full groups)
    assign level3[63:60] = level2[115:112]; // Last partial group

    // Level 4: Sum level3 counters (3 full groups + 1 partial)
    wire [31:0] level4; // 4 x 8-bit sums
    assign level4[7:0]   = level3[5:0] + level3[11:6] + level3[17:12];
    assign level4[15:8]  = level3[23:18] + level3[29:24] + level3[35:30];
    assign level4[23:16] = level3[41:36] + level3[47:42] + level3[53:48];
    assign level4[31:24] = level3[63:60]; // Last partial group

    // Final addition - balanced 2-stage
    wire [7:0] sum1 = level4[7:0] + level4[15:8];
    wire [7:0] sum2 = level4[23:16] + level4[31:24];
    assign out = sum1 + sum2;

endmodule