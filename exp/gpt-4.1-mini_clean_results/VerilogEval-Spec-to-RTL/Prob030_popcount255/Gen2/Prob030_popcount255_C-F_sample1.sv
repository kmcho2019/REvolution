module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, needs 5 bits but use 6 bits for margin
);
    // Implement popcount with a parallel adder tree for better timing
    // Stage 1: sum bits pairwise (8 sums + 1 leftover)
    wire [1:0] sum2 [7:0];
    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : gen_sum2
            assign sum2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    wire [1:0] sum2_last = {1'b0, in[16]}; // Last single bit padded with zero
    
    // Stage 2: sum pairs of sum2 (4 sums) + leftover from sum2_last
    wire [2:0] sum3 [3:0]; // max 3 bits to hold 0..4
    generate
        for(i = 0; i < 3; i = i + 1) begin : gen_sum3
            assign sum3[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate
    // sum3[3] sums leftover from sum2_last (2 bits) + sum2[14], but we only have sum2_last for last bit
    assign sum3[3] = sum2[14] + sum2_last; // sum2[14] is in range [0..2], sum2_last [0..1]

    // Stage 3: sum pairs of sum3 (2 sums)
    wire [3:0] sum4 [1:0]; // max 4 bits to hold 0..8
    assign sum4[0] = sum3[0] + sum3[1];
    assign sum4[1] = sum3[2] + sum3[3];

    // Stage 4: final sum
    wire [4:0] sum5;
    assign sum5 = sum4[0] + sum4[1];

    // Output zero-extended to 6 bits for safety
    assign out = {1'b0, sum5};

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Partition input into 15 groups of 17 bits each (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial sums from popcount17

    genvar gi;
    generate
        for(gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc17_inst (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum 15 partial_counts (each 6 bits max 17) into a total count (8 bits max 255)
    // Balanced adder tree, using continuous assignments and intermediate wires

    // Level 1: sum pairs of partial_counts (7 sums) + 1 leftover
    wire [7:0] sum_level1 [7:0];
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i + 1];
        end
        // Leftover partial_counts[14] zero-extended to 8 bits
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for(i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for(i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    // Level 4: sum final two outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule