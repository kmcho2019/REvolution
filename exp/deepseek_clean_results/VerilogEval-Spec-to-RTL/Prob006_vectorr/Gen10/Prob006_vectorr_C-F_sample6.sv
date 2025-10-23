/*
 * TopModule - Bit Reversal Module
 * Reverses the bit order of an 8-bit input by default
 * Can be parameterized for other widths if needed
 * 
 * Ports:
 *   in  - 8-bit input vector
 *   out - 8-bit output with reversed bit order
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal mapping for optimal PPA
    // Explicit mapping ensures clarity and verification
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

endmodule