/*
 * BitReverser - Parameterized bit reversal module
 * Features:
 *   - Pure combinational logic for optimal timing
 *   - Parameterized width for flexibility
 *   - Systematic bit ordering for readability
 *   - Clear documentation
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector [WIDTH-1:0]
 *   out - Output vector with reversed bit order [WIDTH-1:0]
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal assignment
    // This creates the most efficient combinational logic
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reversal
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

endmodule

/*
 * TopModule - Maintains original 8-bit interface
 * Uses the parameterized BitReverser internally
 * Ports:
 *   in  - 8-bit input [7:0]
 *   out - 8-bit reversed output [7:0]
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate the parameterized bit reverser
    // Explicitly set width to 8 for clarity
    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule