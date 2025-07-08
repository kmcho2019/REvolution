module TopModule (
  input d,
  input ena,
  output logic q
);

  always @(*) begin
    if (ena)
      q = d;
    // else q holds previous value implicitly in latch
  end

endmodule