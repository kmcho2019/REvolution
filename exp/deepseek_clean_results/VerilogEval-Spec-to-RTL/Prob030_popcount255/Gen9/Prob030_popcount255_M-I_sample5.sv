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

    // Level 2: Sum 4 level1 counters (21 groups of 4, 1 remainder)
    wire [3:0] level2 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                             level1[i*4+2] + level1[i*4+3];
        end
        assign level2[21] = level1[84];  // Last remaining counter
    endgenerate

    // Level 3: Sum 4 level2 counters (5 groups of 4, 2 remainders)
    wire [5:0] level3 [0:6];
    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*4] + level2[i*4+1] + 
                             level2[i*4+2] + level2[i*4+3];
        end
        // Handle remainders efficiently
        assign level3[5] = level2[20] + level2[21];
    endgenerate

    // Level 4: Sum 4 level3 counters (1 group of 4, 2 remainders)
    wire [7:0] level4 [0:1];
    generate
        assign level4[0] = level3[0] + level3[1] + level3[2] + level3[3];
        assign level4[1] = level3[4] + level3[5];
    endgenerate

    // Final addition
    assign out = level4[0] + level4[1];

endmodule