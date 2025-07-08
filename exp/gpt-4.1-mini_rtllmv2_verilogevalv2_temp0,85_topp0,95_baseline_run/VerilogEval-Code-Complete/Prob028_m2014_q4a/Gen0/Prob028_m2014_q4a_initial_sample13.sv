module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(*) begin
    if (ena)
      q = d;
    // else q holds its value, so no assignment here
  end

endmodule