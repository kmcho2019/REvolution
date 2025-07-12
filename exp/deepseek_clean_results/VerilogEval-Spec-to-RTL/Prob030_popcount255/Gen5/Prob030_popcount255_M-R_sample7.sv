module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: Count 6-bit chunks (42 full + 1 partial)
    wire [2:0] chunk_counts [0:42];
    genvar i;
    generate
        for (i = 0; i < 42; i = i + 1) begin : count_full_chunks
            assign chunk_counts[i] = 
                in[i*6 + 0] + in[i*6 + 1] + in[i*6 + 2] + 
                in[i*6 + 3] + in[i*6 + 4] + in[i*6 + 5];
        end
        // Last partial chunk (3 bits)
        assign chunk_counts[42] = in[252] + in[253] + in[254];
    endgenerate

    // Level 2: Sum groups of 4 chunks (11 groups)
    wire [4:0] level1_sums [0:10];
    generate
        for (i = 0; i < 10; i = i + 1) begin : sum_groups
            assign level1_sums[i] = 
                chunk_counts[i*4] + chunk_counts[i*4 + 1] + 
                chunk_counts[i*4 + 2] + chunk_counts[i*4 + 3];
        end
        // Last group (3 chunks)
        assign level1_sums[10] = 
            chunk_counts[40] + chunk_counts[41] + chunk_counts[42];
    endgenerate

    // Level 3: Balanced binary tree for final sum
    wire [5:0] sum_a = level1_sums[0] + level1_sums[1] + level1_sums[2];
    wire [5:0] sum_b = level1_sums[3] + level1_sums[4] + level1_sums[5];
    wire [5:0] sum_c = level1_sums[6] + level1_sums[7] + level1_sums[8];
    wire [5:0] sum_d = level1_sums[9] + level1_sums[10];
    
    wire [6:0] sum_ab = sum_a + sum_b;
    wire [6:0] sum_cd = sum_c + sum_d;
    
    assign out = sum_ab + sum_cd;

endmodule