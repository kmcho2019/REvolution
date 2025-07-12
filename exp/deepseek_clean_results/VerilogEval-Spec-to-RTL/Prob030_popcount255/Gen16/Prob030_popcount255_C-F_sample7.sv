module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in 3-bit groups (85 groups)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : COUNT_3BIT
            assign level1[i] = in[i*3] + in[i*3+1] + 
                             ((i*3+2 <= 254) ? in[i*3+2] : 1'b0);
        end
    endgenerate

    // Second level: Combine 4 counts at a time (21 groups)
    wire [3:0] level2 [0:20];
    generate
        for (i = 0; i < 21; i = i + 1) begin : COMBINE_4X2BIT
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                             level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Handle remaining count (85 - 21*4 = 1)
    wire [3:0] level2_remain = level1[84];

    // Third level: Combine 5 groups at a time
    wire [5:0] level3 [0:4];
    generate
        for (i = 0; i < 4; i = i + 1) begin : COMBINE_5X4BIT
            assign level3[i] = level2[i*5] + level2[i*5+1] + 
                              level2[i*5+2] + level2[i*5+3] + 
                              level2[i*5+4];
        end
    endgenerate

    // Handle remaining counts (21 - 4*5 = 1)
    assign level3[4] = level2[20] + level2_remain;

    // Final balanced accumulation
    wire [6:0] sum_low = level3[0] + level3[1];
    wire [6:0] sum_high = level3[2] + level3[3];
    wire [7:0] total_count = sum_low + sum_high + level3[4];

    assign out = total_count;

endmodule