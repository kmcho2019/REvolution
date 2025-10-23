module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => 5 bits needed, 6 bits for margin
);
    // Popcount 4-bit groups by explicit sum
    wire [2:0] sum0, sum1, sum2, sum3; // 3 bits to represent counts 0..4
    wire        sum4;                  // single bit

    // Explicit popcount4: sum of 4 bits into 3 bits
    function [2:0] popcount4;
        input [3:0] bits;
        begin
            popcount4 = bits[0] + bits[1] + bits[2] + bits[3];
        end
    endfunction

    assign sum0 = popcount4(in[3:0]);
    assign sum1 = popcount4(in[7:4]);
    assign sum2 = popcount4(in[11:8]);
    assign sum3 = popcount4(in[15:12]);
    assign sum4 = in[16]; // single leftover bit

    // Sum pairs: 3-bit + 3-bit = max 8 (needs 4 bits)
    wire [3:0] sum01 = sum0 + sum1;
    wire [3:0] sum23 = sum2 + sum3;

    // Sum sum01 + sum23 (4-bit + 4-bit = max 16, needs 5 bits)
    wire [4:0] sum0123 = sum01 + sum23;

    // Final sum: sum0123 (5 bits) + sum4 (1 bit) = max 17, needs 6 bits
    assign out = sum0123 + sum4;

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Break input into 15 blocks of 17 bits each
    wire [5:0] partial_counts [14:0];

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum the 15 partial counts (max 15*17=255) into 8-bit output using a balanced adder tree
    // Use generate loops for clarity

    // Level 1: sum pairs of partial_counts
    wire [7:0] sum_level1 [7:0];
    generate
        for (gi = 0; gi < 7; gi = gi + 1) begin : level1_sum
            assign sum_level1[gi] = {2'b00, partial_counts[2*gi]} + {2'b00, partial_counts[2*gi+1]};
        end
        // Last element passes through zero-extended to 8 bits
        assign sum_level1[7] = {2'b00, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of sum_level1 (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
        end
    endgenerate

    // Level 4: sum final two outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule