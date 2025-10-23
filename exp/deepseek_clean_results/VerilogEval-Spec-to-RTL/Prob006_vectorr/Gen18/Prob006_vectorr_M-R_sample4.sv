/*
 * TopModule - 8-bit bit reversal module
 * Implemented with direct continuous assignments
 * Features:
 *   - Pure combinational logic
 *   - Explicit bit assignments
 *   - Fixed 8-bit width as specified
 *   - Clear documentation of bit mapping
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

    /* Bit mapping documentation:
     * out[0] = in[7]
     * out[1] = in[6]
     * out[2] = in[5]
     * out[3] = in[4]
     * out[4] = in[3]
     * out[5] = in[2]
     * out[6] = in[1]
     * out[7] = in[0]
     */

endmodule