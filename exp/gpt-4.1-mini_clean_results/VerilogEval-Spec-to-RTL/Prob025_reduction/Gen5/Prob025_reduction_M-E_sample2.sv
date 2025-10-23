module TopModule(input [7:0] in, output parity);
  wire x1, x2, x3, x4, x5, x6, x7;

  assign x1 = in[0] ^ in[1];
  assign x2 = in[2] ^ in[3];
  assign x3 = in[4] ^ in[5];
  assign x4 = in[6] ^ in[7];

  assign x5 = x1 ^ x2;
  assign x6 = x3 ^ x4;

  assign x7 = x5 ^ x6;
  assign parity = x7;
endmodule