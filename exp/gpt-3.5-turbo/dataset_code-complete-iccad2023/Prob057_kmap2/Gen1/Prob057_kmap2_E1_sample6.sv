module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  wire f1, f2, f3, f4;

  // Truth table: 
  // cdab: 0000, 0001, 0011, 0010, 0110, 0111, 0101, 0100, 1100, 1101, 1111, 1110, 1010, 1011, 1001, 1000
  // Output:   1,    1,    0,    1,    1,    0,    0,    1,    0,    1,    1,    0,    0,    1,    1,    0

  // Minimized expressions from the truth table:
  assign f1 = b & (~a) & d;
  assign f2 = (~b) & a & d;
  assign f3 = a & (~b) & (~d);
  assign f4 = b & (~a) & (~c);

  // Output based on minimized expressions
  assign out = f1 | f2 | f3 | f4;

endmodule