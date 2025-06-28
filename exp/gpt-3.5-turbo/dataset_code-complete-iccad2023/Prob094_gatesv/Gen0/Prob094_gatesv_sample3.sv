module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);

  // out_both: output indicates whether both the corresponding input bit and its neighbour to the left are '1'
  assign out_both = {in[3] & in[0], in[0] & in[1], in[1] & in[2]};
  
  // out_any: output indicates whether any of the corresponding input bit and its neighbour to the right are '1'
  assign out_any = {in[1] | in[0], in[2] | in[1], in[3] | in[2], in[0] | in[3]};
  
  // out_different: output indicates whether the corresponding input bit is different from its neighbour to the left
  assign out_different = {in[0] ^ in[1], in[1] ^ in[2], in[2] ^ in[3], in[3] ^ in[0]};

endmodule