module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Initial bit values
    wire [254:0] stage0 = in;

    // Stage 1: Sum adjacent pairs (1-bit distance)
    wire [254:0] stage1;
    assign stage1[0] = stage0[0];
    genvar i;
    generate
        for (i = 1; i < 255; i = i + 1) begin : STAGE1
            assign stage1[i] = stage0[i] + stage0[i-1];
        end
    endgenerate

    // Stage 2: Sum pairs at 2-bit distance
    wire [254:0] stage2;
    assign stage2[1:0] = stage1[1:0];
    generate
        for (i = 2; i < 255; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i] + (i >= 2 ? stage1[i-2] : 1'b0);
        end
    endgenerate

    // Stage 3: Sum pairs at 4-bit distance
    wire [254:0] stage3;
    assign stage3[3:0] = stage2[3:0];
    generate
        for (i = 4; i < 255; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[i] + (i >= 4 ? stage2[i-4] : 1'b0);
        end
    endgenerate

    // Stage 4: Sum pairs at 8-bit distance
    wire [254:0] stage4;
    assign stage4[7:0] = stage3[7:0];
    generate
        for (i = 8; i < 255; i = i + 1) begin : STAGE4
            assign stage4[i] = stage3[i] + (i >= 8 ? stage3[i-8] : 1'b0);
        end
    endgenerate

    // Stage 5: Sum pairs at 16-bit distance
    wire [254:0] stage5;
    assign stage5[15:0] = stage4[15:0];
    generate
        for (i = 16; i < 255; i = i + 1) begin : STAGE5
            assign stage5[i] = stage4[i] + (i >= 16 ? stage4[i-16] : 1'b0);
        end
    endgenerate

    // Stage 6: Sum pairs at 32-bit distance
    wire [254:0] stage6;
    assign stage6[31:0] = stage5[31:0];
    generate
        for (i = 32; i < 255; i = i + 1) begin : STAGE6
            assign stage6[i] = stage5[i] + (i >= 32 ? stage5[i-32] : 1'b0);
        end
    endgenerate

    // Stage 7: Sum pairs at 64-bit distance
    wire [254:0] stage7;
    assign stage7[63:0] = stage6[63:0];
    generate
        for (i = 64; i < 255; i = i + 1) begin : STAGE7
            assign stage7[i] = stage6[i] + (i >= 64 ? stage6[i-64] : 1'b0);
        end
    endgenerate

    // Stage 8: Sum pairs at 128-bit distance
    wire [254:0] stage8;
    assign stage8[127:0] = stage7[127:0];
    generate
        for (i = 128; i < 255; i = i + 1) begin : STAGE8
            assign stage8[i] = stage7[i] + (i >= 128 ? stage7[i-128] : 1'b0);
        end
    endgenerate

    // Final result is the sum of all bits in the last stage
    assign out = stage8[254];

endmodule