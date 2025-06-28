module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  assign out_both = in[99:1] & in[98:0]; // AND operation between shifted input vector and original input vector
  assign out_any = in | {1'b0, in[99:1]}; // OR operation between input vector and shifted input vector
  assign out_different = in ^ {in[99], in[98:0]}; // XOR operation between input vector and shifted input vector

endmodule