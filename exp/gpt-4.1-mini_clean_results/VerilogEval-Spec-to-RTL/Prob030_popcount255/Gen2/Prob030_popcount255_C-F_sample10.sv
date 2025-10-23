module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => 5 bits, use 6 bits for margin
);
    // Use an explicit tree-based summation of bits:
    // Stage 1: sum pairs (8 pairs + 1 leftover)
    wire [1:0] pair_sum [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pair_sum_gen
            assign pair_sum[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [3:0] sum_stage2;
    // sum_stage2[i]: sum of pair_sum[2*i] + pair_sum[2*i+1]
    assign sum_stage2[0] = pair_sum[0] + pair_sum[1];
    assign sum_stage2[1] = pair_sum[2] + pair_sum[3];
    assign sum_stage2[2] = pair_sum[4] + pair_sum[5];
    assign sum_stage2[3] = pair_sum[6] + pair_sum[7];

    // leftover bit is in[16], add it later

    // Stage 3: sum pairs from stage2
    wire [4:0] sum_stage3_0 = sum_stage2[0] + sum_stage2[1]; // max 4 bits + 4 bits = 5 bits
    wire [4:0] sum_stage3_1 = sum_stage2[2] + sum_stage2[3];

    // Stage 4: sum stage3 results and leftover bit
    wire [5:0] stage4_sum = sum_stage3_0 + sum_stage3_1 + in[16];

    assign out = stage4_sum;

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts (each max 17)

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Now sum 15 partial counts (each max 17) into one 8-bit output
    // Max sum = 15 * 17 = 255 fits in 8 bits

    // Level 1: sum pairs of partial_counts (7 pairs) + one leftover
    wire [7:0] sum_level1 [7:0];
    genvar i;

    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        // Last one (15th) passes through with zero-extension
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: final sum of last two outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule