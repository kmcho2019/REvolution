module TopModule (
  input d,
  input ena,
  output logic q
);

  always_ff @(posedge ena)
    if (ena)
      q <= d;

endmodule