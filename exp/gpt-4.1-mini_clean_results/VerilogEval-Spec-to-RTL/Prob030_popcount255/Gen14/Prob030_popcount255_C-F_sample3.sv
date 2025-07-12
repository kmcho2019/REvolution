module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount_recursive #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive balanced popcount with popcount8 base case
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad input MSBs if WIDTH < 8
            wire [7:0] base_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 u_popcount8 (
                .in(base_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            wire [$clog2(half+1)-1:0] left_sum;
            wire [$clog2(right_width+1)-1:0] right_sum;

            popcount_recursive #(.WIDTH(half)) left_popcount (
                .in(in[half-1:0]),
                .out(left_sum)
            );

            popcount_recursive #(.WIDTH(right_width)) right_popcount (
                .in(in[WIDTH-1:half]),
                .out(right_sum)
            );

            // Sum left and right sums, sized to output width
            assign out = left_sum + right_sum;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition 255 bits into 5 groups of 51 bits each
    wire [5:0] partial_counts [4:0]; // 6 bits each (max 51 ones fit in 6 bits)

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : pc51_blocks
            popcount_recursive #(.WIDTH(51)) pc51 (
                .in(in[i*51 +: 51]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced 3-stage adder tree to sum partial counts:
    // sum pairs to 7 bits, then add resulting sums and last partial count to 8 bits
    wire [7:0] sum01 = partial_counts[0] + partial_counts[1];
    wire [7:0] sum23 = partial_counts[2] + partial_counts[3];
    wire [7:0] sum0123 = sum01 + sum23;
    wire [7:0] sum_final = sum0123 + partial_counts[4];

    assign out = sum_final;
endmodule