module popcount #(
    parameter WIDTH = 255
)(
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive adder tree to sum bits of 'in'

    // Base case: WIDTH = 1
    // Output is single bit input itself
    if (WIDTH == 1) begin
        assign out = in;
    end else begin
        localparam half = WIDTH/2;
        wire [$clog2(WIDTH+1)-1:0] sum_left;
        wire [$clog2(WIDTH+1)-1:0] sum_right;

        // For odd widths, right width is WIDTH - half
        localparam right_width = WIDTH - half;

        popcount #(.WIDTH(half)) left_popcount (
            .in(in[half-1:0]),
            .out(sum_left)
        );

        popcount #(.WIDTH(right_width)) right_popcount (
            .in(in[WIDTH-1:half]),
            .out(sum_right)
        );

        assign out = sum_left + sum_right;
    end
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Use the parameterized popcount for 255 bits directly
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule