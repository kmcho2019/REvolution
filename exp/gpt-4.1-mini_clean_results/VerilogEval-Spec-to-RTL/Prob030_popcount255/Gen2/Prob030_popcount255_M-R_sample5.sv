module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones fits in 5 bits, use 6 for margin
);
    // Split into groups:
    // sum0: bits [3:0] (4 bits)
    // sum1: bits [7:4] (4 bits)
    // sum2: bits [11:8] (4 bits)
    // sum3: bits [15:12] (4 bits)
    // sum4: bits [16]   (1 bit)

    wire [2:0] sum0, sum1, sum2, sum3; // 4 bits can be summed into 3 bits max (4 ones max)
    wire [3:0] sum01, sum23;            // sums of pairs
    wire [4:0] sum0123;                 // sum of four groups
    wire [5:0] total;

    // Function to popcount 4 bits explicitly
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

    assign sum4 = in[16]; // single bit

    // Sum pairs (3 bits + 3 bits = max 6)
    assign sum01 = sum0 + sum1; // 3-bit + 3-bit = 4 bits needed (max 8)
    assign sum23 = sum2 + sum3; // same

    // Sum sum01 and sum23 (4-bit + 4-bit = 5 bits)
    assign sum0123 = sum01 + sum23;

    // Final total sum: sum0123 + sum4 (5-bit + 1-bit = 6 bits)
    assign total = sum0123 + sum4;

    assign out = total;

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // 15 groups of 17 bits each
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

    // Sum partial_counts explicitly as balanced tree
    // Level 1: sum pairs (6-bit + 6-bit = max 17+17=34, fits in 6 bits? No, need 7 bits)
    // Use 8 bits for sums to be safe
    wire [7:0] sum_level1 [7:0];

    assign sum_level1[0] = partial_counts[0] + partial_counts[1];
    assign sum_level1[1] = partial_counts[2] + partial_counts[3];
    assign sum_level1[2] = partial_counts[4] + partial_counts[5];
    assign sum_level1[3] = partial_counts[6] + partial_counts[7];
    assign sum_level1[4] = partial_counts[8] + partial_counts[9];
    assign sum_level1[5] = partial_counts[10] + partial_counts[11];
    assign sum_level1[6] = partial_counts[12] + partial_counts[13];
    assign sum_level1[7] = partial_counts[14]; // single, zero-extended

    // Level 2: sum pairs of sum_level1 (8 bits each)
    wire [7:0] sum_level2 [3:0];

    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];
    assign sum_level2[2] = sum_level1[4] + sum_level1[5];
    assign sum_level2[3] = sum_level1[6] + sum_level1[7];

    // Level 3: sum pairs of sum_level2 (4 inputs)
    wire [7:0] sum_level3 [1:0];

    assign sum_level3[0] = sum_level2[0] + sum_level2[1];
    assign sum_level3[1] = sum_level2[2] + sum_level2[3];

    // Level 4: sum final two outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule