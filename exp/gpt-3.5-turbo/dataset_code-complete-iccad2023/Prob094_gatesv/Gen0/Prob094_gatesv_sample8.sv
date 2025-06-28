module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);

  // out_both: Indicator for both input bit and its left neighbour being '1'
  assign out_both[0] = in[1] & in[0];
  assign out_both[1] = in[2] & in[1];
  assign out_both[2] = in[3] & in[2];

  // out_any: Indicator for any input bit or its right neighbour being '1'
  assign out_any[1] = in[1] | in[2];
  assign out_any[2] = in[2] | in[3];
  assign out_any[3] = in[3];

  // out_different: Indicator for input bit being different from its left neighbour
  assign out_different[0] = in[0] ^ in[1];
  assign out_different[1] = in[1] ^ in[2];
  assign out_different[2] = in[2] ^ in[3];
  assign out_different[3] = in[3] ^ in[0];

endmodule