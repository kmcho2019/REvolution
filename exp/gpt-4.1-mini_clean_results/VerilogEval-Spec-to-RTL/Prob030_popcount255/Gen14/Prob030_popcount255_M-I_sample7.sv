module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Efficient popcount for 8 bits using parallel reduction:
    // sum = sum of bits in 'in' (0 to 8)
    // Using balanced adder tree of partial sums by pairs

    wire [3:0] pair_sum; // sum of bits in pairs (0-2)

    // Sum each pair of bits
    assign pair_sum[0] = in[0] + in[1];
    assign pair_sum[1] = in[2] + in[3];
    assign pair_sum[2] = in[4] + in[5];
    assign pair_sum[3] = in[6] + in[7];

    wire [4:0] sum_level2_0, sum_level2_1;

    // Sum pairs of pair sums
    assign sum_level2_0 = pair_sum[0] + pair_sum[1]; // max 4
    assign sum_level2_1 = pair_sum[2] + pair_sum[3]; // max 4

    // Final sum (max 8)
    assign out = sum_level2_0 + sum_level2_1;

endmodule

module popcount #(
    parameter integer WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Compute the output width once for clarity
    localparam integer OUT_WIDTH = $clog2(WIDTH + 1);

    generate
        if (WIDTH <= 8) begin : base_case
            // Mask input to WIDTH bits (if WIDTH < 8), zero pad upper bits implicitly by zero extension
            wire [7:0] masked_in = {8{1'b0}} | { {(8-WIDTH){1'b0}}, in };
            // Alternative: explicitly mask upper bits to zero, but since in is WIDTH bits, zero-padded automatically

            // Use popcount8 to count bits in input (<=8 bits)
            popcount8 pc8_inst (
                .in(masked_in),
                .out(out)
            );
        end else begin : recursive_case
            // Split the input into two parts approximately in half
            localparam integer HALF = WIDTH / 2;
            localparam integer RIGHT_WIDTH = WIDTH - HALF;

            // Output widths of submodules
            localparam integer LEFT_OUT_WIDTH = $clog2(HALF + 1);
            localparam integer RIGHT_OUT_WIDTH = $clog2(RIGHT_WIDTH + 1);

            wire [LEFT_OUT_WIDTH-1:0] left_sum;
            wire [RIGHT_OUT_WIDTH-1:0] right_sum;

            popcount #(.WIDTH(HALF)) left_pc (
                .in(in[HALF-1:0]),
                .out(left_sum)
            );

            popcount #(.WIDTH(RIGHT_WIDTH)) right_pc (
                .in(in[WIDTH-1:HALF]),
                .out(right_sum)
            );

            // Zero-extend partial sums to OUT_WIDTH before addition to avoid width mismatch
            wire [OUT_WIDTH-1:0] left_sum_ext = {{(OUT_WIDTH-LEFT_OUT_WIDTH){1'b0}}, left_sum};
            wire [OUT_WIDTH-1:0] right_sum_ext = {{(OUT_WIDTH-RIGHT_OUT_WIDTH){1'b0}}, right_sum};

            assign out = left_sum_ext + right_sum_ext;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate the recursive popcount for 255 bits
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule