module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// First level: count 1s in 8-bit chunks (31 full + 1 partial)
wire [7:0] level1 [0:31];
genvar i;
generate
    for (i = 0; i < 31; i = i + 1) begin : L1
        assign level1[i] = in[i*8 +: 8];
    end
    // Handle remaining 7 bits
    assign level1[31] = {1'b0, in[254:248]};
endgenerate

// Second level: sum pairs (16 sums)
wire [7:0] level2 [0:15];
generate
    for (i = 0; i < 16; i = i + 1) begin : L2
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
endgenerate

// Third level: sum pairs (8 sums)
wire [7:0] level3 [0:7];
generate
    for (i = 0; i < 8; i = i + 1) begin : L3
        assign level3[i] = level2[i*2] + level2[i*2+1];
    end
endgenerate

// Fourth level: sum pairs (4 sums)
wire [7:0] level4 [0:3];
generate
    for (i = 0; i < 4; i = i + 1) begin : L4
        assign level4[i] = level3[i*2] + level3[i*2+1];
    end
endgenerate

// Fifth level: sum pairs (2 sums)
wire [7:0] level5 [0:1];
assign level5[0] = level4[0] + level4[1];
assign level5[1] = level4[2] + level4[3];

// Final sum with carry lookahead optimization
assign out = level5[0] + level5[1];

endmodule