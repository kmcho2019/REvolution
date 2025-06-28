module TopModule (
  input in1,
  input in2,
  output logic out
);

  assign out = in1 & ~in2; // Using the '&' operator for AND and '~' operator for negation

endmodule