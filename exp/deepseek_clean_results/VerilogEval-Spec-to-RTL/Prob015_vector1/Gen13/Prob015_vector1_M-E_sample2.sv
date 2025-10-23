module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Upper byte: mask with 0xFF00 then right shift by 8
    assign out_hi = (in & 16'hFF00) >> 8;
    
    // Lower byte: mask with 0x00FF
    assign out_lo = in & 16'h00FF;

endmodule