module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in each 5-bit chunk (51 chunks)
    wire [4:0] chunk_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : count_chunks
            assign chunk_counts[i] = 
                in[i*5 + 0] + in[i*5 + 1] + 
                in[i*5 + 2] + in[i*5 + 3] + 
                in[i*5 + 4];
        end
    endgenerate

    // Second level: Sum groups of 3 chunks (17 groups)
    wire [4:0] level1 [0:16];  // Max sum is 15 (3x5), so 5 bits suffice
    generate
        for (i = 0; i < 17; i = i + 1) begin : sum_level1
            assign level1[i] = chunk_counts[i*3] + chunk_counts[i*3 + 1] + chunk_counts[i*3 + 2];
        end
    endgenerate

    // Third level: Balanced binary tree summation of 17 level1 results
    // First stage: Sum pairs (8 adders, 1 leftover)
    wire [5:0] tree_stage1 [0:8];
    generate
        for (i = 0; i < 8; i = i + 1) begin : tree1
            assign tree_stage1[i] = level1[i*2] + level1[i*2 + 1];
        end
        assign tree_stage1[8] = level1[16];  // Last odd element
    endgenerate

    // Second stage: Sum groups (4 adders, 1 leftover)
    wire [6:0] tree_stage2 [0:4];
    generate
        for (i = 0; i < 4; i = i + 1) begin : tree2
            assign tree_stage2[i] = tree_stage1[i*2] + tree_stage1[i*2 + 1];
        end
        assign tree_stage2[4] = tree_stage1[8];  // Last odd element
    endgenerate

    // Third stage: Sum groups (2 adders, 1 leftover)
    wire [7:0] tree_stage3 [0:2];
    generate
        for (i = 0; i < 2; i = i + 1) begin : tree3
            assign tree_stage3[i] = tree_stage2[i*2] + tree_stage2[i*2 + 1];
        end
        assign tree_stage3[2] = tree_stage2[4];  // Last odd element
    endgenerate

    // Final stage: Sum remaining 3 elements
    assign out = tree_stage3[0] + tree_stage3[1] + tree_stage3[2];

endmodule