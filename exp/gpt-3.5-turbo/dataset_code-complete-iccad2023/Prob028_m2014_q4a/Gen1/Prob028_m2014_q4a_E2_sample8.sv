module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(posedge ena or posedge d)
    if (ena)
      q <= d;

endmodule