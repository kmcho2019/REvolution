module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First stage: count 1s in 4-bit chunks (63 chunks) + 1 3-bit chunk
wire [2:0] stage1 [0:63]; // Only need 3 bits (max count per 4 bits is 4)
genvar i;
generate
    for (i = 0; i < 63; i = i + 1) begin : STAGE1
        assign stage1[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
    end
    // Last chunk (3 bits)
    assign stage1[63] = in[252] + in[253] + in[254];
endgenerate

// Second stage: binary tree of adders (32 pairs)
wire [3:0] stage2 [0:31];
generate
    for (i = 0; i < 31; i = i + 1) begin : STAGE2
        assign stage2[i] = stage1[i*2] + stage1[i*2+1];
    end
    // Last pair (stage1[62] + stage1[63])
    assign stage2[31] = stage1[62] + stage1[63];
endgenerate

// Third stage: next level of binary tree (16 pairs)
wire [4:0] stage3 [0:15];
generate
    for (i = 0; i < 15; i = i + 1) begin : STAGE3
        assign stage3[i] = stage2[i*2] + stage2[i*2+1];
    end
    // Last pair (stage2[30] + stage2[31])
    assign stage3[15] = stage2[30] + stage2[31];
endgenerate

// Fourth stage: next level of binary tree (8 pairs)
wire [5:0] stage4 [0:7];
generate
    for (i = 0; i < 7; i = i + 1) begin : STAGE4
        assign stage4[i] = stage3[i*2] + stage3[i*2+1];
    end
    // Last pair (stage3[14] + stage3[15])
    assign stage4[7] = stage3[14] + stage3[15];
endgenerate

// Fifth stage: final summation with carry optimization
wire [6:0] sum_low  = stage4[0] + stage4[1] + stage4[2] + stage4[3];
wire [6:0] sum_high = stage4[4] + stage4[5] + stage4[6] + stage4[7];
assign out = sum_low + sum_high;

endmodule