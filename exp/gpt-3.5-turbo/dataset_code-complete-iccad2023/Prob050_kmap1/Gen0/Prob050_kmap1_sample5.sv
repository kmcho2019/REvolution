module TopModule (
  input a,
  input b,
  input c,
  output out
);

  wire m1, m2, m3, m4;

  assign m1 = ~b & ~c;
  assign m2 = a & b & ~c;
  assign m3 = a & ~b & c;
  assign m4 = a & b & c;

  assign out = m1 | m2 | m3 | m4;

endmodule