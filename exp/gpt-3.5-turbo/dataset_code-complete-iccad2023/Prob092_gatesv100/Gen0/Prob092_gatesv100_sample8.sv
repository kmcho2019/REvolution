module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);
  
  // out_both: indicating whether both the corresponding input bit and its neighbor to the left are '1'
  assign out_both = in[99:1] & in[98:0];
  
  // out_any: indicating whether any of the corresponding input bit and its neighbor to the right are '1'
  assign out_any = {in[99], in[99:1] | in[98:0]};
  
  // out_different: indicating whether the corresponding input bit is different from its neighbor to the left
  assign out_different = in ^ {in[99], in[98:0]};

endmodule