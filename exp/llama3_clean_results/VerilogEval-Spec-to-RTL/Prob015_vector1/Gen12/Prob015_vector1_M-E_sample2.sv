module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use shift operator to extract the upper byte
    assign out_hi = in >> 8;

    // Use mask to extract the lower byte
    assign out_lo = in & 8'b11111111;

endmodule