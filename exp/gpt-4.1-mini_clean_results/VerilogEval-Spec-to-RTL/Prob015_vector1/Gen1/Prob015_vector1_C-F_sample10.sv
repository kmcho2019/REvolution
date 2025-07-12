module TopModule(
    input  [15:0] in,       // 16-bit input half-word
    output [7:0]  out_hi,   // upper byte [15:8]
    output [7:0]  out_lo    // lower byte [7:0]
);

// Combinational assignment splitting input into two bytes
assign out_hi = in[15:8];
assign out_lo = in[7:0];

endmodule