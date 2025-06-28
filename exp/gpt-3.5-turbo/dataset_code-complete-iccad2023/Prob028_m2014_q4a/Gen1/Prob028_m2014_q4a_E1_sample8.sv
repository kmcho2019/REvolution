module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(d, ena)
    if (ena)
      q <= d;

endmodule