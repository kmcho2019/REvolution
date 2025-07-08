module TopModule (
  input x3,
  input x2,
  input x1,
  output f
);

  // f is 1 for inputs: 010, 011, 101, 111
  // So f = (!x3 & x2) | (x3 & x1)
  assign f = (~x3 & x2) | (x3 & x1);

endmodule