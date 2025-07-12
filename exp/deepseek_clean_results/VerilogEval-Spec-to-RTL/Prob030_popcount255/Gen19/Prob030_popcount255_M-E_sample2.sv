module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Individual bit counts (1-bit sums)
    wire [7:0] stage0 [0:254];
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 1) begin : bit_counts
            assign stage0[i] = {{7{1'b0}}, in[i]};
        end
    endgenerate

    // Parallel prefix network (Ladner-Fischer)
    // Stage 1: Sum pairs (128 sums)
    wire [7:0] stage1 [0:127];
    generate
        for (i = 0; i < 127; i = i + 1) begin : stage1_adders
            assign stage1[i] = stage0[i*2] + stage0[i*2+1];
        end
        assign stage1[127] = stage0[254]; // Last odd bit
    endgenerate

    // Stage 2: Sum pairs of stage1 (64 sums)
    wire [7:0] stage2 [0:63];
    generate
        for (i = 0; i < 63; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
        assign stage2[63] = stage1[126] + stage1[127];
    endgenerate

    // Stage 3: Sum pairs of stage2 (32 sums)
    wire [7:0] stage3 [0:31];
    generate
        for (i = 0; i < 31; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
        assign stage3[31] = stage2[62] + stage2[63];
    endgenerate

    // Stage 4: Sum pairs of stage3 (16 sums)
    wire [7:0] stage4 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
        assign stage4[15] = stage3[30] + stage3[31];
    endgenerate

    // Stage 5: Sum pairs of stage4 (8 sums)
    wire [7:0] stage5 [0:7];
    generate
        for (i = 0; i < 7; i = i + 1) begin : stage5_adders
            assign stage5[i] = stage4[i*2] + stage4[i*2+1];
        end
        assign stage5[7] = stage4[14] + stage4[15];
    endgenerate

    // Stage 6: Sum pairs of stage5 (4 sums)
    wire [7:0] stage6 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6_adders
            assign stage6[i] = stage5[i*2] + stage5[i*2+1];
        end
        assign stage6[3] = stage5[6] + stage5[7];
    endgenerate

    // Stage 7: Sum pairs of stage6 (2 sums)
    wire [7:0] stage7 [0:1];
    assign stage7[0] = stage6[0] + stage6[1];
    assign stage7[1] = stage6[2] + stage6[3];

    // Final sum
    assign out = stage7[0] + stage7[1];

endmodule