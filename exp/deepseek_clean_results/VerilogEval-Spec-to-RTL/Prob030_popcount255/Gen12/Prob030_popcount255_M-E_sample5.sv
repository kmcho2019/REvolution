module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 0: Initial count (each bit is either 0 or 1)
    wire [254:0][7:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 1) begin : INIT
            assign stage0[i] = in[i] ? 8'd1 : 8'd0;
        end
    endgenerate

    // Parallel prefix network stages
    wire [254:0][7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;

    // Stage 1: Sum pairs 1 apart
    assign stage1[0] = stage0[0];
    generate
        for (i = 1; i < 255; i = i + 1) begin : STAGE1
            assign stage1[i] = stage0[i] + stage0[i-1];
        end
    endgenerate

    // Stage 2: Sum pairs 2 apart
    assign stage2[0] = stage1[0];
    assign stage2[1] = stage1[1];
    generate
        for (i = 2; i < 255; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i] + stage1[i-2];
        end
    endgenerate

    // Stage 3: Sum pairs 4 apart
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3_INIT
            assign stage3[i] = stage2[i];
        end
        for (i = 4; i < 255; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[i] + stage2[i-4];
        end
    endgenerate

    // Stage 4: Sum pairs 8 apart
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE4_INIT
            assign stage4[i] = stage3[i];
        end
        for (i = 8; i < 255; i = i + 1) begin : STAGE4
            assign stage4[i] = stage3[i] + stage3[i-8];
        end
    endgenerate

    // Stage 5: Sum pairs 16 apart
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE5_INIT
            assign stage5[i] = stage4[i];
        end
        for (i = 16; i < 255; i = i + 1) begin : STAGE5
            assign stage5[i] = stage4[i] + stage4[i-16];
        end
    endgenerate

    // Stage 6: Sum pairs 32 apart
    generate
        for (i = 0; i < 32; i = i + 1) begin : STAGE6_INIT
            assign stage6[i] = stage5[i];
        end
        for (i = 32; i < 255; i = i + 1) begin : STAGE6
            assign stage6[i] = stage5[i] + stage5[i-32];
        end
    endgenerate

    // Stage 7: Sum pairs 64 apart
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE7_INIT
            assign stage7[i] = stage6[i];
        end
        for (i = 64; i < 255; i = i + 1) begin : STAGE7
            assign stage7[i] = stage6[i] + stage6[i-64];
        end
    endgenerate

    // Stage 8: Sum pairs 128 apart (final stage)
    generate
        for (i = 0; i < 128; i = i + 1) begin : STAGE8_INIT
            assign stage8[i] = stage7[i];
        end
        for (i = 128; i < 255; i = i + 1) begin : STAGE8
            assign stage8[i] = stage7[i] + stage7[i-128];
        end
    endgenerate

    // Final output is the count at the last bit position
    assign out = stage8[254][7:0];

endmodule