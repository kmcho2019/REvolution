module popcount5 (
    input  [4:0] in,
    output [3:0] out  // max 5 ones => 3 bits enough, but use 4 bits for alignment
);
    // Count number of '1's in 5 bits via combinational logic
    // Implement as simple combinational sum of bits
    assign out = in[0] + in[1] + in[2] + in[3] + in[4];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Stage 1: split into 51 groups of 5 bits each
    // partial_counts[i] = number of ones in in[5*i +: 5]
    wire [3:0] partial_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : pc5_blocks
            popcount5 pc5 (
                .in(in[5*i +: 5]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Stage 2: sum partial counts in a balanced tree
    // 51 values of 4 bits sum up to max 255 total ones.
    // We'll sum them using adders grouping 3 at a time (ternary adder tree)

    // Level 2: sum groups of 3 partial_counts -> 17 sums (last group has 2 inputs)
    wire [7:0] sum_level2 [0:16]; // max sum for 3*5=15 ones fits in 8 bits
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign sum_level2[i] = partial_counts[3*i] + partial_counts[3*i+1] + partial_counts[3*i+2];
        end
    endgenerate
    // Last group has only 2 partial_counts (indices 48 and 49), plus last single 50th
    wire [7:0] last_two_sum = partial_counts[48] + partial_counts[49];
    wire [7:0] last_sum = last_two_sum + partial_counts[50];
    assign sum_level2[16] = last_sum;

    // Level 3: sum 17 values from level 2 in groups of 3
    // 17 -> 6 groups of 3, plus 1 leftover
    wire [10:0] sum_level3 [0:6]; 
    // 11 bits max: 3*15=45 max ones per sum_level2; 3*45=135 max at this level fits 8 bits but we reserve 11 for safety
    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_adders
            assign sum_level3[i] = sum_level2[3*i] + sum_level2[3*i+1] + sum_level2[3*i+2];
        end
        // last group: sum_level2[15] + sum_level2[16] (two inputs)
        assign sum_level3[5] = sum_level2[15] + sum_level2[16];
    endgenerate
    // There's one leftover sum_level2 element not included in above groups because 17 elements total, but we summed 3*5=15 + 2 in sum_level3.
    // Actually, above sums sum indices 0..16 properly: 5 groups *3=15 + one group of 2 at sum_level2 indices 15 and 16.
    // Correction: sum_level2 has 17 elements, we grouped as (0..14) into five groups of 3, and (15..16) last group of 2.
    // Above code accounts for that, so sum_level3 has 6 groups, not 7. Let's fix index range.

    // Fix sum_level3 size and indexing: 6 groups total
    // Re-declare sum_level3 as size 6
    // Move last_sum assignment accordingly

    // Corrected:
    // declare sum_level3 [0:5]
    // sum_level3[0..4]: sums of 3 groups from sum_level2[0..14]
    // sum_level3[5]: sum_level2[15] + sum_level2[16]

    // Let's fix above declarations:

endmodule

// Revised code with corrected levels:

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Stage 1: 51 groups of 5 bits
    wire [3:0] partial_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : pc5_blocks
            popcount5 pc5 (
                .in(in[5*i +: 5]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Stage 2: sum groups of 3 partial_counts -> 17 groups
    wire [7:0] sum_level2 [0:16];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign sum_level2[i] = partial_counts[3*i] + partial_counts[3*i+1] + partial_counts[3*i+2];
        end
    endgenerate
    assign sum_level2[16] = partial_counts[48] + partial_counts[49] + partial_counts[50];

    // Stage 3: sum 17 values from level 2 in groups of 3 -> 5 groups + 1 leftover group
    wire [10:0] sum_level3 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_adders
            assign sum_level3[i] = sum_level2[3*i] + sum_level2[3*i+1] + sum_level2[3*i+2];
        end
    endgenerate
    assign sum_level3[5] = sum_level2[15] + sum_level2[16];

    // Stage 4: sum 6 values from level 3 -> 2 groups + 1 leftover
    wire [13:0] sum_level4 [0:2];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1] + sum_level3[2];
    assign sum_level4[1] = sum_level3[3] + sum_level3[4] + sum_level3[5];
    assign sum_level4[2] = 0;  // no leftover, pad with 0

    // Stage 5: sum 2 values (sum_level4[0] and sum_level4[1])
    wire [14:0] sum_level5;
    assign sum_level5 = sum_level4[0] + sum_level4[1]; // max sum fits in 15 bits safely

    // Final output is the lower 8 bits (max count = 255)
    assign out = sum_level5[7:0];

endmodule