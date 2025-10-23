module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones fits in 5 bits but use 6 bits for margin
);
    // Balanced adder tree summation of 17 bits

    // Level 1: sum pairs of bits (8 sums) + 1 leftover bit
    wire [1:0] sum_l1 [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    wire leftover_bit = in[16];

    // Level 2: sum pairs of 2-bit values (4 sums)
    wire [2:0] sum_l2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of 3-bit values (2 sums)
    wire [3:0] sum_l3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l3
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i+1];
        end
    endgenerate

    // Level 4: sum the two 4-bit sums (1 sum)
    wire [4:0] sum_l4;
    assign sum_l4 = sum_l3[0] + sum_l3[1];

    // Add leftover bit (1-bit) from Level 1
    assign out = sum_l4 + leftover_bit;

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

    // Sum partial_counts in a balanced adder tree

    wire [7:0] sum_level1 [7:0];
    genvar i;

    // Level 1: sum pairs of partial_counts
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        // Last one (15th) zero-extended
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: final sum
    assign out = sum_level3[0] + sum_level3[1];

endmodule