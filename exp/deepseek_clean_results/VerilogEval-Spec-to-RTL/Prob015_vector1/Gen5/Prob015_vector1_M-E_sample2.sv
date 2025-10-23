module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    assign out_hi = in >> 8;          // Right shift by 8 to get upper byte
    assign out_lo = in & 8'hFF;       // Mask with 0x00FF to get lower byte

endmodule