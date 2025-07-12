module popcount_recursive #(
    parameter WIDTH = 17
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive population count:
    // Base case WIDTH=1: output = input bit
    // Otherwise, split input into halves (floor/ceil if odd),
    // recursively popcount each half, then sum results.

    generate
        if (WIDTH == 1) begin
            assign out = in[0];
        end else begin
            localparam HALF_L = WIDTH/2;            // floor(WIDTH/2)
            localparam HALF_R = WIDTH - HALF_L;     // ceiling if odd

            wire [$clog2(HALF_L+1)-1:0] pop_left;
            wire [$clog2(HALF_R+1)-1:0] pop_right;

            popcount_recursive #(.WIDTH(HALF_L)) left_pop (
                .in(in[HALF_L-1:0]),
                .out(pop_left)
            );
            popcount_recursive #(.WIDTH(HALF_R)) right_pop (
                .in(in[WIDTH-1:HALF_L]),
                .out(pop_right)
            );

            // Sum results, output width enough for WIDTH ones max:
            localparam OUT_WIDTH = $clog2(WIDTH+1);
            wire [OUT_WIDTH-1:0] pop_left_ext = {{(OUT_WIDTH-$clog2(HALF_L+1)){1'b0}}, pop_left};
            wire [OUT_WIDTH-1:0] pop_right_ext = {{(OUT_WIDTH-$clog2(HALF_R+1)){1'b0}}, pop_right};
            assign out = pop_left_ext + pop_right_ext;
        end
    endgenerate
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 15 blocks of 17 bits each (15*17=255)
    // Each popcount_recursive outputs 5 bits (max count 17 => 5 bits)
    wire [4:0] partial_counts [14:0];

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount_recursive #(.WIDTH(17)) pc_inst (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Balanced adder tree to sum partial_counts[14:0] (15 x 5-bit numbers)

    // Level 1: sum pairs of 5-bit partial_counts -> 6 bits sums (7 sums) + 1 leftover
    wire [5:0] sum_level1 [7:0];
    generate
        for (gi = 0; gi < 7; gi = gi + 1) begin : level1_sum
            assign sum_level1[gi] = partial_counts[2*gi] + partial_counts[2*gi+1];
        end
        // Last one zero-extend partial_counts[14] to 6 bits
        assign sum_level1[7] = {1'b0, partial_counts[14]};
    endgenerate

    // Level 2: sum pairs of 6-bit sums -> 7-bit sums (4 sums)
    wire [6:0] sum_level2 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
        end
    endgenerate

    // Level 3: sum pairs of 7-bit sums -> 8-bit sums (2 sums)
    wire [7:0] sum_level3 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
        end
    endgenerate

    // Level 4: final sum of two 8-bit sums -> max count 255 fits in 8 bits
    assign out = sum_level3[0] + sum_level3[1];
endmodule