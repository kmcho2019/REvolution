module TopModule (
  input d,
  input ena,
  output logic q
);
  always @(*) begin
    if (ena)
      q = d;
    else
      q = q; // hold previous value
  end
endmodule