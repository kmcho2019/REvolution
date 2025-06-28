module TopModule (
  input [15:0] in,
  output [7:0] out_hi,
  output [7:0] out_lo
);

assign out_hi = in >> 8;
assign out_lo = in & 8'b11111111;

endmodule