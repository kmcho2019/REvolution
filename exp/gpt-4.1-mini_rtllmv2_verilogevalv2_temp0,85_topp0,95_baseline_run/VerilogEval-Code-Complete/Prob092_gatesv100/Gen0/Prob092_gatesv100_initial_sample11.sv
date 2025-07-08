module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // out_both[i] = in[i] & in[i+1] for i=0 to 98
  assign out_both = in[98:0] & in[99:1];

  // out_any[i] = in[i] | in[i-1] for i=1 to 99
  assign out_any = in[99:1] | in[98:0];

  // out_different[i] = in[i] ^ in[left neighbor]
  // left neighbor of in[0] is in[99], so:
  // for i=1 to 99: left neighbor = in[i-1]
  // for i=0: left neighbor = in[99]
  assign out_different[99] = in[99] ^ in[98];
  assign out_different[98:1] = in[98:1] ^ in[97:0];
  assign out_different[0] = in[0] ^ in[99];

endmodule