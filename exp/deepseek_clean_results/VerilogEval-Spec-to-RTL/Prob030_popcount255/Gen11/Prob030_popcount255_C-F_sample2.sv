module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: Count '1's in 8-bit chunks (31 groups) + 7-bit group
    wire [3:0] level1 [0:31];  // 4 bits per counter (max 8)
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                               in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Last 7-bit group
        assign level1[31] = in[254] + in[253] + in[252] + in[251] +
                            in[250] + in[249] + in[248];
    endgenerate

    // Level 2: Sum 3 level1 counters (11 groups) with 1 remainder
    wire [5:0] level2 [0:11];  // 6 bits needed (max 24)
    generate
        for (i = 0; i < 10; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Last group (3 counters)
        assign level2[10] = level1[30] + level1[31];
    endgenerate

    // Level 3: Sum 3 level2 counters (4 groups)
    wire [7:0] level3 [0:3];  // 8 bits needed (max 72)
    generate
        for (i = 0; i < 3; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Last group (2 counters)
        assign level3[3] = level2[9] + level2[10];
    endgenerate

    // Final addition (balanced tree)
    wire [7:0] sum_left = level3[0] + level3[1];
    wire [7:0] sum_right = level3[2] + level3[3];
    
    assign out = sum_left + sum_right;

endmodule