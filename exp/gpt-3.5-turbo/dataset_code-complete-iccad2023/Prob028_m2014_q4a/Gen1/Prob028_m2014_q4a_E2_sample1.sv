module TopModule (
  input d,
  input ena,
  output logic q
);

  always_ff @(posedge ena)
    q <= d;

endmodule