module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Input bits (already our population mask)
    wire [254:0] stage0 = in;

    // Stage 1: Sum adjacent pairs (1-bit spacing)
    wire [254:0] stage1;
    assign stage1[0] = stage0[0];
    genvar i;
    generate
        for (i = 1; i < 255; i = i + 1) begin : stage1_adders
            assign stage1[i] = stage0[i] + stage0[i-1];
        end
    endgenerate

    // Stage 2: Sum with 2-bit spacing (2-bit results)
    wire [254:0] stage2;
    assign stage2[1:0] = stage1[1:0];
    generate
        for (i = 2; i < 255; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[i] + (i >= 2 ? stage1[i-2] : 1'b0);
        end
    endgenerate

    // Stage 3: Sum with 4-bit spacing (3-bit results)
    wire [254:0] stage3;
    assign stage3[3:0] = stage2[3:0];
    generate
        for (i = 4; i < 255; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[i] + (i >= 4 ? stage2[i-4] : 2'b0);
        end
    endgenerate

    // Stage 4: Sum with 8-bit spacing (4-bit results)
    wire [254:0] stage4;
    assign stage4[7:0] = stage3[7:0];
    generate
        for (i = 8; i < 255; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[i] + (i >= 8 ? stage3[i-8] : 3'b0);
        end
    endgenerate

    // Stage 5: Sum with 16-bit spacing (5-bit results)
    wire [254:0] stage5;
    assign stage5[15:0] = stage4[15:0];
    generate
        for (i = 16; i < 255; i = i + 1) begin : stage5_adders
            assign stage5[i] = stage4[i] + (i >= 16 ? stage4[i-16] : 4'b0);
        end
    endgenerate

    // Stage 6: Sum with 32-bit spacing (6-bit results)
    wire [254:0] stage6;
    assign stage6[31:0] = stage5[31:0];
    generate
        for (i = 32; i < 255; i = i + 1) begin : stage6_adders
            assign stage6[i] = stage5[i] + (i >= 32 ? stage5[i-32] : 5'b0);
        end
    endgenerate

    // Stage 7: Sum with 64-bit spacing (7-bit results)
    wire [254:0] stage7;
    assign stage7[63:0] = stage6[63:0];
    generate
        for (i = 64; i < 255; i = i + 1) begin : stage7_adders
            assign stage7[i] = stage6[i] + (i >= 64 ? stage6[i-64] : 6'b0);
        end
    endgenerate

    // Stage 8: Sum with 128-bit spacing (8-bit results)
    wire [254:0] stage8;
    assign stage8[127:0] = stage7[127:0];
    generate
        for (i = 128; i < 255; i = i + 1) begin : stage8_adders
            assign stage8[i] = stage7[i] + (i >= 128 ? stage7[i-128] : 7'b0);
        end
    endgenerate

    // Final result is the sum of all bits (stage8[254])
    assign out = stage8[254];

endmodule