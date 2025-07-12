module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones fits in 5 bits but use 6 bits for margin
);
    // Implement popcount17 using a 3:2 compressor tree (full adders)
    // Step 1: Group input bits into sets of 3 bits and compress them into 2 bits
    // Repeat this reduction until the number of bits left fits into a single adder
    
    // Stage 0: initial bits (17 bits)
    wire [16:0] stage0 = in;
    
    // Stage 1: Compress groups of 3 bits into sum and carry bits using full adders
    // Number of full adders = floor(17/3) = 5, remainder bits = 2 bits
    
    wire [4:0] sum1;
    wire [4:0] carry1;
    wire [1:0] remainder1;

    genvar i;
    generate
        for (i=0; i<5; i=i+1) begin : fa_stage1
            // Full adder for bits: 3*i, 3*i+1, 3*i+2
            // sum1[i]: sum bit (LSB), carry1[i]: carry bit (MSB)
            assign sum1[i]   = stage0[3*i]   ^ stage0[3*i+1] ^ stage0[3*i+2];
            assign carry1[i] = (stage0[3*i] & stage0[3*i+1]) | (stage0[3*i] & stage0[3*i+2]) | (stage0[3*i+1] & stage0[3*i+2]);
        end
    endgenerate
    assign remainder1 = {stage0[15], stage0[16]}; // leftover bits
    
    // Stage 2:
    // Now we have sum1 (5 bits), carry1 (5 bits), remainder1 (2 bits) total 12 bits
    // Compress again in groups of 3:
    // Number of full adders = floor(12/3)=4, remainder bits=0
    
    wire [3:0] sum2;
    wire [3:0] carry2;

    // We'll arrange inputs for next compressors:
    // Inputs to stage2 are:
    // sum1[4:0], carry1[4:0], remainder1[1:0] - total 12 bits
    // Order bits as: sum1[0], carry1[0], sum1[1], carry1[1], sum1[2], carry1[2], sum1[3], carry1[3], sum1[4], carry1[4], remainder1[0], remainder1[1]

    wire [11:0] stage1_combined = {sum1[4], carry1[4], sum1[3], carry1[3], sum1[2], carry1[2], sum1[1], carry1[1], sum1[0], carry1[0], remainder1[1], remainder1[0]};
    // Group bits from LSB: bits [1:0], [3:2], [5:4], [7:6], [9:8], [11:10]
    // We take 4 groups of 3 bits for full adders:
    // Group0: bits [2:0]  = stage1_combined[2:0]  = bits 2,1,0
    // Group1: bits [5:3]  = bits 5,4,3
    // Group2: bits [8:6]  = bits 8,7,6
    // Group3: bits [11:9] = bits 11,10,9

    generate
        for(i=0; i<4; i=i+1) begin : fa_stage2
            wire a = stage1_combined[3*i];
            wire b = stage1_combined[3*i+1];
            wire c = stage1_combined[3*i+2];
            assign sum2[i] = a ^ b ^ c;
            assign carry2[i] = (a & b) | (b & c) | (a & c);
        end
    endgenerate

    // Stage 3:
    // Now we have sum2 (4 bits) and carry2 (4 bits) => total 8 bits to sum
    // Add these 8 bits directly using a binary adder as they are small

    wire [7:0] stage3_sum = {carry2, sum2}; // 8 bits

    // Final population count is the sum of these 8 bits
    // Use a simple adder to count bits set in 8 bits

    // Using built-in Verilog operator to count bits (for synthesis tools that support it)
    // Else implement popcount8 manually

    // Manual popcount8 implementation for compatibility and clarity:
    // Pairwise sums:
    wire [3:0] pair_sum;
    assign pair_sum[0] = stage3_sum[0] + stage3_sum[1];
    assign pair_sum[1] = stage3_sum[2] + stage3_sum[3];
    assign pair_sum[2] = stage3_sum[4] + stage3_sum[5];
    assign pair_sum[3] = stage3_sum[6] + stage3_sum[7];

    // Sum pairs:
    wire [4:0] pair_sum_level2_0 = pair_sum[0] + pair_sum[1];
    wire [4:0] pair_sum_level2_1 = pair_sum[2] + pair_sum[3];

    // Final sum:
    wire [5:0] final_sum = pair_sum_level2_0 + pair_sum_level2_1;

    assign out = final_sum; // 6 bits sufficient for max 17

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts (up to 17)

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum partial_counts in a balanced adder tree with explicit 8-bit widths
    // partial_counts are 6 bits max (max 17), so zero-extend to 8 bits for summation

    // Level 1: sum pairs of partial_counts (7 pairs) + leftover 15th partial count
    wire [7:0] sum_level1 [7:0];
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = {2'b00, partial_counts[2*i]} + {2'b00, partial_counts[2*i+1]};
        end
        assign sum_level1[7] = {2'b00, partial_counts[14]}; // leftover
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (4 sums)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (2 sums)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: final sum of the two sums (8 bits)
    assign out = sum_level3[0] + sum_level3[1];

endmodule