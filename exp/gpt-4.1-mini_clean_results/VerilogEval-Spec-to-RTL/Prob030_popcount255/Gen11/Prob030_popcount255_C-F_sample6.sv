`timescale 1ns / 1ps

module popcount16 (
    input  [15:0] in,
    output [4:0]  out
);
    // Recursive balanced popcount for 16 bits using built-in reduction and adders
    // Base units: popcount of 1,2,3 bits handled by direct sum

    // sum bits in pairs
    wire [7:0] sum2; // 8 pairs of 2 bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pair_sum
            assign sum2[i] = in[2*i] + in[2*i + 1];
        end
    endgenerate

    // sum adjacent pairs (4 bits)
    wire [3:0] sum4;
    generate
        for (i = 0; i < 4; i = i + 1) begin : double_pair_sum
            assign sum4[i] = sum2[2*i] + sum2[2*i + 1];
        end
    endgenerate

    // sum 8-bit halves (8 bits total from sum4)
    wire [2:0] sum8_low = sum4[1] + sum4[0];  // max 6 bits, fits in 3 bits
    wire [2:0] sum8_high = sum4[3] + sum4[2]; // max 6 bits, fits in 3 bits

    wire [4:0] total_sum = sum8_low + sum8_high; // max 16 (all ones) fits in 5 bits

    assign out = total_sum;
endmodule

module popcount16_uniform (
    input [15:0] in,
    output [4:0] out
);
    // Use the popcount16 module directly
    popcount16 pc16 (.in(in), .out(out));
endmodule

module balanced_adder_tree #(
    parameter IN_WIDTH = 5,  // width of each input partial sum
    parameter IN_COUNT = 17  // number of inputs to sum (must be > 0)
) (
    input  [IN_WIDTH-1:0] in_sums [0:IN_COUNT-1],
    output [$clog2(IN_COUNT*(1<<(IN_WIDTH))-IN_COUNT+1)-1:0] out_sum
);
    // This module sums IN_COUNT inputs each IN_WIDTH bits wide using a balanced binary tree.
    // The output width is enough to hold sum of all max values.

    // Recursive balanced tree:
    // Base case: if IN_COUNT == 1, output is input[0]
    // Else split inputs roughly in half and sum results

    // Calculate output width:
    localparam OUT_WIDTH = $clog2(IN_COUNT*( (1 << IN_WIDTH) - 1) + 1);

    // Using generate recursion for balanced sum
    generate
        if (IN_COUNT == 1) begin : base
            assign out_sum = in_sums[0];
        end else begin : recursive
            localparam HALF1 = IN_COUNT/2;
            localparam HALF2 = IN_COUNT - HALF1;

            wire [OUT_WIDTH-1:0] sum_left;
            wire [OUT_WIDTH-1:0] sum_right;

            balanced_adder_tree #(
                .IN_WIDTH(IN_WIDTH),
                .IN_COUNT(HALF1)
            ) left_sum (
                .in_sums(in_sums[0 +: HALF1]),
                .out_sum(sum_left)
            );

            balanced_adder_tree #(
                .IN_WIDTH(IN_WIDTH),
                .IN_COUNT(HALF2)
            ) right_sum (
                .in_sums(in_sums[HALF1 +: HALF2]),
                .out_sum(sum_right)
            );

            assign out_sum = sum_left + sum_right;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 17 chunks of 16 bits each:
    // Last chunk is bits [254: (16*16) = 256], so bits [254:256] are less than 16 bits; pad zeros.
    // Because 17*16=272 bits > 255, last chunk padded with zeros

    localparam CHUNK_SIZE = 16;
    localparam CHUNK_COUNT = 17; // 16 chunks full + 1 last padded chunk

    // Declare 17 chunks 16-bit each
    wire [15:0] chunks [0:CHUNK_COUNT-1];

    genvar idx;
    generate
        for (idx = 0; idx < CHUNK_COUNT-1; idx = idx + 1) begin : chunk_assign
            assign chunks[idx] = in[(idx*CHUNK_SIZE) +: CHUNK_SIZE];
        end

        // last chunk: bits 256 to 255+16-1=270 would be out of range, so pad zeros:
        // in bits 256+: none, so fill zeros except bits [254:256], last 1 bits of input
        // Actually bits [256:271) do not exist, so pad zeros
        // last chunk consists of bits [256:271] padded, so bits [255:256] + zeros,
        // but input is only 255 bits, so last chunk is {zeros[15:1], in[254]} zero-padded.

        // For last chunk:
        wire [15:0] last_chunk_tmp;
        assign last_chunk_tmp = {15'b0, in[254]};
        assign chunks[CHUNK_COUNT-1] = last_chunk_tmp;
    endgenerate

    // Compute popcount per chunk (each 16 bits -> 5 bits popcount)
    wire [4:0] partial_counts [0:CHUNK_COUNT-1];

    generate
        for (idx = 0; idx < CHUNK_COUNT; idx = idx + 1) begin : popcounts
            popcount16_uniform pc (
                .in(chunks[idx]),
                .out(partial_counts[idx])
            );
        end
    endgenerate

    // Sum all partial_counts using balanced_adder_tree
    // Inputs: 17 partial counts of 5 bits each
    // Output width: ceil(log2(17 * 16)) = ceil(log2(272))=9 bits

    wire [8:0] total_popcount;

    balanced_adder_tree #(
        .IN_WIDTH(5),
        .IN_COUNT(CHUNK_COUNT)
    ) sum_tree (
        .in_sums(partial_counts),
        .out_sum(total_popcount)
    );

    // Output is 8 bits as max count is 255, ignore highest bit (max 255 fits in 8 bits)
    assign out = total_popcount[7:0];
endmodule