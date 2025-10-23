module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_hi = in >> 8; // Shift right by 8 bits to get the upper byte
    assign out_lo = in & 8'hFF; // Use bitwise AND with a mask to get the lower byte

endmodule