module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: group bits into 3-bit chunks where possible (except last groups)
    wire [3:0] sum_level1 [84:0]; // 85 groups (255/3 = 85 exactly)
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1
            assign sum_level1[i] = in[3*i] + in[3*i+1] + in[3*i+2];
        end
    endgenerate

    // Level 2: sum groups of 3 sums from previous level
    // 85 sums at level 1 -> 28 groups of 3 sums + 1 leftover (85 = 28*3 + 1)
    wire [5:0] sum_level2 [27:0];
    generate
        for (i = 0; i < 27; i = i + 1) begin : level2_3groups
            assign sum_level2[i] = sum_level1[3*i] + sum_level1[3*i+1] + sum_level1[3*i+2];
        end
        // handle leftover at index 27: sum_level1[81..84] (4 elements)
        assign sum_level2[27] = sum_level1[81] + sum_level1[82] + sum_level1[83] + sum_level1[84];
    endgenerate

    // Level 3: sum groups of 3 sums from previous level
    // 28 sums at level 2 -> 9 groups of 3 + 1 leftover (28=9*3+1)
    wire [7:0] sum_level3 [8:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_3groups
            assign sum_level3[i] = sum_level2[3*i] + sum_level2[3*i+1] + sum_level2[3*i+2];
        end
        assign sum_level3[8] = sum_level2[27]; // leftover
    endgenerate

    // Level 4: sum groups of 3 sums from previous level
    // 9 sums -> 3 groups of 3
    wire [9:0] sum_level4 [2:0];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_3groups
            assign sum_level4[i] = sum_level3[3*i] + sum_level3[3*i+1] + sum_level3[3*i+2];
        end
    endgenerate

    // Level 5: sum all 3 from previous level
    wire [11:0] sum_level5;
    assign sum_level5 = sum_level4[0] + sum_level4[1] + sum_level4[2];

    // sum_level5 is the total population count (max 255 -> fits in 8 bits)
    assign out = sum_level5[7:0];

endmodule