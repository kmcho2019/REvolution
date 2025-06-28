module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  assign out = (~c & d) | a;

endmodule