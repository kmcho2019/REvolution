module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];  // 2 bits per counter (max 3)
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (28 groups + 1 remainder)
    wire [3:0] level2 [0:28];  // 4 bits needed (max 9)
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Last counter
        assign level2[28] = level1[84];
    endgenerate

    // Level 3: Sum 3 level2 counters (9 groups + 1 remainder)
    wire [5:0] level3 [0:9];  // 6 bits needed (max 27)
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Last group
        assign level3[9] = level2[27] + level2[28];
    endgenerate

    // Final addition
    wire [7:0] sum0 = level3[0] + level3[1] + level3[2];
    wire [7:0] sum1 = level3[3] + level3[4] + level3[5];
    wire [7:0] sum2 = level3[6] + level3[7] + level3[8];
    wire [7:0] sum3 = level3[9];
    
    assign out = sum0 + sum1 + sum2 + sum3;

endmodule