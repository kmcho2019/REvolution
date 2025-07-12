module popcount4 (
    input  [3:0] in,
    output [2:0] out  // max 4 ones, 3 bits needed
);
    // Explicit balanced addition:
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [2:0] total = sum01 + sum23;
    assign out = total;
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, needs 5 bits, use 6 bits for safety
);
    // Use four popcount4 plus leftover bit in[16]
    wire [2:0] pc0, pc1, pc2, pc3;

    popcount4 pc_0 (.in(in[3:0]),    .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),    .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),   .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),  .out(pc3));

    // Sum pairs: pc0+pc1 and pc2+pc3
    wire [4:0] sum01 = pc0 + pc1; // max 8 (3 bits + 3 bits = 4 bits), use 5 bits safe
    wire [4:0] sum23 = pc2 + pc3;

    // Sum these two sums: sum01 + sum23 (5 bits + 5 bits = 6 bits max 16)
    wire [5:0] sum0123 = sum01 + sum23;

    // Add leftover bit in[16]
    assign out = sum0123 + in[16];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // 15 partial popcounts of 17 bits each
    wire [5:0] partial_counts [14:0];

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : popcount17_blocks
            popcount17 pc (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced adder tree to sum 15 partial counts (6 bits each)
    // Max total 255 fits in 8 bits
    // Implement multi-level summation in generate loops for scalability

    // Level 1: sum pairs of partial_counts
    // 15 inputs -> 7 sums + 1 leftover single input (zero-extended)
    wire [7:0] sum_level1 [7:0];
    generate
        for (i = 0; i < 7; i = i + 1) begin : sum_l1_pairs
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate
    assign sum_level1[7] = {2'b00, partial_counts[14]}; // zero extend to 8 bits

    // Level 2: sum pairs of sum_level1 outputs (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_l2_pairs
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_l3_pairs
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum the final two outputs
    assign out = sum_level3[0] + sum_level3[1];
endmodule