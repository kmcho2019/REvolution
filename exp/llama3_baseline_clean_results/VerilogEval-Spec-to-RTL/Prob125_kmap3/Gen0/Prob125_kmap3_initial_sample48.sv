module TopModule(a, b, c, d, out);
  input a;
  input b;
  input c;
  input d;
  output out;

  assign out = (~c & b) | (c & ((a & ~b) | (~a & b)));
endmodule