module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Lower byte: mask with 0xFF (8'b11111111)
    assign out_lo = in & 8'hFF;
    
    // Upper byte: right-shift by 8 then mask
    assign out_hi = (in >> 8) & 8'hFF;

endmodule