module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Count 1s in 8-bit chunks (3-bit results)
    wire [2:0] level0 [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign level0[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                              in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit chunk
        assign level0[31] = in[254] + in[253] + in[252] + in[251] +
                           in[250] + in[249] + in[248];
    endgenerate

    // Second level: Sum pairs of level0 (4-bit results)
    wire [3:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            assign level1[i] = level0[2*i] + level0[2*i+1];
        end
    endgenerate

    // Third level: Sum pairs of level1 (5-bit results)
    wire [4:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate

    // Fourth level: Sum pairs of level2 (6-bit results)
    wire [5:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate

    // Final level: Sum remaining pairs (8-bit result)
    wire [6:0] temp_sum1 = level3[0] + level3[1];
    wire [6:0] temp_sum2 = level3[2] + level3[3];
    assign out = temp_sum1 + temp_sum2;

endmodule