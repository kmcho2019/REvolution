module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (28 groups of 3, 1 leftover)
    wire [3:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        assign level2[28] = level1[84];  // No zero extension needed
    endgenerate

    // Level 3: Sum 3 level2 counters (9 groups of 3, 2 leftovers)
    wire [5:0] level3 [0:9];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Combine last 3 counters (28,27,26) more efficiently
        assign level3[9] = level2[27] + level2[28];
    endgenerate

    // Level 4: Sum 3 level3 counters (3 groups of 3, 1 leftover)
    wire [7:0] level4 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        assign level4[3] = level3[9];
    endgenerate

    // Final addition using carry-save optimization
    wire [7:0] sum_a, sum_b;
    assign sum_a = level4[0] + level4[1];
    assign sum_b = level4[2] + level4[3];
    assign out = sum_a + sum_b;

endmodule