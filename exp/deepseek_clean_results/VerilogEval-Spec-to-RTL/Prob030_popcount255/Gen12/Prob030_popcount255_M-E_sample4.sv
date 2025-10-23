module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Convert each bit to 1-bit count
    wire [254:0] stage0 = in;

    // Stage 1: Sum pairs (127 results of 2 bits)
    wire [126:0][1:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : stage1_adders
            assign stage1[i] = stage0[i*2] + stage0[i*2+1];
        end
    endgenerate

    // Stage 2: Sum quads (64 results of 3 bits)
    wire [63:0][2:0] stage2;
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
    endgenerate

    // Stage 3: Sum octs (32 results of 4 bits)
    wire [31:0][3:0] stage3;
    generate
        for (i = 0; i < 32; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
    endgenerate

    // Stage 4: Sum 16-tuples (16 results of 5 bits)
    wire [15:0][4:0] stage4;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
    endgenerate

    // Stage 5: Sum 32-tuples (8 results of 6 bits)
    wire [7:0][5:0] stage5;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage5_adders
            assign stage5[i] = stage4[i*2] + stage4[i*2+1];
        end
    endgenerate

    // Stage 6: Sum 64-tuples (4 results of 7 bits)
    wire [3:0][6:0] stage6;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage6_adders
            assign stage6[i] = stage5[i*2] + stage5[i*2+1];
        end
    endgenerate

    // Stage 7: Sum 128-tuples (2 results of 8 bits)
    wire [1:0][7:0] stage7;
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage7_adders
            assign stage7[i] = stage6[i*2] + stage6[i*2+1];
        end
    endgenerate

    // Final stage: Sum remaining (254 bits) and add last bit
    assign out = stage7[0] + stage7[1] + stage0[254];

endmodule