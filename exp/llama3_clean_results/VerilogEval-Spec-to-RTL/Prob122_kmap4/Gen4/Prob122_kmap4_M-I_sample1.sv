module TopModule(a, b, c, d, out);
  input a;
  input b;
  input c;
  input d;
  output out;

  assign out = ((a ^ b) == 0 && (c ^ d) == 1) || ((c ^ d) == 0 && (a ^ b) == 1);
endmodule