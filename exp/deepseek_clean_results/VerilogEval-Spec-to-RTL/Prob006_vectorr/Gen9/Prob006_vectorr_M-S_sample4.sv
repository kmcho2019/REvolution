/*
 * TopModule - Simple 8-bit bit reversal module
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
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

endmodule