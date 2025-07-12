module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Bitwise operations to split the input word
    assign out_hi = (in >> 8) & 8'hFF; // Shift right by 8 and mask with 0xFF
    assign out_lo = in & 8'hFF; // Mask with 0xFF to get the lower byte

endmodule