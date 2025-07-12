module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 0: Initial 1-bit sums
    wire [254:0] sum0 = in;

    // Stage 1: Sum adjacent pairs (127 sums)
    wire [253:0] sum1;
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : STAGE1
            assign sum1[2*i +: 2] = sum0[2*i] + sum0[2*i+1];
        end
        // Handle odd bit
        if (255 % 2) assign sum1[254] = sum0[254];
    endgenerate

    // Stage 2: Sum groups of 4 (64 sums)
    wire [251:0] sum2;
    generate
        for (i = 0; i < 63; i = i + 1) begin : STAGE2
            assign sum2[4*i +: 3] = sum1[4*i +: 2] + sum1[4*i+2 +: 2];
        end
        // Handle remaining bits
        if (255 % 4 > 0) begin
            if (255 % 4 == 1) assign sum2[252] = sum1[252];
            else if (255 % 4 == 2) assign sum2[252 +: 2] = sum1[252 +: 2];
            else assign sum2[252 +: 3] = sum1[252 +: 2] + sum1[254];
        end
    endgenerate

    // Stage 3: Sum groups of 8 (32 sums)
    wire [247:0] sum3;
    generate
        for (i = 0; i < 31; i = i + 1) begin : STAGE3
            assign sum3[8*i +: 4] = sum2[8*i +: 4] + sum2[8*i+4 +: 4];
        end
        // Handle remaining bits
        if (255 % 8 > 0) begin
            if (255 % 8 <= 4) assign sum3[248 +: (255%8)] = sum2[248 +: (255%8)];
            else assign sum3[248 +: 4] = sum2[248 +: 4] + sum2[252 +: (255%8-4)];
        end
    endgenerate

    // Stage 4: Sum groups of 16 (16 sums)
    wire [239:0] sum4;
    generate
        for (i = 0; i < 15; i = i + 1) begin : STAGE4
            assign sum4[16*i +: 5] = sum3[16*i +: 8] + sum3[16*i+8 +: 8];
        end
        // Handle remaining bits
        if (255 % 16 > 0) begin
            if (255 % 16 <= 8) assign sum4[240 +: (255%16)] = sum3[240 +: (255%16)];
            else assign sum4[240 +: 8] = sum3[240 +: 8] + sum3[248 +: (255%16-8)];
        end
    endgenerate

    // Stage 5: Sum groups of 32 (8 sums)
    wire [223:0] sum5;
    generate
        for (i = 0; i < 7; i = i + 1) begin : STAGE5
            assign sum5[32*i +: 6] = sum4[32*i +: 16] + sum4[32*i+16 +: 16];
        end
        // Handle remaining bits
        if (255 % 32 > 0) begin
            if (255 % 32 <= 16) assign sum5[224 +: (255%32)] = sum4[224 +: (255%32)];
            else assign sum5[224 +: 16] = sum4[224 +: 16] + sum4[240 +: (255%32-16)];
        end
    endgenerate

    // Stage 6: Sum groups of 64 (4 sums)
    wire [191:0] sum6;
    generate
        for (i = 0; i < 3; i = i + 1) begin : STAGE6
            assign sum6[64*i +: 7] = sum5[64*i +: 32] + sum5[64*i+32 +: 32];
        end
        // Handle remaining bits
        if (255 % 64 > 0) begin
            if (255 % 64 <= 32) assign sum6[192 +: (255%64)] = sum5[192 +: (255%64)];
            else assign sum6[192 +: 32] = sum5[192 +: 32] + sum5[224 +: (255%64-32)];
        end
    endgenerate

    // Stage 7: Sum groups of 128 (2 sums)
    wire [127:0] sum7;
    assign sum7[7:0] = sum6[0 +: 64] + sum6[64 +: 64];
    assign sum7[127:8] = sum6[128 +: 64] + sum6[192 +: (255-128-64)];

    // Final sum
    assign out = sum7[0 +: 8] + sum7[64 +: 8];

endmodule