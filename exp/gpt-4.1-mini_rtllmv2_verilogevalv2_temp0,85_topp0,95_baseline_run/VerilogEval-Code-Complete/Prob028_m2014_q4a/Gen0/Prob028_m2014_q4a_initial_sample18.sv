module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(*) begin
    if (ena)
      q = d;
    // else retain q (no assignment means latch holds previous value)
  end

endmodule