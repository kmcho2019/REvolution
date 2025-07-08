module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // out_both[i] = in[i] & in[i+1], for i = 0 to 98
  assign out_both = in[98:0] & in[99:1];

  // out_any[i] = in[i] | in[i-1], for i = 1 to 99
  assign out_any = in[99:1] | in[98:0];

  // out_different[i] = in[i] ^ in[i_left] where i_left = (i+1) mod 100
  // To implement wrap-around, create a shifted version of 'in' by 1 to the left:
  // in_left = {in[98:0], in[99]}
  wire [99:0] in_left;
  assign in_left = {in[98:0], in[99]};

  assign out_different = in ^ in_left;

endmodule