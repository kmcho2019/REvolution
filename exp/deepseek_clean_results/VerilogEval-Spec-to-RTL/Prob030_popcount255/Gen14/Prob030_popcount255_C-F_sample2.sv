module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 4 bits (64 groups)
    // Last group (bits 252-255) will have bit 255 as 0 (since input is 255 bits)
    wire [2:0] partial_counts [0:63];  // 3 bits per count (max 4)
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : COUNT_4BITS
            wire [3:0] group;
            assign group = (i == 63) ? {1'b0, in[254:252]} : in[i*4 +: 4];
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3];
        end
    endgenerate

    // Second level: Sum pairs using 4-bit adders (32 adders)
    wire [3:0] level1_sums [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL1_SUMS
            assign level1_sums[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate

    // Third level: Sum pairs using 5-bit adders (16 adders)
    wire [4:0] level2_sums [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2_SUMS
            assign level2_sums[i] = level1_sums[i*2] + level1_sums[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs using 6-bit adders (8 adders)
    wire [5:0] level3_sums [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL3_SUMS
            assign level3_sums[i] = level2_sums[i*2] + level2_sums[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs using 7-bit adders (4 adders)
    wire [6:0] level4_sums [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL4_SUMS
            assign level4_sums[i] = level3_sums[i*2] + level3_sums[i*2+1];
        end
    endgenerate

    // Sixth level: Sum pairs using 8-bit adders (2 adders)
    wire [7:0] level5_sums [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : LEVEL5_SUMS
            assign level5_sums[i] = level4_sums[i*2] + level4_sums[i*2+1];
        end
    endgenerate

    // Final sum
    assign out = level5_sums[0] + level5_sums[1];

endmodule