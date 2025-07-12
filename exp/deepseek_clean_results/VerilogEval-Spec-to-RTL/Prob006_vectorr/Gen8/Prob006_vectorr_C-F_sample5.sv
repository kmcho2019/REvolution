/*
 * BitReverser - Parameterized bit reversal module with clear documentation
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

    // Generate reversed bits with clear ordering documentation
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reversal
            assign out[i] = in[WIDTH-1-i];  // MSB becomes LSB, etc.
        end
    endgenerate

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

    // Instantiate parameterized reverser with default width
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule