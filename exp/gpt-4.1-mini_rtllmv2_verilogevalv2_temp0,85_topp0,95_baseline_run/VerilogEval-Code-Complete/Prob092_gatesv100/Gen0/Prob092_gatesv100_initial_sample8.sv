module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);
  // (1) out_both: For bits 0 to 98, AND of in[i] and in[i+1]
  assign out_both = in[98:0] & in[99:1];

  // (2) out_any: For bits 1 to 99, OR of in[i] and in[i-1]
  assign out_any = in[99:1] | in[98:0];

  // (3) out_different: Each bit is XOR of in[i] and its left neighbor (wrap around)
  assign out_different = in ^ {in[0], in[99:1]};

endmodule