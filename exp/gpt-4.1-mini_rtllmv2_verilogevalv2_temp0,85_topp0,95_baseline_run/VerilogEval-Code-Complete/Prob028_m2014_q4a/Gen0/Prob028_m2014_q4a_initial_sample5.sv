module TopModule (
  input d,
  input ena,
  output logic q
);
  always @(*) begin
    if (ena)
      q = d;
    // else q retains its previous value (latch behavior)
  end
endmodule