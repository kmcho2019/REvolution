module TopModule (
    input  [15:0] in,         // 16-bit input word
    output [7:0]  out_hi,     // Upper byte (bits [15:8])
    output [7:0]  out_lo      // Lower byte (bits [7:0])
);

    // Configuration parameter (currently unused, available for future extensions)
    parameter ENABLE_FEATURES = 0;

    // Direct bit slicing - most efficient implementation
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

    /* Future extension possibilities:
     * - Bit reversal when ENABLE_FEATURES[0] set
     * - Byte swapping when ENABLE_FEATURES[1] set
     * - Other transformations using additional parameter bits
     */

endmodule