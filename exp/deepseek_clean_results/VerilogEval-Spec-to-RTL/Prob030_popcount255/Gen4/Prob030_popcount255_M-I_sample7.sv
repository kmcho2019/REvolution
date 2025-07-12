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

    // Level 2: Sum 3 level1 counters (28 groups of 3, 1 remainder)
    wire [3:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Directly assign last counter without zero extension
        assign level2[28] = level1[84];
    endgenerate

    // Level 3: Sum 3 level2 counters (9 groups of 3, 2 remainders)
    wire [5:0] level3 [0:10];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Distribute remainders more evenly
        assign level3[9] = level2[27] + level2[28];
        assign level3[10] = level2[26];  // Unused in final sum
    endgenerate

    // Level 4: Sum 3 level3 counters (3 groups of 3, 2 remainders)
    wire [7:0] level4 [0:4];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        // Handle remainders efficiently
        assign level4[3] = level3[9];
        assign level4[4] = level3[10];  // Unused in final sum
    endgenerate

    // Final level: Carry-save addition of 4 terms
    wire [7:0] sum1, sum2;
    assign sum1 = level4[0] + level4[1];  // First parallel addition
    assign sum2 = level4[2] + level4[3];  // Second parallel addition
    assign out = sum1 + sum2;             // Final addition

endmodule