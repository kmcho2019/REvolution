module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Pad input to 256 bits (32 groups of 8 bits) for uniform processing
wire [255:0] padded_in = {1'b0, in};

// First level: Count '1's in each 8-bit group
wire [7:0] level1 [0:31];
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : GROUP_COUNTS
        assign level1[i] = padded_in[i*8+7] + padded_in[i*8+6] + padded_in[i*8+5] + padded_in[i*8+4] +
                          padded_in[i*8+3] + padded_in[i*8+2] + padded_in[i*8+1] + padded_in[i*8];
    end
endgenerate

// Second level: Sum pairs of level1 results (16 groups)
wire [8:0] level2 [0:15];
generate
    for (i = 0; i < 16; i = i + 1) begin : LEVEL2
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
endgenerate

// Third level: Sum pairs of level2 results (8 groups)
wire [9:0] level3 [0:7];
generate
    for (i = 0; i < 8; i = i + 1) begin : LEVEL3
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
endgenerate

// Fourth level: Sum pairs of level3 results (4 groups)
wire [10:0] level4 [0:3];
generate
    for (i = 0; i < 4; i = i + 1) begin : LEVEL4
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
endgenerate

// Fifth level: Sum pairs of level4 results (2 groups)
wire [11:0] level5 [0:1];
generate
    for (i = 0; i < 2; i = i + 1) begin : LEVEL5
        assign level5[i] = level4[i*2] + level4[i*2+1];
    end
endgenerate

// Final sum
assign out = level5[0] + level5[1];

endmodule