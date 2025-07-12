module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Most efficient implementation - direct bit selection
    assign out_hi = in[15:8];  // Equivalent to: (in >> 8)
    assign out_lo = in[7:0];   // Equivalent to: (in & 8'hFF)

    /* Alternative conceptual implementations:
    // Shift-register style (synthesizes to same as above)
    assign out_hi = in >> 8;
    
    // Masking style (synthesizes to same as above)
    assign out_lo = in & 8'hFF;
    */

endmodule