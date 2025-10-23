module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Number of 8-bit chunks (31 full + 1 partial 7-bit chunk)
    localparam CHUNKS = 32;

    // Wire array for partial popcounts: 4 bits each for max count 8
    wire [3:0] partial_popcount [CHUNKS-1:0];

    genvar gi;

    // Inline 8-bit popcount logic using balanced sums for each chunk
    generate
        for (gi = 0; gi < 31; gi = gi + 1) begin : pc8_chunks
            wire [7:0] chunk = in[gi*8 +: 8];

            // Level 1: sum pairs of bits (4 sums, 2 bits each)
            wire [1:0] sum_l1 [3:0];
            assign sum_l1[0] = chunk[0] + chunk[1];
            assign sum_l1[1] = chunk[2] + chunk[3];
            assign sum_l1[2] = chunk[4] + chunk[5];
            assign sum_l1[3] = chunk[6] + chunk[7];

            // Level 2: sum pairs of 2-bit values (2 sums)
            wire [2:0] sum_l2 [1:0];
            assign sum_l2[0] = sum_l1[0] + sum_l1[1];
            assign sum_l2[1] = sum_l1[2] + sum_l1[3];

            // Level 3: final sum of two 3-bit values (1 sum)
            assign partial_popcount[gi] = sum_l2[0] + sum_l2[1];
        end
    endgenerate

    // Last chunk: 7 bits padded with zero at MSB
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    // Level 1 sums for last chunk
    wire [1:0] last_sum_l1 [3:0];
    assign last_sum_l1[0] = last_chunk[0] + last_chunk[1];
    assign last_sum_l1[1] = last_chunk[2] + last_chunk[3];
    assign last_sum_l1[2] = last_chunk[4] + last_chunk[5];
    assign last_sum_l1[3] = last_chunk[6] + last_chunk[7];
    // Level 2 sums
    wire [2:0] last_sum_l2 [1:0];
    assign last_sum_l2[0] = last_sum_l1[0] + last_sum_l1[1];
    assign last_sum_l2[1] = last_sum_l1[2] + last_sum_l1[3];
    // Level 3 sum
    assign partial_popcount[31] = last_sum_l2[0] + last_sum_l2[1];

    // Balanced adder tree summation of 32 partial counts
    // Level 1: sum pairs of 4-bit values -> 5-bit outputs
    wire [4:0] sum_l1 [15:0];
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : sum_level1
            assign sum_l1[gi] = partial_popcount[2*gi] + partial_popcount[2*gi + 1];
        end
    endgenerate

    // Level 2: sum pairs of 5-bit values -> 6-bit outputs
    wire [5:0] sum_l2 [7:0];
    generate
        for (gi = 0; gi < 8; gi = gi + 1) begin : sum_level2
            assign sum_l2[gi] = sum_l1[2*gi] + sum_l1[2*gi + 1];
        end
    endgenerate

    // Level 3: sum pairs of 6-bit values -> 7-bit outputs
    wire [6:0] sum_l3 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : sum_level3
            assign sum_l3[gi] = sum_l2[2*gi] + sum_l2[2*gi + 1];
        end
    endgenerate

    // Level 4: sum pairs of 7-bit values -> 8-bit outputs
    wire [7:0] sum_l4 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : sum_level4
            assign sum_l4[gi] = sum_l3[2*gi] + sum_l3[2*gi + 1];
        end
    endgenerate

    // Level 5: final sum of two 8-bit values -> 8-bit output
    assign out = sum_l4[0] + sum_l4[1];

endmodule