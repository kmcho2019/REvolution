module TopModule(a, b, c, d, out);
  input a, b, c, d;
  output out;

  assign out = (a & ~b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & ~b & ~c & d);

  // However, the expression can be simplified as follows:
  // The rows where output is 1 are:
  // a'b'cd + a'bcd' + ab'c'd + ab'cd
  // Simplifying the expression:
  // a'b(cd + cd') + ab'(c + c')
  // a'b(c XOR d) + ab'(1)
  // a'b(c XOR d) + ab'
  assign out = (~a & ~b & (c ^ d)) | (a & ~b);

endmodule