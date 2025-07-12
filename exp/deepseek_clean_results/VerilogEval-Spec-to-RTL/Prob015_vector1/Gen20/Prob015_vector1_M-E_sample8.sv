module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Mask for lower byte (0x00FF)
    wire [15:0] lo_mask = 16'h00FF;
    
    // Isolate lower byte using mask
    assign out_lo = in & lo_mask;
    
    // For upper byte: conceptually shift right by 8, but implement as slice
    assign out_hi = in[15:8];

    /* Alternative implementation showing the shift concept:
    assign out_hi = (in >> 8);
    */
    
endmodule