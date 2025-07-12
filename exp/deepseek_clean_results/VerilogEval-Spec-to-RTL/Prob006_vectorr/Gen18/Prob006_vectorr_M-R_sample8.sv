/*
 * BitReverser - Parameterized bit reversal module
 * Now implemented with direct concatenation for simplicity
 * Features:
 *   - Pure combinational logic
 *   - Concatenation-based implementation
 *   - Parameterized width (default 8)
 *   - Clear and concise implementation
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
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule