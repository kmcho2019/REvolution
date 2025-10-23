module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Using explicit bit selection for clarity
    assign out_hi = in[15 -: 8];  // Equivalent to in[15:8]
    assign out_lo = in[7 -: 8];   // Equivalent to in[7:0]

endmodule