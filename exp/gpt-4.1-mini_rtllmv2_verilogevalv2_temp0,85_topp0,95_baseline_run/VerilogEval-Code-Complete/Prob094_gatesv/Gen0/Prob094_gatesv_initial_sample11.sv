module TopModule (
  input [3:0] in,
  output [2:0] out_both,
  output [3:1] out_any,
  output [3:0] out_different
);

  // out_both[i] = in[i] & in[i+1], for i=0..2 (left neighbor is higher index)
  assign out_both = in[2:0] & in[3:1];

  // out_any[i] = in[i] | in[i-1], for i=1..3 (right neighbor is lower index)
  assign out_any = in[3:1] | in[2:0];

  // out_different[i] = in[i] ^ in[left neighbor], left neighbor with wrap-around:
  // left neighbor of in[3] is in[0], so neighbor vector is {in[0], in[3:1]}
  wire [3:0] left_neighbor = {in[0], in[3:1]};
  assign out_different = in ^ left_neighbor;

endmodule