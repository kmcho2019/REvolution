module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // out_both: Check if each bit and its left neighbour are both 1
  assign out_both = in[99:1] & in[98:0];

  // out_any: Check if any bit or its right neighbour is 1
  assign out_any = in | {in[99], in[98:0]};

  // out_different: Check if each bit is different from its left neighbour
  assign out_different = in ^ {in[99], in[98:0]};

endmodule