module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First stage: Count 1s in 3-bit groups (85 groups total)
    wire [7:0] group_counts [0:84];
    
    // Process complete 3-bit groups (first 84 groups)
    genvar i;
    generate
        for (i = 0; i < 84; i = i + 1) begin : group_counters
            wire [2:0] group = in[i*3 +: 3];
            assign group_counts[i] = {6'b0, group[0]} + {6'b0, group[1]} + {6'b0, group[2]};
        end
    endgenerate
    
    // Handle last partial group (bits 252-254)
    assign group_counts[84] = {6'b0, in[252]} + {6'b0, in[253]} + {6'b0, in[254]};

    // Second stage: Sum groups of 4 (21 sums)
    wire [7:0] stage2_sums [0:20];
    generate
        for (i = 0; i < 21; i = i + 1) begin : stage2_adders
            assign stage2_sums[i] = group_counts[i*4] + group_counts[i*4+1] + 
                                   group_counts[i*4+2] + group_counts[i*4+3];
        end
    endgenerate

    // Third stage: Sum remaining groups (84th group + stage2 sums)
    wire [7:0] stage3_sum_a = stage2_sums[0] + stage2_sums[1] + stage2_sums[2] + stage2_sums[3];
    wire [7:0] stage3_sum_b = stage2_sums[4] + stage2_sums[5] + stage2_sums[6] + stage2_sums[7];
    wire [7:0] stage3_sum_c = stage2_sums[8] + stage2_sums[9] + stage2_sums[10] + stage2_sums[11];
    wire [7:0] stage3_sum_d = stage2_sums[12] + stage2_sums[13] + stage2_sums[14] + stage2_sums[15];
    wire [7:0] stage3_sum_e = stage2_sums[16] + stage2_sums[17] + stage2_sums[18] + stage2_sums[19];
    wire [7:0] stage3_sum_f = stage2_sums[20] + group_counts[84];

    // Final balanced summation
    wire [7:0] sum_ab = stage3_sum_a + stage3_sum_b;
    wire [7:0] sum_cd = stage3_sum_c + stage3_sum_d;
    wire [7:0] sum_ef = stage3_sum_e + stage3_sum_f;
    wire [7:0] sum_abcd = sum_ab + sum_cd;
    
    assign out = sum_abcd + sum_ef;

endmodule