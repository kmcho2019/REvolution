// Small module: popcount4 counts number of ones in 4 bits (0..4)
// Output width: 3 bits to represent values 0 to 4
module popcount4 (
    input  [3:0] in,
    output [2:0] out
);
    // Simple parallel sum of 4 bits: sum = in[0] + in[1] + in[2] + in[3]
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

// Module: popcount17 counts number of ones in 17 bits
// It uses 4 popcount4 blocks on first 16 bits + 1 bit add, summing to 6-bit output
module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones -> 5 bits enough, 6 bits used for safety
);

    // Split 17 bits into 4 groups of 4 bits + 1 leftover bit
    wire [2:0] pc4 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : pc4_blocks
            popcount4 pc4_inst(
                .in(in[i*4 +: 4]),
                .out(pc4[i])
            );
        end
    endgenerate

    // Sum the 4 popcount4 outputs and the leftover bit (in[16])
    // max sum = 4*4 + 1 = 17 fits in 6 bits
    // Use a balanced adder tree:

    wire [4:0] sum_pc4_0_1 = pc4[0] + pc4[1];  // max 8 bits
    wire [4:0] sum_pc4_2_3 = pc4[2] + pc4[3];  // max 8 bits
    wire [5:0] sum_4pcs = sum_pc4_0_1 + sum_pc4_2_3; // max 16 bits
    assign out = sum_4pcs + in[16]; // add leftover bit

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 blocks of 17 bits each
    wire [5:0] partial_counts [14:0]; // 15 partial counts from popcount17

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : popcount17_blocks
            popcount17 pc17 (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum the 15 partial counts in a balanced adder tree (each up to 17)
    // Max total sum = 15 * 17 = 255 fits in 8 bits

    // Level 1: sum pairs of partial_counts (7 pairs) + one leftover
    wire [7:0] sum_level1 [7:0];
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            // zero-extend from 6 bits to 8 bits
            assign sum_level1[i] = {2'b00, partial_counts[2*i]} + {2'b00, partial_counts[2*i + 1]};
        end
        // last one passes through zero-extended
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (8 inputs -> 4 outputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (4 inputs -> 2 outputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    // Level 4: sum final two outputs (2 inputs -> 1 output)
    assign out = sum_level3[0] + sum_level3[1];

endmodule