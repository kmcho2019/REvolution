module TopModule(
    input  [15:0] in,     // 16-bit input
    output [7:0] out_hi,  // upper 8 bits of the input
    output [7:0] out_lo   // lower 8 bits of the input
);

assign out_lo = in[7:0];  // assign lower 8 bits to out_lo
assign out_hi = in[15:8]; // assign upper 8 bits to out_hi

endmodule