module TopModule(a, b, c, d, q);
  input a, b, c, d;
  output q;

  assign q = (a & (c | d)) | (b & (c | d)) | (a & b);

  // Alternatively, simplifying the expression further:
  // assign q = (a | b) & (c | d) | (a & b);

endmodule