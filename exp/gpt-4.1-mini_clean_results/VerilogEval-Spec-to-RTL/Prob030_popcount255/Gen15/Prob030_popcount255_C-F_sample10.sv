module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits (structural)
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
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad input MSB if WIDTH < 8
            wire [7:0] padded_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 u_popcount8 (
                .in(padded_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam integer half = WIDTH / 2;
            localparam integer right_width = WIDTH - half;

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

            // Sum partial counts, output sized to $clog2(WIDTH+1)
            assign out = left_sum + right_sum;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition 255 bits into 5 groups of 51 bits each
    // Each popcount_recursive(51) outputs 6 bits ($clog2(51+1) = 6)
    wire [5:0] partial_counts [4:0];

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : pc51_blocks
            popcount_recursive #(.WIDTH(51)) pc51 (
                .in(in[i*51 +: 51]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced adder tree to sum 5 partial counts (6 bits each)
    // sum pairs to 7 bits: max sum 2*51=102 fits in 7 bits
    wire [6:0] sum01 = partial_counts[0] + partial_counts[1];
    wire [6:0] sum23 = partial_counts[2] + partial_counts[3];
    // sum partial pairs: max sum ~204 fits in 8 bits
    wire [7:0] sum0123 = sum01 + sum23;
    // final sum: add last partial count (6 bits zero-extended to 8)
    // max sum 255 fits in 8 bits
    wire [7:0] sum_final = sum0123 + {2'b00, partial_counts[4]};

    assign out = sum_final;
endmodule