module TopModule (
    input  wire [254:0] in,
    output wire [7:0]  out
);

    // First stage: Count bits in 32 groups of 8 bits each, plus one group of 7 bits
    // We get 32 partial counts (for full 8-bit groups) + 1 partial count for the last 7 bits = 33 partial counts
    wire [3:0] partial_counts [32:0]; // 4 bits per partial count (max 8 for groups of 8 bits, max 7 for last group)

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : count_8bits
            // count bits in in[8*i +: 8]
            assign partial_counts[i] = in[8*i +: 8][0] +
                                       in[8*i +: 8][1] +
                                       in[8*i +: 8][2] +
                                       in[8*i +: 8][3] +
                                       in[8*i +: 8][4] +
                                       in[8*i +: 8][5] +
                                       in[8*i +: 8][6] +
                                       in[8*i +: 8][7];
        end
    endgenerate

    // Last group is 7 bits (bits 256 is out of range, so only bits [254: 8*32=256] -> bits 254:256 actually 254 down to 256 does not exist, so just bits [254:256] doesn't make sense.
    // The input is bits [254:0], so last group is bits [254: 8*32 = 256] which is bits 254 down to 256, which is invalid; so only bits [254: 256] does not exist.
    // Actually, 32*8 = 256 bits, but we only have 255 bits (0 to 254), so last group has only 255 - 32*8 = 255 - 256 = -1 bits?? Negative - means the last group is only 255 bits total.
    // Correction: Since 255 bits total, groups of 8 bits: 255 / 8 = 31 full groups + 7 bits remainder.
    // Actually, 31*8 = 248 bits, remainder 7 bits.
    // So groups: 31 groups of 8 bits (0 to 247), plus 1 group of 7 bits (248 to 254).

    // So fix the loop to 31 groups of 8 bits
    // Partial counts are 31 groups + 1 group of 7 bits = 32 partial counts total

endmodule

// Corrected code below with the above fixes:
module TopModule (
    input  wire [254:0] in,
    output wire [7:0]  out
);

    // First stage: Count bits in 31 groups of 8 bits each, plus one group of 7 bits
    wire [3:0] partial_counts [31:0]; // 4 bits per partial count (max 8 or 7)

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : count_8bits
            assign partial_counts[i] = in[8*i +: 8][0] +
                                       in[8*i +: 8][1] +
                                       in[8*i +: 8][2] +
                                       in[8*i +: 8][3] +
                                       in[8*i +: 8][4] +
                                       in[8*i +: 8][5] +
                                       in[8*i +: 8][6] +
                                       in[8*i +: 8][7];
        end
    endgenerate

    // Count bits in last 7 bits (bits 248 to 254)
    assign partial_counts[31] = in[254] +
                               in[253] +
                               in[252] +
                               in[251] +
                               in[250] +
                               in[249] +
                               in[248];

    // Second stage: Sum the 32 partial counts (each 4-bit) into the 8-bit final count
    // Use a balanced adder tree to sum 32 4-bit numbers

    // Level 1: sum pairs of partial counts -> 16 sums (5 bits each)
    wire [4:0] sum_level1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_l1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of sum_level1 -> 8 sums (6 bits each)
    wire [5:0] sum_level2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_l2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 -> 4 sums (7 bits each)
    wire [6:0] sum_level3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_l3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs of sum_level3 -> 2 sums (8 bits each)
    wire [7:0] sum_level4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_l4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: sum the two sums of level4 (max 8 bits + 8 bits = 9 bits max but output is 8 bits; max total count 255 fits in 8 bits, so this is safe)
    // To be safe, use 9 bits temporarily and truncate or assign 8 bits (max sum is 255)
    wire [8:0] sum_level5;
    assign sum_level5 = sum_level4[0] + sum_level4[1];

    assign out = sum_level5[7:0]; // since max count is 255, upper bit should be zero

endmodule