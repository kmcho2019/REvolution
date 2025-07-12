module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use bitwise shift to align bits for out_hi
    // Shift right by 8 bits to move the upper byte to the lower byte position
    assign out_hi = (in >> 8) & 8'hFF; // Mask with 8'hFF to get the lower 8 bits

    // Use bitwise AND with a mask to extract the lower byte for out_lo
    assign out_lo = in & 8'hFF; // Mask with 8'hFF to get the lower 8 bits

endmodule