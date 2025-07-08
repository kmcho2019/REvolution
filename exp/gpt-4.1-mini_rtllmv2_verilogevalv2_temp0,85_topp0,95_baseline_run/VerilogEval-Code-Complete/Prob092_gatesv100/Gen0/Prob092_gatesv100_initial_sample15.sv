module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // (1) out_both: check if both bit and left neighbor (higher index) are 1
  assign out_both = in[98:0] & in[99:1];

  // (2) out_any: check if either bit or right neighbor (lower index) is 1
  assign out_any = in[99:1] | in[98:0];

  // (3) out_different: XOR with left neighbor, wrapping around
  genvar i;
  generate
    for (i = 0; i < 100; i = i + 1) begin : diff_loop
      assign out_different[i] = in[i] ^ in[(i+1) % 100];
    end
  endgenerate

endmodule