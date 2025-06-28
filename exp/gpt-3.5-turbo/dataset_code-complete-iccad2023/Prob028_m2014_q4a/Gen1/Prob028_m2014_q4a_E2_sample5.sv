module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(*)
    if (ena)
      q = d;

endmodule