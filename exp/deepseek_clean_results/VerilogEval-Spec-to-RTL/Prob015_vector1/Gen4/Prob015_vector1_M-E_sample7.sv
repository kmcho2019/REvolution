module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Upper byte via right shift
    assign out_hi = in >> 8;
    
    // Lower byte via bitmask
    assign out_lo = in & 8'hFF;

endmodule