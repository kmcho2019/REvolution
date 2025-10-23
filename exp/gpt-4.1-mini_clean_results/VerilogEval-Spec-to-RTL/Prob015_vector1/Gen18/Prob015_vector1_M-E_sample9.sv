module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Extract upper byte by right-shifting and masking with 8'hFF
    assign out_hi = (in >> 8) & 8'hFF;
    // Extract lower byte by masking with 8'hFF
    assign out_lo = in & 8'hFF;
endmodule