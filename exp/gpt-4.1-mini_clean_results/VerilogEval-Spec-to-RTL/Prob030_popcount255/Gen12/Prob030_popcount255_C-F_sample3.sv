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

module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad MSBs if WIDTH < 8 for popcount8 input
            wire [7:0] base_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 u_popcount8 (
                .in(base_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            // Declare wires with appropriate widths for partial sums
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

            // Extend left_sum and right_sum to output width before adding
            // to avoid width mismatch warning and ensure correct sum
            wire [$clog2(WIDTH+1)-1:0] left_sum_ext = {{($clog2(WIDTH+1)-$clog2(half+1)){1'b0}}, left_sum};
            wire [$clog2(WIDTH+1)-1:0] right_sum_ext = {{($clog2(WIDTH+1)-$clog2(right_width+1)){1'b0}}, right_sum};

            assign out = left_sum_ext + right_sum_ext;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate recursive popcount for WIDTH=255 directly
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule