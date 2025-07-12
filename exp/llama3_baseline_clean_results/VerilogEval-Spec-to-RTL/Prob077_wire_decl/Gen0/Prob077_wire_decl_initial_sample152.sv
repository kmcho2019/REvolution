module TopModule(a, b, c, d, out, out_n);
  input a, b, c, d;
  output out, out_n;
  wire and_out1, and_out2;

  assign and_out1 = a & b;
  assign and_out2 = c & d;
  assign out = and_out1 | and_out2;
  assign out_n = ~out;

endmodule