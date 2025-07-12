module popcount4 (
    input  [3:0] in,
    output [3:0] out // max 4 ones, 3 bits suffice, use 4 bits for CSA convenience
);
    // Direct combinational addition of 4 bits into a 4-bit output
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones need 5 bits, use 6 bits for margin
);
    // Break input into 4 groups of 4 bits + 1 bit
    wire [3:0] pc0, pc1, pc2, pc3; // 4-bit popcounts (0..4)
    popcount4 pc_0 (.in(in[3:0]),     .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),     .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),    .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),   .out(pc3));
    wire [3:0] pc_sum; // sum of 4 pcs (4 bits each)
    // Sum pc0, pc1, pc2, pc3 using carry-save adders (CSA) style:
    // sum all four 4-bit numbers via two stages of addition:
    // First stage: add pc0+pc1 and pc2+pc3
    wire [4:0] sum01 = pc0 + pc1; // max 8 (4 bits + 4 bits)
    wire [4:0] sum23 = pc2 + pc3; // max 8

    wire [5:0] sum0123 = sum01 + sum23; // max 16 (5 bits + 5 bits)

    // Add last bit (in[16])
    assign out = sum0123 + in[16]; // 6 bits max

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 15 chunks of 17 bits and popcount each
    wire [5:0] partial_counts [14:0];
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : POPCNT17_BLOCKS
            popcount17 pc (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Use carry-save adders in summation tree to reduce carry propagation

    // Level 1: sum pairs of partial_counts (6 bits each) to 7 bits
    wire [6:0] sum_level1 [6:0]; // 7 sums total (since 15 inputs)
    generate
        for (i = 0; i < 7; i = i + 1) begin : SUM_LEVEL1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1]; // 6b + 6b = 7b max (34)
        end
    endgenerate
    // The 15th input is alone; extend and assign to last sum_level1
    assign sum_level1[6] = partial_counts[14];

    // Level 2: sum pairs of sum_level1 outputs (7 bits each) to 8 bits
    wire [7:0] sum_level2 [3:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1]; // max 68 fits in 8 bits
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];
    assign sum_level2[2] = sum_level1[4] + sum_level1[5];
    assign sum_level2[3] = sum_level1[6]; // single input, assign to 8 bits with zero extension
    // Explicit zero-extension for clarity
    wire [7:0] sum_level2_3 = {1'b0, sum_level1[6]};
    assign sum_level2[3] = sum_level2_3;

    // Level 3: sum pairs of sum_level2 outputs (8 bits) to 9 bits
    wire [8:0] sum_level3 [1:0];
    assign sum_level3[0] = sum_level2[0] + sum_level2[1]; // max 136 < 9 bits
    assign sum_level3[1] = sum_level2[2] + sum_level2[3]; // max 136 < 9 bits

    // Level 4: sum the two final sums (9 bits) to 10 bits
    wire [9:0] final_sum = sum_level3[0] + sum_level3[1]; // max 255 fits in 8 bits, 10 bits for margin

    // Output is 8 bits; since max popcount is 255 (8 bits), truncate to 8 bits
    assign out = final_sum[7:0];

endmodule