module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

// Simplified Boolean expression: out = !a & !c | a & b | b & d
assign out = (!a & !c) | (a & b) | (b & d);

endmodule