module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);

  // out_both[i] = in[i] & in[i+1], for i = 0 to 2
  assign out_both = in[2:0] & in[3:1];

  // out_any[i] = in[i] | in[i-1], for i = 1 to 3
  assign out_any = in[3:1] | in[2:0];

  // out_different[i] = in[i] ^ in[left neighbor], with wrap-around for i=0
  assign out_different[0] = in[0] ^ in[3];
  assign out_different[3:1] = in[3:1] ^ in[2:0];

endmodule