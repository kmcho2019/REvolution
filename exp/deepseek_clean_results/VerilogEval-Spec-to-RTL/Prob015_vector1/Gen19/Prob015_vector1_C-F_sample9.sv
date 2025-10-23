module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Direct bit-slicing for optimal PPA
    // Upper byte (bits 15-8)
    assign out_hi = in[15:8];
    // Lower byte (bits 7-0)
    assign out_lo = in[7:0];

    /* Parameterized version (commented out as not required by spec)
    parameter SPLIT_POS = 8;
    assign out_hi = in[15:SPLIT_POS];
    assign out_lo = in[SPLIT_POS-1:0];
    */

endmodule