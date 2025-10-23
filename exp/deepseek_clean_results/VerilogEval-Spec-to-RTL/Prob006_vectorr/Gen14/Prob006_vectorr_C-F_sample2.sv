/*
 * BitReverser - Optimized parameterized bit reversal module
 * Combines direct bit mapping clarity with parameterized flexibility
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector to reverse
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Generate loop with explicit bit mapping documentation
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : BIT_REV
            // Map bit i to bit (WIDTH-1-i) - clearly shows reversal pattern
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Provides clean interface while allowing internal parameterization
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate parameterized reverser with default width
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule