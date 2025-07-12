module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    assign out_hi = in[15:8];  // Direct part-select for upper byte
    assign out_lo = in[7:0];   // Direct part-select for lower byte

endmodule