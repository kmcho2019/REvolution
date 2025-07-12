/*
 * TopModule - 8-bit bit reversal
 * Simple combinational implementation that reverses input bit order
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit output with reversed bit order
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Direct bit reversal using concatenation
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule