module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones fit in 5 bits, using 6 bits for margin
);
    // First sum lower 16 bits in 8 pairs -> 8 sums of 2 bits each
    wire [1:0] sum_pairs [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pair_sum
            assign sum_pairs[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Sum pairs of sum_pairs: 4 sums, each 3 bits wide max (2+2 bits sum)
    wire [2:0] sum_quads [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : quad_sum
            assign sum_quads[i] = sum_pairs[2*i] + sum_pairs[2*i+1];
        end
    endgenerate

    // Sum pairs of quads: 2 sums, each up to 4 bits wide
    wire [3:0] sum_octets [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : octet_sum
            assign sum_octets[i] = sum_quads[2*i] + sum_quads[2*i+1];
        end
    endgenerate

    // Sum two octets plus leftover highest bit in one step (5 bits)
    assign out = sum_octets[0] + sum_octets[1] + in[16];

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Split input into 15 groups of 17 bits each
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

    // To reduce addition stages, sum partial_counts in groups of 3 where possible:
    // 15 inputs -> 5 sums of 3 partial_counts each
    wire [7:0] sum_3 [4:0];

    generate
        for (i = 0; i < 5; i = i + 1) begin : sum_triples
            assign sum_3[i] = partial_counts[3*i] + partial_counts[3*i + 1] + partial_counts[3*i + 2];
        end
    endgenerate

    // Now sum these 5 sums:
    // Sum first 4 in two pairs and one leftover:
    wire [7:0] sum_pair1 = sum_3[0] + sum_3[1]; // 8 bits max
    wire [7:0] sum_pair2 = sum_3[2] + sum_3[3]; // 8 bits max
    wire [7:0] leftover = sum_3[4];              // 8 bits max

    // Sum these three 8-bit values
    wire [8:0] final_sum = sum_pair1 + sum_pair2 + leftover; // 9 bits max (max 255)

    assign out = final_sum[7:0]; // output 8 bits; max count is 255 fits in 8 bits

endmodule