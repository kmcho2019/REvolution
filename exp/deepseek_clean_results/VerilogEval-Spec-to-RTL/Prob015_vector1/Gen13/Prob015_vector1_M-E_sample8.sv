module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Upper byte: shift right then mask
    assign out_hi = (in >> 8) & 8'hFF;
    
    // Lower byte: direct masking
    assign out_lo = in & 8'hFF;

endmodule