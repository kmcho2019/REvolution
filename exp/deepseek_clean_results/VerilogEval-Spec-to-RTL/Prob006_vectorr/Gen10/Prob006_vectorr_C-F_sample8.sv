/*
 * BitReverser - Optimal parameterized bit reversal module
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 * Features:
 *   - Parameterized width for flexibility
 *   - Generate loop for scalability
 *   - Direct bit assignments for optimal PPA
 *   - Clean hierarchical structure
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit assignments in generate loop for optimal PPA
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reversal
            assign out[i] = in[WIDTH-1-i];  // Direct connection for each bit
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

    // Instantiate parameterized bit reverser with WIDTH=8
    BitReverser #(.WIDTH(8)) reverser (
        .in(in),
        .out(out)
    );

endmodule