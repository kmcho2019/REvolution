/*
 * TopModule - Reverses bit order of 8-bit input
 * Pure combinational logic
 * Ports:
 *   in  - 8-bit input [7:0]
 *   out - 8-bit reversed output [7:0]
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Direct bit reversal assignment
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule