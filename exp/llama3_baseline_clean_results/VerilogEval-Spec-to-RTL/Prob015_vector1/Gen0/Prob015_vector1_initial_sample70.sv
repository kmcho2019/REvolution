module TopModule(
    input  [15:0] in,    // 16-bit input
    output [7:0] out_hi, // 8-bit output for upper byte
    output [7:0] out_lo  // 8-bit output for lower byte
);

// Assign lower 8 bits of input to out_lo
assign out_lo = in[7:0];

// Assign upper 8 bits of input to out_hi
assign out_hi = in[15:8];

endmodule