module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: Count 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Level 2: Sum adjacent pairs (43 sums)
    wire [2:0] level2 [0:42];
    generate
        for (i = 0; i < 42; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
        // Handle the odd remaining count
        assign level2[42] = level1[84];
    endgenerate

    // Level 3: Sum adjacent pairs (22 sums)
    wire [3:0] level3 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
        // Handle the odd remaining count
        assign level3[21] = level2[42];
    endgenerate

    // Final level: Combine all remaining counts
    wire [7:0] sum1, sum2;
    assign sum1 = level3[0] + level3[1] + level3[2] + level3[3] +
                  level3[4] + level3[5] + level3[6] + level3[7] +
                  level3[8] + level3[9] + level3[10];
    
    assign sum2 = level3[11] + level3[12] + level3[13] + level3[14] +
                  level3[15] + level3[16] + level3[17] + level3[18] +
                  level3[19] + level3[20] + level3[21];
    
    assign out = sum1 + sum2;

endmodule