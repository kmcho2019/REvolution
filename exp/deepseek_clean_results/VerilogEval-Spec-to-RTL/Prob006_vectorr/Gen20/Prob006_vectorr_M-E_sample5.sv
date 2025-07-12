/*
 * BitSliceReverser - Parallel bit-slice implementation of bit reversal
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitSliceReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : BIT_SLICE
        // Each processing element selects its bit in parallel
        assign out[i] = in[WIDTH-1-i];
    end
endgenerate

endmodule

// TopModule maintains original 8-bit interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitSliceReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule