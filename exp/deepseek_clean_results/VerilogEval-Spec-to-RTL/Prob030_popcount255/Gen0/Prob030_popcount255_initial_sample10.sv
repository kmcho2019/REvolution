module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: Sum pairs of bits (127 sums of 2 bits + 1 leftover)
    wire [6:0] stage1 [0:254];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : stage1_loop
            assign stage1[i] = in[2*i] + in[2*i+1];
        end
        // Handle the last odd bit
        assign stage1[127] = in[254];
    endgenerate

    // Stage 2: Sum pairs of stage1 results (64 sums)
    wire [7:0] stage2 [0:63];
    generate
        for (i = 0; i < 63; i = i + 1) begin : stage2_loop
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
        // Handle the last odd sum
        assign stage2[63] = stage1[126] + stage1[127];
    endgenerate

    // Stage 3: Sum pairs of stage2 results (32 sums)
    wire [7:0] stage3 [0:31];
    generate
        for (i = 0; i < 31; i = i + 1) begin : stage3_loop
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
        assign stage3[31] = stage2[62] + stage2[63];
    endgenerate

    // Stage 4: Sum pairs of stage3 results (16 sums)
    wire [7:0] stage4 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage4_loop
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
        assign stage4[15] = stage3[30] + stage3[31];
    endgenerate

    // Stage 5: Sum pairs of stage4 results (8 sums)
    wire [7:0] stage5 [0:7];
    generate
        for (i = 0; i < 7; i = i + 1) begin : stage5_loop
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
        assign stage5[7] = stage4[14] + stage4[15];
    endgenerate

    // Stage 6: Sum pairs of stage5 results (4 sums)
    wire [7:0] stage6 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6_loop
            assign stage6[i] = stage5[2*i] + stage5[2*i+1];
        end
        assign stage6[3] = stage5[6] + stage5[7];
    endgenerate

    // Stage 7: Sum pairs of stage6 results (2 sums)
    wire [7:0] stage7 [0:1];
    generate
        for (i = 0; i < 1; i = i + 1) begin : stage7_loop
            assign stage7[i] = stage6[2*i] + stage6[2*i+1];
        end
        assign stage7[1] = stage6[2] + stage6[3];
    endgenerate

    // Final sum
    assign out = stage7[0] + stage7[1];

endmodule