module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in 4-bit chunks (64 chunks, last chunk has 3 bits)
    wire [2:0] chunk_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : COUNT_4BIT
            assign chunk_counts[i] = in[i*4 + 0] + in[i*4 + 1] + 
                                   in[i*4 + 2] + in[i*4 + 3];
        end
        // Handle last 3-bit chunk
        assign chunk_counts[63] = in[252] + in[253] + in[254];
    endgenerate

    // Second level: Sum pairs of chunks (32 sums)
    wire [3:0] level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : SUM_PAIRS
            assign level1[i] = chunk_counts[i*2] + chunk_counts[i*2 + 1];
        end
    endgenerate

    // Third level: Sum pairs of level1 results (16 sums)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL1
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate

    // Fourth level: Sum pairs of level2 results (8 sums)
    wire [5:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL2
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate

    // Fifth level: Sum pairs of level3 results (4 sums)
    wire [6:0] level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL3
            assign level4[i] = level3[i*2] + level3[i*2 + 1];
        end
    endgenerate

    // Sixth level: Sum pairs of level4 results (2 sums)
    wire [7:0] level5 [0:1];
    assign level5[0] = level4[0] + level4[1];
    assign level5[1] = level4[2] + level4[3];

    // Final sum
    assign out = level5[0] + level5[1];

endmodule