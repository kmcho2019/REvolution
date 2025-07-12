module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 4 bits (64 groups)
    wire [1:0] level1 [0:63];  // 2 bits sufficient (max count 4)
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : COUNT_4BITS
            localparam start = i*4;
            wire [3:0] group = (start+3 <= 254) ? in[start +: 4] : 
                               {in[start], (start+1 <= 254) ? in[start+1] : 1'b0,
                                (start+2 <= 254) ? in[start+2] : 1'b0,
                                (start+3 <= 254) ? in[start+3] : 1'b0};
            assign level1[i] = group[0] + group[1] + group[2] + group[3];
        end
    endgenerate

    // Second level: Sum pairs of level1 counts (32 sums)
    wire [2:0] level2 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : SUM_PAIRS_1
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Third level: Sum pairs of level2 counts (16 sums)
    wire [3:0] level3 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_PAIRS_2
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of level3 counts (8 sums)
    wire [4:0] level4 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_PAIRS_3
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of level4 counts (4 sums)
    wire [5:0] level5 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_PAIRS_4
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
    endgenerate

    // Sixth level: Sum pairs of level5 counts (2 sums)
    wire [6:0] level6 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : SUM_PAIRS_5
            assign level6[i] = level5[i*2] + level5[i*2+1];
        end
    endgenerate

    // Final sum
    wire [7:0] total_sum = level6[0] + level6[1] + 
                          (in[252] + in[253] + in[254]);  // Handle remaining 3 bits

    assign out = total_sum;

endmodule