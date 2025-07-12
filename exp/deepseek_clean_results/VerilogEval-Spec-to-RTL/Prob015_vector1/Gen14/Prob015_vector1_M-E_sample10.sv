module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Shift-based implementation
    assign out_hi = (in >> 8);          // Right shift to get upper byte
    assign out_lo = in & 8'hFF;         // Mask to get lower byte

endmodule