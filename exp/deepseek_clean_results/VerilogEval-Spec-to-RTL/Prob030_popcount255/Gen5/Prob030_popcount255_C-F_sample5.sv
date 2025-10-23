module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: Count '1's in 8-bit chunks (31 groups of 8, 1 group of 7)
    wire [3:0] level1 [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign level1[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                              in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit group
        assign level1[31] = in[254] + in[253] + in[252] + in[251] +
                            in[250] + in[249] + in[248];
    endgenerate

    // Level 2: First stage of binary tree (16 pairs)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Level 3: Second stage of binary tree (8 pairs)
    wire [5:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Level 4: Third stage of binary tree (4 pairs)
    wire [6:0] level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Final stage: Parallel addition (carry-save style)
    wire [7:0] sum1, sum2;
    assign sum1 = level4[0] + level4[1];
    assign sum2 = level4[2] + level4[3];
    assign out = sum1 + sum2;

endmodule