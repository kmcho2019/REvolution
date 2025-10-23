module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => 5 bits, use 6 bits for safety
);
    // Balanced tree of additions for 17 bits

    // Stage 1: sum pairs of bits (8 pairs + 1 leftover)
    wire [1:0] sum_stage1 [7:0];
    assign sum_stage1[0] = in[1:0];
    assign sum_stage1[1] = in[3:2];
    assign sum_stage1[2] = in[5:4];
    assign sum_stage1[3] = in[7:6];
    assign sum_stage1[4] = in[9:8];
    assign sum_stage1[5] = in[11:10];
    assign sum_stage1[6] = in[13:12];
    assign sum_stage1[7] = in[15:14];
    wire [0:0] leftover = in[16];

    // Stage 2: sum pairs of 2-bit values to get 3-bit values
    wire [2:0] sum_stage2 [3:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];
    assign sum_stage2[2] = sum_stage1[4] + sum_stage1[5];
    assign sum_stage2[3] = sum_stage1[6] + sum_stage1[7];

    // Stage 3: sum pairs of 3-bit values to get 4-bit values
    wire [3:0] sum_stage3 [1:0];
    assign sum_stage3[0] = sum_stage2[0] + sum_stage2[1];
    assign sum_stage3[1] = sum_stage2[2] + sum_stage2[3];

    // Stage 4: sum two 4-bit values + leftover (1 bit) to get final sum
    wire [4:0] sum_stage4;
    assign sum_stage4 = sum_stage3[0] + sum_stage3[1] + leftover;

    // The maximum sum is 17, which fits in 5 bits. Output is 6 bits for safety.
    assign out = {1'b0, sum_stage4};

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum partial_counts in a balanced adder tree manner:

    wire [7:0] sum_level1 [7:0];
    genvar i;

    // Level 1: sum pairs of partial_counts (6-bit each)
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        // Last one (15th) zero-extended to 8 bits
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum final two outputs (2 inputs)
    assign out = sum_level3[0] + sum_level3[1];

endmodule