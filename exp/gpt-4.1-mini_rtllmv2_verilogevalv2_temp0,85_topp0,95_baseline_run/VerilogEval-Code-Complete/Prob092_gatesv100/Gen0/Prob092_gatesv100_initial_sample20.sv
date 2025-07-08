module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // (1) out_both[i] = in[i] & in[i+1], valid for i=0..98
  assign out_both = in[98:0] & in[99:1];

  // (2) out_any[i] = in[i] | in[i-1], valid for i=1..99
  assign out_any = in[99:1] | in[98:0];

  // (3) out_different[i] = in[i] ^ in[(i+1) mod 100], circular neighbor
  // Construct a vector shifted by 1 with wrap-around
  wire [99:0] in_rot = {in[98:0], in[99]};
  assign out_different = in ^ in_rot;

endmodule