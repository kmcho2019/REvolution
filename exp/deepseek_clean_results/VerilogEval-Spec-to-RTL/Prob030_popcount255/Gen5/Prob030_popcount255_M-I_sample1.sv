module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in 4-bit chunks (64 chunks, last chunk has 3 bits)
    wire [2:0] chunk_counts [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : count_chunks
            assign chunk_counts[i] = in[i*4 + 0] + in[i*4 + 1] + 
                                   in[i*4 + 2] + in[i*4 + 3];
        end
        // Last chunk (bits 252-254)
        assign chunk_counts[63] = in[252] + in[253] + in[254];
    endgenerate

    // Second level: Sum groups of 4 chunks (16 groups)
    wire [4:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign level1[i] = chunk_counts[i*4]   + chunk_counts[i*4 + 1] + 
                             chunk_counts[i*4 + 2] + chunk_counts[i*4 + 3];
        end
    endgenerate

    // Third level: Balanced binary tree of adders
    // First stage: Sum pairs of level1 results (8 sums)
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate

    // Second stage: Sum pairs of level2 results (4 sums)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate

    // Third stage: Sum pairs of level3 results (2 sums)
    wire [7:0] level4 [0:1];
    assign level4[0] = level3[0] + level3[1];
    assign level4[1] = level3[2] + level3[3];

    // Final sum
    assign out = level4[0] + level4[1];

endmodule