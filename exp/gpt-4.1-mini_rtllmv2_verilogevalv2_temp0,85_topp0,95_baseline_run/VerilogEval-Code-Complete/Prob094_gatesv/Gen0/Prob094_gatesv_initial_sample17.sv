module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);

  // (1) out_both[i] = in[i] & in[i+1] for i=0..2 (neighbor to left is higher index)
  assign out_both = { (in[2] & in[3]),
                      (in[1] & in[2]),
                      (in[0] & in[1]) };

  // (2) out_any[i] = in[i] | in[i-1] for i=1..3 (neighbor to right is lower index)
  assign out_any = { (in[3] | in[2]),
                     (in[2] | in[1]),
                     (in[1] | in[0]) };

  // (3) out_different[i] = in[i] ^ in[left_neighbor], with wrap-around:
  // left neighbor of 3 is 0, so:
  // out_different[3] = in[3] ^ in[0]
  // out_different[i] = in[i] ^ in[i+1] for i=0..2
  assign out_different[3] = in[3] ^ in[0];
  assign out_different[2] = in[2] ^ in[3];
  assign out_different[1] = in[1] ^ in[2];
  assign out_different[0] = in[0] ^ in[1];

endmodule