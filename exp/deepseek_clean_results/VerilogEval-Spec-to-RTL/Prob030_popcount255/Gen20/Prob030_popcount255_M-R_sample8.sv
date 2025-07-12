module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 4 bits (64 groups)
    wire [2:0] partial_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : COUNT_4BITS
            wire [3:0] group = in[i*4 +: 4];
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3];
        end
        // Handle last group (3 bits)
        wire [2:0] last_group = in[252 +: 3];
        assign partial_counts[63] = last_group[0] + last_group[1] + last_group[2];
    endgenerate

    // Second level: Binary tree summation
    wire [7:0] level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : SUM_LEVEL1
            assign level1[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate

    wire [7:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    wire [7:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    wire [7:0] level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    wire [7:0] level5 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : SUM_LEVEL5
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
    endgenerate

    // Final sum
    assign out = level5[0] + level5[1];

endmodule