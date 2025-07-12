module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in 3-bit groups (85 groups)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : count_3bit
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Second level: Combine 4 counts (21 groups of 4 + 1 remaining)
    wire [3:0] level2 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : combine_4x2bit
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                             level1[i*4+2] + level1[i*4+3];
        end
    endgenerate
    // Handle remaining count
    assign level2[21] = level1[84];

    // Third level: Combine 4 counts (5 groups of 4 + 1 remaining)
    wire [5:0] level3 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : combine_4x4bit
            assign level3[i] = level2[i*4] + level2[i*4+1] + 
                             level2[i*4+2] + level2[i*4+3];
        end
    endgenerate
    // Handle remaining counts
    assign level3[5] = level2[20] + level2[21];

    // Final accumulation: Binary tree of remaining counts
    wire [6:0] sum_a = level3[0] + level3[1];
    wire [6:0] sum_b = level3[2] + level3[3];
    wire [6:0] sum_c = level3[4] + level3[5];
    wire [7:0] sum_ab = sum_a + sum_b;
    wire [7:0] total_count = sum_ab + sum_c;

    assign out = total_count;

endmodule