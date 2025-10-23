/*
 * OptimizedBitReverser - Refactored version using continuous assignments
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module OptimizedBitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal using continuous assignments
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

endmodule

// TopModule maintains original 8-bit interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    OptimizedBitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule