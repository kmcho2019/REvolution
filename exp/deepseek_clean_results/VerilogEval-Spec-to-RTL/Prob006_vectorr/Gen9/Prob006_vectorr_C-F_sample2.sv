/*
 * BitReverser - Parameterized bit reversal module
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal assignment (more optimal than generate for fixed widths)
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule

/*
 * TopModule - 8-bit bit reversal wrapper
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate specialized 8-bit reverser
    BitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule