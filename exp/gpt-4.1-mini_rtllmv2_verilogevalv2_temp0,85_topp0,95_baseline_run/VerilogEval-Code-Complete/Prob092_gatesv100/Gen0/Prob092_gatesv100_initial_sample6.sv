module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // (1) out_both: in[i] & in[i+1] for i=0 to 98
  assign out_both = in[98:0] & in[99:1];

  // (2) out_any: in[i] | in[i-1] for i=1 to 99
  assign out_any = in[99:1] | in[98:0];

  // (3) out_different: in[i] ^ in[(i+1) % 100] with wrap-around
  assign out_different[99:0] = in ^ {in[98:0], in[99]};

endmodule