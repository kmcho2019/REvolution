module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

// Parameters for chunking
localparam FULL_CHUNKS = 31;
localparam TOTAL_CHUNKS = 32;

// First level: count 1s in 8-bit chunks (31 full + 1 partial)
wire [7:0] level1 [0:TOTAL_CHUNKS-1];
genvar i;
generate
    // Full 8-bit chunks
    for (i = 0; i < FULL_CHUNKS; i = i + 1) begin : level1_full
        assign level1[i] = in[i*8 +: 8];
    end
    // Partial chunk (7 bits)
    assign level1[FULL_CHUNKS] = in[248] + in[249] + in[250] + in[251] +
                                 in[252] + in[253] + in[254];
endgenerate

// Second level: sum adjacent counts (16 sums)
wire [7:0] level2 [0:15];
generate
    for (i = 0; i < 16; i = i + 1) begin : level2_sum
        assign level2[i] = level1[i*2] + level1[i*2+1];
    end
endgenerate

// Third and fourth levels combined
wire [7:0] level3 [0:3];
generate
    for (i = 0; i < 4; i = i + 1) begin : level3_sum
        assign level3[i] = level2[i*4] + level2[i*4+1] + 
                          level2[i*4+2] + level2[i*4+3];
    end
endgenerate

// Final sum
assign out = level3[0] + level3[1] + level3[2] + level3[3];

endmodule