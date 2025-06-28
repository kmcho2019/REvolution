module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out,
  output out_n
);

  wire and1_out, and2_out;

  // First Layer: AND Gates
  assign and1_out = a & b;
  assign and2_out = c & d;

  // Second Layer: OR Gate for the AND outputs
  assign out = and1_out | and2_out;

  // Inverted output
  assign out_n = ~out;

endmodule