module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 8-bit chunks (31 full chunks + 1 partial)
    wire [3:0] level1 [0:31];  // 4 bits per counter (max 8)
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                              in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit chunk
        assign level1[31] = in[254] + in[253] + in[252] + in[251] +
                           in[250] + in[249] + in[248];
    endgenerate

    // Level 2: Sum 4 level1 counters (8 groups) - 6 bits needed (max 32)
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                             level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Level 3: Sum 2 level2 counters (4 groups) - 7 bits needed (max 64)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Level 4: Sum 2 level3 counters (2 groups) - 8 bits needed (max 128)
    wire [7:0] level4 [0:1];
    assign level4[0] = level3[0] + level3[1];
    assign level4[1] = level3[2] + level3[3];

    // Final output
    assign out = level4[0] + level4[1];

endmodule