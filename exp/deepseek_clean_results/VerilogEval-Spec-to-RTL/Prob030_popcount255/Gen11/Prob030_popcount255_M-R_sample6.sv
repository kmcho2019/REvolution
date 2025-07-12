module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Split into 32 groups of 8 bits (last group has 7 bits)
    wire [7:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign partial_counts[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                      in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit group
        assign partial_counts[31] = in[254] + in[253] + in[252] + in[251] +
                                   in[250] + in[249] + in[248];
    endgenerate

    // Sum all partial counts using a balanced binary tree
    wire [7:0] level1 [0:15];
    wire [7:0] level2 [0:7];
    wire [7:0] level3 [0:3];
    wire [7:0] level4 [0:1];
    
    // Level 1: Sum pairs of partial counts
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL1
            assign level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate
    
    // Level 2: Sum pairs of level1 results
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL2
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate
    
    // Level 3: Sum pairs of level2 results
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL3
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate
    
    // Level 4: Sum pairs of level3 results
    generate
        for (i = 0; i < 2; i = i + 1) begin : SUM_LEVEL4
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
    endgenerate
    
    // Final sum
    assign out = level4[0] + level4[1];

endmodule