module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Level 1: Count pairs (127 x 2-bit counts + 1 x 1-bit count)
wire [1:0] level1 [127:0];
genvar i;
generate
    for (i = 0; i < 127; i = i + 1) begin : LEVEL1
        assign level1[i] = in[i*2+1] + in[i*2];
    end
    // Last single bit
    assign level1[127] = in[254];
endgenerate

// Level 2: Sum adjacent counts (64 x 3-bit counts)
wire [2:0] level2 [63:0];
generate
    for (i = 0; i < 63; i = i + 1) begin : LEVEL2
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
    // Last sum (2 + 1 bits)
    assign level2[63] = level1[126] + level1[127];
endgenerate

// Level 3: Sum adjacent counts (32 x 4-bit counts)
wire [3:0] level3 [31:0];
generate
    for (i = 0; i < 31; i = i + 1) begin : LEVEL3
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
    // Last sum (3 + 3 bits)
    assign level3[31] = level2[62] + level2[63];
endgenerate

// Level 4: Sum adjacent counts (16 x 5-bit counts)
wire [4:0] level4 [15:0];
generate
    for (i = 0; i < 15; i = i + 1) begin : LEVEL4
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
    // Last sum (4 + 4 bits)
    assign level4[15] = level3[30] + level3[31];
endgenerate

// Level 5: Sum adjacent counts (8 x 6-bit counts)
wire [5:0] level5 [7:0];
generate
    for (i = 0; i < 7; i = i + 1) begin : LEVEL5
        assign level5[i] = level4[i*2] + level4[i*2+1];
    end
    // Last sum (5 + 5 bits)
    assign level5[7] = level4[14] + level4[15];
endgenerate

// Level 6: Sum adjacent counts (4 x 7-bit counts)
wire [6:0] level6 [3:0];
generate
    for (i = 0; i < 3; i = i + 1) begin : LEVEL6
        assign level6[i] = level5[i*2] + level5[i*2+1];
    end
    // Last sum (6 + 6 bits)
    assign level6[3] = level5[6] + level5[7];
endgenerate

// Level 7: Sum adjacent counts (2 x 8-bit counts)
wire [7:0] level7 [1:0];
generate
    for (i = 0; i < 1; i = i + 1) begin : LEVEL7
        assign level7[i] = level6[i*2] + level6[i*2+1];
    end
    // Last sum (7 + 7 bits)
    assign level7[1] = level6[2] + level6[3];
endgenerate

// Final sum (8 + 8 bits, but we know max is 255 so we can ignore overflow)
assign out = level7[0] + level7[1];

endmodule