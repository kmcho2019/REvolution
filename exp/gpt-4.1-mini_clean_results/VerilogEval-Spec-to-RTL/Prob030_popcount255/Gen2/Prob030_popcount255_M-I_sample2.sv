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
    // Divide 17 bits into four 4-bit groups and one 1-bit group
    wire [3:0] pc0, pc1, pc2, pc3;
    wire [5:0] sum_4groups; // sum of the 4 pc4 outputs
    wire [5:0] sum_total;

    // Four 4-bit popcounts
    popcount4 pc_0 (.in(in[3:0]),   .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),   .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),  .out(pc2));
    popcount4 pc_3 (.in(in[15:12]), .out(pc3));

    // Sum four 4-bit counts (max 4*4=16)
    wire [5:0] sum01 = pc0 + pc1; // up to 8
    wire [5:0] sum23 = pc2 + pc3; // up to 8
    wire [5:0] sum4   = sum01 + sum23; // up to 16

    // Add the last bit (in[16])
    assign sum_total = sum4 + in[16];

    assign out = sum_total;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts from popcount17

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

    // Level 1: sum pairs of partial_counts into 8-bit sums (7 pairs + 1 leftover)
    wire [7:0] sum_level1 [7:0];
    generate
        for (gi = 0; gi < 7; gi = gi + 1) begin : level1_sum
            assign sum_level1[gi] = {2'b00, partial_counts[2*gi]} + {2'b00, partial_counts[2*gi+1]};
        end
        // Pass last partial count as zero-extended to 8 bits
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 (8 inputs -> 4 outputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (4 inputs -> 2 outputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
        end
    endgenerate

    // Level 4: final sum of two outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule