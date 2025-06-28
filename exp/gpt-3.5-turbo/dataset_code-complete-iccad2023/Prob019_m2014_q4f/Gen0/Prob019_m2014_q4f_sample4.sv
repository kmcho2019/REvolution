module TopModule (
  input in1,
  input in2,
  output logic out
);

  logic in2_inv;

  // Invert the signal in2
  assign in2_inv = !in2;

  // Implement the AND gate
  assign out = in1 & in2_inv;

endmodule