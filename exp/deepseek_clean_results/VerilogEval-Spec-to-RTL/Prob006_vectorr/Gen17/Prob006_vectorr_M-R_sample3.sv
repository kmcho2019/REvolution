/*
 * TopModule - Bit order reversal module (8-bit)
 * Description: Reverses the bit order of 8-bit input
 * Implementation: Uses direct bit mapping via concatenation
 * Features:
 *   - Pure combinational logic
 *   - Single assignment statement
 *   - Explicit bit mapping
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Direct bit reversal mapping
    assign out = {in[0], in[1], in[2], in[3], 
                  in[4], in[5], in[6], in[7]};

endmodule