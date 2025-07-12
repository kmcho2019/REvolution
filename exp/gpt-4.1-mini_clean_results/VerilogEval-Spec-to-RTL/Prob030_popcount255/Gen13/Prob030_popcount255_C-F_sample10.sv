// Structural popcount8: balanced adder tree for 8-bit inputs
module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Level 1: 4 sums of 2 bits each
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Level 2: 2 sums of 3 bits each (sum of two 2-bit numbers)
    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: final sum of two 3-bit numbers
    assign out = sum_l2[0] + sum_l2[1];
endmodule

// Recursive, parameterized popcount with popcount8 as base case
module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad to 8 bits if WIDTH < 8
            wire [7:0] padded_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 pc8 (
                .in(padded_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            wire [$clog2(half+1)-1:0] left_sum;
            wire [$clog2(right_width+1)-1:0] right_sum;

            popcount #(.WIDTH(half)) left_popcount (
                .in(in[half-1:0]),
                .out(left_sum)
            );

            popcount #(.WIDTH(right_width)) right_popcount (
                .in(in[WIDTH-1:half]),
                .out(right_sum)
            );

            // Sum the two partial counts (extend to output width for addition)
            assign out = left_sum + right_sum;
        end
    endgenerate
endmodule

// TopModule partitions input into 5 chunks of 51 bits,
// uses popcount recursively on each chunk,
// then sums the 5 partial counts with a balanced adder tree.
module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partial counts: each 51-bit chunk max sum fits in 6 bits (log2(52) = 6)
    wire [5:0] partial_counts [4:0];

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : pc51_blocks
            popcount #(.WIDTH(51)) pc51 (
                .in(in[i*51 +: 51]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced addition tree for 5 partial counts:
    // sum0_1 = partial_counts[0] + partial_counts[1] (6 bits + 6 bits => max 7 bits)
    wire [6:0] sum0_1 = partial_counts[0] + partial_counts[1];
    // sum2_3 = partial_counts[2] + partial_counts[3] (6 bits + 6 bits => max 7 bits)
    wire [6:0] sum2_3 = partial_counts[2] + partial_counts[3];
    // sum0_3 = sum0_1 + sum2_3 (7 bits + 7 bits => max 8 bits)
    wire [7:0] sum0_3 = sum0_1 + sum2_3;
    // final sum = sum0_3 + partial_counts[4] (8 bits + 6 bits => max 8 bits)
    wire [7:0] sum_final = sum0_3 + partial_counts[4];

    assign out = sum_final;
endmodule