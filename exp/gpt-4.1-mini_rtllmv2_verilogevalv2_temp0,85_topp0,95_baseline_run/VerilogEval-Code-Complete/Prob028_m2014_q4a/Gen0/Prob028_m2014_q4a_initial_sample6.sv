module TopModule (
  input d,
  input ena,
  output logic q
);
  always @ (ena or d) begin
    if (ena)
      q = d;
  end
endmodule