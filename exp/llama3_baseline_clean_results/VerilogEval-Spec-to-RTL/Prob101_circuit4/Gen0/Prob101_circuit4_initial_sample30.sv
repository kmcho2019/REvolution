module TopModule(a, b, c, d, q);
  input a;
  input b;
  input c;
  input d;
  output q;

  assign q = (b || c) || (!a && !b && !c && d);

endmodule