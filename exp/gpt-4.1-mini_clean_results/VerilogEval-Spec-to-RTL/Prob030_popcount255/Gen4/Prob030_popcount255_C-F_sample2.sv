module popcount4 (
    input  [3:0] in,
    output [3:0] out // max count 4, 3 bits enough, 4 bits for easy addition
);
    // Count bits by adding them explicitly
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [3:0] total = sum01 + sum23;
    assign out = total;
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones: 5 bits enough, 6 bits for safety
);
    // Use four popcount4 blocks plus one single bit
    wire [3:0] pc0, pc1, pc2, pc3;

    popcount4 pc_0 (.in(in[3:0]),    .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),    .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),   .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),  .out(pc3));

    // Explicit balanced addition tree without function or loops
    wire [5:0] sum01 = pc0 + pc1;     // max 8, fits in 4 bits, use 6 bits to avoid overflow
    wire [5:0] sum23 = pc2 + pc3;     // max 8
    wire [5:0] sum4  = sum01 + sum23; // max 16
    wire [5:0] total = sum4 + in[16]; // add last bit

    assign out = total;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Divide input into 15 groups of 17 bits (15 * 17 = 255)
    wire [5:0] partial_counts [14:0]; // each partial count max 17 => needs 6 bits

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Balanced adder tree summation of partial_counts to get final 8-bit output (max 255)
    // Level 1: sum pairs (7 pairs + 1 leftover)
    wire [7:0] sum_level1 [7:0];
    generate
        for (gi = 0; gi < 7; gi = gi + 1) begin : level1_sum
            assign sum_level1[gi] = {2'b00, partial_counts[2*gi]} + {2'b00, partial_counts[2*gi+1]};
        end
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs (4 sums)
    wire [7:0] sum_level2 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
        end
    endgenerate

    // Level 3: sum pairs (2 sums)
    wire [7:0] sum_level3 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
        end
    endgenerate

    // Level 4: final sum (1 sum)
    assign out = sum_level3[0] + sum_level3[1];

endmodule