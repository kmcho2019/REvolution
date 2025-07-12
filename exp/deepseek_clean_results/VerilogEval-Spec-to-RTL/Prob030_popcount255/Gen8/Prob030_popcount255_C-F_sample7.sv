module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 5-bit chunks (51 chunks)
    wire [2:0] level1 [0:50];  // 3 bits needed (max 5)
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*5] + in[i*5+1] + in[i*5+2] + 
                             in[i*5+3] + in[i*5+4];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (17 groups)
    wire [4:0] level2 [0:16];  // 5 bits needed (max 15)
    generate
        for (i = 0; i < 17; i = i + 1) begin : level2_adders
            if (i < 16) begin
                assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
            end else begin
                // Last group has 3 counters (51 total)
                assign level2[i] = level1[48] + level1[49] + level1[50];
            end
        end
    endgenerate

    // Level 3: Sum 3 level2 counters (6 groups)
    wire [6:0] level3 [0:5];  // 7 bits needed (max 45)
    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Last group has 2 counters (17 total)
        assign level3[5] = level2[15] + level2[16];
    endgenerate

    // Level 4: Sum 3 level3 counters (2 groups)
    wire [7:0] level4 [0:1];  // 8 bits needed (max 153)
    assign level4[0] = level3[0] + level3[1] + level3[2];
    assign level4[1] = level3[3] + level3[4] + level3[5];

    // Final sum (two-step to maintain ternary structure)
    wire [7:0] temp_sum;
    assign temp_sum = level4[0] + level4[1];
    assign out = temp_sum;

endmodule