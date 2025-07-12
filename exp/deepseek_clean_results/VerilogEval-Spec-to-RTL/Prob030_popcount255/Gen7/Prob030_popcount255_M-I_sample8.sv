module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in 5-bit chunks (51 chunks)
    wire [2:0] chunk_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : count_chunks
            assign chunk_counts[i] = in[i*5 + 0] + in[i*5 + 1] + 
                                   in[i*5 + 2] + in[i*5 + 3] + 
                                   in[i*5 + 4];
        end
    endgenerate

    // Second level: Sum groups of 3 chunks (17 groups)
    wire [4:0] level1 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : sum_level1
            if (i < 16) begin
                assign level1[i] = chunk_counts[i*3] + chunk_counts[i*3 + 1] + 
                                 chunk_counts[i*3 + 2];
            end else begin
                // Last group has only 3 chunks (51 total)
                assign level1[i] = chunk_counts[48] + chunk_counts[49] + chunk_counts[50];
            end
        end
    endgenerate

    // Third level: Balanced binary tree of adders
    // First stage: Sum groups of 3 level1 results (6 groups)
    wire [6:0] level2 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : sum_level2
            assign level2[i] = level1[i*3] + level1[i*3 + 1] + level1[i*3 + 2];
        end
        // Last group has 2 elements (17 total)
        assign level2[5] = level1[15] + level1[16];
    endgenerate

    // Fourth level: Final reduction
    wire [7:0] level3 [0:1];
    assign level3[0] = level2[0] + level2[1] + level2[2];
    assign level3[1] = level2[3] + level2[4] + level2[5];

    // Final sum
    assign out = level3[0] + level3[1];

endmodule