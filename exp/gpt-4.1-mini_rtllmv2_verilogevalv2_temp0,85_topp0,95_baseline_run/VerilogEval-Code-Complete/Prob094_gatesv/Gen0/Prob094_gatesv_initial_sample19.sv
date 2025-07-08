module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);
  // out_both[i]: both in[i] and its left neighbor in[i+1] are 1, for i=0..2
  assign out_both = { (in[2] & in[3]), (in[1] & in[2]), (in[0] & in[1]) };

  // out_any[i]: either in[i] or its right neighbor in[i-1] is 1, for i=1..3
  assign out_any = { (in[3] | in[2]), (in[2] | in[1]), (in[1] | in[0]) };

  // out_different[i]: in[i] xor neighbor to the left in[(i+1)%4], wrapping around
  assign out_different[0] = in[0] ^ in[1];
  assign out_different[1] = in[1] ^ in[2];
  assign out_different[2] = in[2] ^ in[3];
  assign out_different[3] = in[3] ^ in[0];
endmodule