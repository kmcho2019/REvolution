module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Count '1's in each 8-bit chunk (31 chunks) and 7-bit chunk (1 chunk)
    wire [3:0] count_8bit [0:30];  // 4-bit counters for 8-bit chunks (max 8)
    wire [2:0] count_7bit;         // 3-bit counter for 7-bit chunk (max 7)
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign count_8bit[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                   in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle the last 7-bit chunk
        assign count_7bit = in[254] + in[253] + in[252] + in[251] +
                            in[250] + in[249] + in[248];
    endgenerate

    // Second level: Sum pairs of 8-bit chunk counts (16 adders)
    wire [4:0] sum_level1 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : LEVEL1_ADDS
            assign sum_level1[i] = count_8bit[i*2] + count_8bit[i*2+1];
        end
        // Last sum includes the remaining 8-bit counter and 7-bit counter
        assign sum_level1[15] = count_8bit[30] + count_7bit;
    endgenerate

    // Third level: Sum pairs of level1 results (8 adders)
    wire [5:0] sum_level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2_ADDS
            assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of level2 results (4 adders)
    wire [6:0] sum_level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3_ADDS
            assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of level3 results (2 adders)
    wire [7:0] sum_level4 [0:1];
    generate
        assign sum_level4[0] = sum_level3[0] + sum_level3[1];
        assign sum_level4[1] = sum_level3[2] + sum_level3[3];
    endgenerate

    // Final sum
    assign out = sum_level4[0] + sum_level4[1];

endmodule