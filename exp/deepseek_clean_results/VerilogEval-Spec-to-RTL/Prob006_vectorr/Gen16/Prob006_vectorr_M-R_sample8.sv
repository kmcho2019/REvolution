/*
 * TopModule - 8-bit bit reversal module
 * Now implemented with direct concatenation for bit reversal
 * More compact implementation while maintaining same functionality
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Reverse bits using concatenation
    assign out = {in[0], in[1], in[2], in[3], 
                 in[4], in[5], in[6], in[7]};

endmodule