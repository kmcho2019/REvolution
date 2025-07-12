module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Get upper byte by right shifting by 8 bits
    assign out_hi = in >> 8;
    
    // Get lower byte by masking with 0xFF
    assign out_lo = in & 8'hFF;

endmodule