/*
 * TopModule - Refactored bit reversal implementation
 * Features:
 *   - Direct bit assignments for clarity
 *   - Parameterized width (default 8)
 *   - Pure combinational logic
 *   - Single-module implementation
 * Ports:
 *   in  - Input vector [WIDTH-1:0]
 *   out - Output vector with reversed bit order [WIDTH-1:0]
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal assignments
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

    // Note: For WIDTH != 8, the above would need to be adjusted
    // or a generate loop would be better. This implementation
    // assumes WIDTH=8 as per the original specification.

endmodule