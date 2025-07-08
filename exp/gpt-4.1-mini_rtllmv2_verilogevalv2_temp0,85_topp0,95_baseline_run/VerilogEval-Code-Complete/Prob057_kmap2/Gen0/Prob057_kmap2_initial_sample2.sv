module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  assign out = (~d) | (d & ~(a ^ c));

endmodule