module TopModule(a, b, c, d, q);
  input a;
  input b;
  input c;
  input d;
  output q;

  assign q = (a == 0 && (b || c)) || (a && (b || c));

  // Alternative way to express the same logic, considering the original statement
  // assign q = (b || c);

endmodule