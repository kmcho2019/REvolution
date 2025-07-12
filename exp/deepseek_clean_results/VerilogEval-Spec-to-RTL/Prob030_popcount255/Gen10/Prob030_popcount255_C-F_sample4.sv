module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            localparam start = i*3;
            wire [2:0] group = (start+2 <= 254) ? in[start +: 3] : 
                              {in[start], in[start+1], 1'b0};
            assign level1[i] = group[0] + group[1] + group[2];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (28 groups of 3, 1 leftover)
    wire [3:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        assign level2[28] = level1[84];
    endgenerate

    // Level 3: Sum 3 level2 counters (9 groups of 3, 2 leftovers)
    wire [5:0] level3 [0:9];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        assign level3[9] = level2[27] + level2[28];
    endgenerate

    // Final addition: Combine all level3 sums
    wire [7:0] sum = 
        level3[0] + level3[1] + level3[2] + level3[3] +
        level3[4] + level3[5] + level3[6] + level3[7] +
        level3[8] + level3[9];

    assign out = sum;

endmodule