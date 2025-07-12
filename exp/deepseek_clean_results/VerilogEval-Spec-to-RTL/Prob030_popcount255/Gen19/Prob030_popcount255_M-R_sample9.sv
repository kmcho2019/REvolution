module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in 4-bit chunks (64 groups total)
    wire [3:0] level1_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : COUNT_4BIT
            assign level1_counts[i] = in[i*4+3] + in[i*4+2] + in[i*4+1] + in[i*4];
        end
        // Handle last 3-bit group
        assign level1_counts[63] = in[254] + in[253] + in[252];
    endgenerate

    // Second level: Sum pairs of 4-bit counts (32 groups of 8 bits)
    wire [4:0] level2_counts [0:31];
    generate
        for (i = 0; i < 31; i = i + 1) begin : SUM_PAIRS
            assign level2_counts[i] = level1_counts[i*2] + level1_counts[i*2+1];
        end
        // Handle last odd group
        assign level2_counts[31] = level1_counts[62] + level1_counts[63];
    endgenerate

    // Third level: Sum pairs of 5-bit counts (16 groups)
    wire [5:0] level3_counts [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL2
            assign level3_counts[i] = level2_counts[i*2] + level2_counts[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of 6-bit counts (8 groups)
    wire [6:0] level4_counts [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL3
            assign level4_counts[i] = level3_counts[i*2] + level3_counts[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of 7-bit counts (4 groups)
    wire [7:0] level5_counts [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL4
            assign level5_counts[i] = level4_counts[i*2] + level4_counts[i*2+1];
        end
    endgenerate

    // Final sum: Combine all counts
    assign out = level5_counts[0] + level5_counts[1] + level5_counts[2] + level5_counts[3];

endmodule