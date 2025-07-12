module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    assign out_hi = in[15:8];  // Explicit upper byte
    assign out_lo = in[7:0];   // Explicit lower byte

endmodule