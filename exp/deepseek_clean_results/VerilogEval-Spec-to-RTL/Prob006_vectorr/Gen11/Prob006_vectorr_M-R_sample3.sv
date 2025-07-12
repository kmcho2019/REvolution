/*
 * BitReverser - Parameterized bit reversal module using concatenation
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 * Features:
 *   - Parameterized width for flexibility
 *   - Single assignment statement for cleaner code
 *   - Direct bit reversal using concatenation
 *   - Same clean hierarchical structure
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal using concatenation
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate parameterized bit reverser with WIDTH=8
    BitReverser #(.WIDTH(8)) reverser (
        .in(in),
        .out(out)
    );

endmodule