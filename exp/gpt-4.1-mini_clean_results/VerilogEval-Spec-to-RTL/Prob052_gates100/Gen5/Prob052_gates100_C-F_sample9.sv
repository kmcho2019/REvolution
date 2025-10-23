module TopModule(
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

assign out_and = &in;  // Use built-in reduction AND
assign out_or  = |in;  // Use built-in reduction OR

// Hierarchical XOR reduction tree for better timing balance

// Level 0 - inputs: 100 bits
wire [49:0] xor_level1;  // 50 outputs at level 1 (pairs of inputs)
genvar i;

// Level 1: XOR pairs of inputs: 100 -> 50
generate
    for (i = 0; i < 50; i = i + 1) begin : xor_lvl1
        assign xor_level1[i] = in[2*i] ^ in[2*i + 1];
    end
endgenerate

// Level 2: XOR pairs of level 1 outputs: 50 -> 25
wire [24:0] xor_level2;
generate
    for (i = 0; i < 25; i = i + 1) begin : xor_lvl2
        assign xor_level2[i] = xor_level1[2*i] ^ xor_level1[2*i + 1];
    end
endgenerate

// Level 3: XOR pairs of level 2 outputs: 25 -> 12 + 1 leftover
wire [11:0] xor_level3;
wire xor_level3_extra; // leftover input

generate
    for (i = 0; i < 12; i = i + 1) begin : xor_lvl3
        assign xor_level3[i] = xor_level2[2*i] ^ xor_level2[2*i + 1];
    end
endgenerate
assign xor_level3_extra = xor_level2[24];

// Level 4: XOR pairs of level 3 outputs: 12 -> 6
wire [5:0] xor_level4;
generate
    for (i = 0; i < 6; i = i + 1) begin : xor_lvl4
        assign xor_level4[i] = xor_level3[2*i] ^ xor_level3[2*i + 1];
    end
endgenerate

// Level 5: XOR pairs of level 4 outputs: 6 -> 3
wire [2:0] xor_level5;
generate
    for (i = 0; i < 3; i = i + 1) begin : xor_lvl5
        assign xor_level5[i] = xor_level4[2*i] ^ xor_level4[2*i + 1];
    end
endgenerate

// Level 6: XOR pairs of level 5 outputs: 3 -> 1 + 1 leftover
wire xor_level6_0, xor_level6_1;
assign xor_level6_0 = xor_level5[0] ^ xor_level5[1];
assign xor_level6_1 = xor_level5[2];

// Level 7: Final XOR of leftover from level 3 and from level 6
assign out_xor = xor_level6_0 ^ xor_level6_1 ^ xor_level3_extra;

endmodule