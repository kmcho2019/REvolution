module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Count 1s in each 2-bit segment
    wire [7:0] stage1 [0:127];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : STAGE1
            assign stage1[i] = in[i*2+1] + in[i*2];
        end
        // Handle last bit
        assign stage1[127] = in[254];
    endgenerate

    // Stage 2: Combine adjacent 2-bit counts into 4-bit counts
    wire [7:0] stage2 [0:63];
    generate
        for (i = 0; i < 63; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
        // Handle last group
        assign stage2[63] = stage1[126] + stage1[127];
    endgenerate

    // Stage 3: Combine adjacent 4-bit counts into 8-bit counts
    wire [7:0] stage3 [0:31];
    generate
        for (i = 0; i < 31; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
        // Handle last group
        assign stage3[31] = stage2[62] + stage2[63];
    endgenerate

    // Stage 4: Combine adjacent 8-bit counts into 16-bit counts
    wire [7:0] stage4 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : STAGE4
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
        // Handle last group
        assign stage4[15] = stage3[30] + stage3[31];
    endgenerate

    // Stage 5: Combine adjacent 16-bit counts into 32-bit counts
    wire [7:0] stage5 [0:7];
    generate
        for (i = 0; i < 7; i = i + 1) begin : STAGE5
            assign stage5[i] = stage4[i*2] + stage4[i*2+1];
        end
        // Handle last group
        assign stage5[7] = stage4[14] + stage4[15];
    endgenerate

    // Stage 6: Combine adjacent 32-bit counts into 64-bit counts
    wire [7:0] stage6 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : STAGE6
            assign stage6[i] = stage5[i*2] + stage5[i*2+1];
        end
        // Handle last group
        assign stage6[3] = stage5[6] + stage5[7];
    endgenerate

    // Stage 7: Combine adjacent 64-bit counts into 128-bit counts
    wire [7:0] stage7 [0:1];
    generate
        for (i = 0; i < 1; i = i + 1) begin : STAGE7
            assign stage7[i] = stage6[i*2] + stage6[i*2+1];
        end
        // Handle remaining
        assign stage7[1] = stage6[2] + stage6[3];
    endgenerate

    // Final stage: Combine into 256-bit count (but we only have 255 bits)
    assign out = stage7[0] + stage7[1];

endmodule