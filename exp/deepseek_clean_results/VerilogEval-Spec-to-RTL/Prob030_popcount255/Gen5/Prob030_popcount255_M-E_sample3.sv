module TopModule (
    input [254:0] in,
    output [7:0] out
);

    // Stage 0: Input bits
    wire [254:0] level0 = in;

    // Stage 1: Sum pairs (127 sums)
    wire [126:0] level1;
    generate
        genvar i;
        for (i = 0; i < 127; i = i + 1) begin : stage1
            assign level1[i] = level0[i*2] + level0[i*2+1];
        end
    endgenerate

    // Stage 2: Sum pairs of stage1 results (63 sums)
    wire [62:0] level2;
    generate
        for (i = 0; i < 63; i = i + 1) begin : stage2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Stage 3: Sum pairs of stage2 results (31 sums)
    wire [30:0] level3;
    generate
        for (i = 0; i < 31; i = i + 1) begin : stage3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Stage 4: Sum pairs of stage3 results (15 sums)
    wire [14:0] level4;
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Stage 5: Sum pairs of stage4 results (7 sums)
    wire [6:0] level5;
    generate
        for (i = 0; i < 7; i = i + 1) begin : stage5
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
    endgenerate

    // Stage 6: Sum pairs of stage5 results (3 sums)
    wire [2:0] level6;
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6
            assign level6[i] = level5[i*2] + level5[i*2+1];
        end
    endgenerate

    // Stage 7: Sum pairs of stage6 results (1 sum)
    wire [1:0] level7 = level6[0] + level6[1];

    // Final sum: Add remaining bits
    wire [7:0] total_sum;
    assign total_sum = level7 + level6[2] + 
                      level5[6] + level4[14] + 
                      level3[30] + level2[62] + 
                      level1[126] + level0[254];

    assign out = total_sum;

endmodule