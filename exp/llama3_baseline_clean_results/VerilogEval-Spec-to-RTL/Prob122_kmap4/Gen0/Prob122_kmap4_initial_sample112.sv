module TopModule(
  input  a,
  input  b,
  input  c,
  input  d,
  output out
);

assign out = (a && !b && !d) || (!a && !c && !d) || (b && c && !d) || (!a && c && d);

endmodule