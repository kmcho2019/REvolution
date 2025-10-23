/*
 * TopModule - Direct 8-bit bit reversal implementation
 * Features:
 *   - Pure combinational logic
 *   - Single assignment using concatenation
 *   - Optimized for 8-bit width
 *   - No sub-module hierarchy
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Bit reversal using concatenation
    assign out = {in[0], in[1], in[2], in[3], 
                  in[4], in[5], in[6], in[7]};

endmodule