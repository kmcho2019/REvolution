/*
 * BitReverser - Efficient parameterized bit reversal module
 * Features:
 * - Pure combinational logic for best PPA
 * - Direct bit assignment for optimal synthesis
 * - Parameterized width with default of 8 bits
 * - Clear documentation and naming
 *
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

    // Direct bit reversal assignment - optimal for synthesis
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

endmodule

/*
 * TopModule - 8-bit bit reversal wrapper
 * Maintains original interface while leveraging parameterized implementation
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate the parameterized reverser with default width
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule